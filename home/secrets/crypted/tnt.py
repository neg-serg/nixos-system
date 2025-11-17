#!/usr/bin/python

row_format_header = "{0:<28}{1:<11}{2:<6}{3:<30}{4:<12}{5:<16}{6:<16}{7:<7}{8:<11}{9:<7}"
row_format_data = "{0:<24}{1:<20}{2:<15}{3:<39}{4:<12}{5:<25}{6:<25}{7:<7}{8:<11}{9:<7}"

import os
import re
import socket
import subprocess
import sys

# ips=subprocess.check_output("ip -o addr", shell=True)
ips = subprocess.Popen(["ip", "-o", "addr"], stdout=subprocess.PIPE).communicate()[0]
debug = False

baseCfgDir = "/etc/tarantool/instances.enabled"


class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    PURPLE = "\033[95m"
    CYAN = "\033[96m"
    DARKCYAN = "\033[36m"
    BLUE = "\033[94m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    UNDERLINE = "\033[4m"
    END = "\033[0m"


def format_bytes(size):
    power = 2**10
    n = 0
    power_labels = {0: "", 1: "KB", 2: "MB", 3: "GB", 4: "TB"}
    while size > power:
        size /= power
        n += 1
    return str(size) + power_labels[n]


def getInstancesList():
    instances = []

    listdir = os.listdir(baseCfgDir)
    for inst in listdir:
        if re.search("^tarantool_.*\.lua$", inst):
            instances.append(inst.lstrip("tarantool").lstrip("_").rstrip(".lua"))
    instances.sort()
    return instances


def getConfig(instance):
    cfg = {}
    cfg["instance"] = instance
    f = open(baseCfgDir + "/tarantool_" + instance + ".lua", "r")

    # split lines of config to key:value
    for line in f:
        name, var = line.partition("=")[::2]
        cfg[name.strip()] = var.rstrip(",\n").lstrip()

    # replace console with kv
    for key, value in cfg.items():  # iter on both keys and values
        if key.startswith("require('console').listen("):
            match = re.search("require\('console'\).listen.*:(\d+)", key)
            cfg["console"] = int(match.group(1))
            break

    # cut password from output
    if "replication" in cfg:
        match = re.search("([^:\s]+):.*@([\d\.\:]+)", cfg["replication"])
        if match:
            # cfg['replication']=(match.group(1) + match.group(2)).lstrip("'\"")
            cfg["replication"] = match.group(2).lstrip("'\"")
    else:
        cfg["replication"] = "None"
        if "replication_source" in cfg:
            match = re.search("([^:\s]+):.*@([\d\.\:]+)", cfg["replication_source"])
            if match:
                cfg["replication"] = match.group(2).lstrip("'\"")
        else:
            cfg["replication"] = "None"
    # fill master/replica vips
    if ("-- master_vip") in cfg:
        pass
    else:
        cfg["-- master_vip"] = "unknwn"
    if ("-- replica_vip") in cfg:
        pass
    else:
        cfg["-- replica_vip"] = "unknwn"

    return cfg


def getStatus(cfg):
    status = {}
    status["instance"] = cfg["instance"]
    # get running and ro status from box.info()
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect(("127.0.0.1", cfg["console"]))
        response = sock.recv(4096)
        sock.send(b"box.info().status\n")
        response = sock.recv(4096)
        match = re.search("- (\w+)", str(response))
        status["status"] = match.group(1)
    except Exception:
        status["status"] = "down"
        if debug:
            print("except get status/status")
        ps = subprocess.Popen(["ps", "-ef"], stdout=subprocess.PIPE).communicate()[0]
        match = re.search("tarantool_" + cfg["instance"] + ".lua <(\S+)>:", ps)
        if match:
            status["status"] = match.group(1)
    try:
        sock.send(b"box.info().server.ro\n")
        response = sock.recv(4096)
        match = re.search("- (\w+)", str(response))
        status["ro"] = match.group(1)
    except Exception:
        status["ro"] = "?"
        if debug:
            print("except get status/ro")
    # get arena status from box.slab.info()
    try:
        sock.send(b"box.slab.info()\n")
        response = sock.recv(4096)
        match = re.search("\s*arena_used_ratio:\s*(\S+)%", str(response))
        status["arena_used_ratio"] = match.group(1)
        match = re.search("\s*quota_used_ratio:\s*(\S+)%", str(response))
        if match:
            status["quota_used_ratio"] = match.group(1)
        else:
            status["quota_used_ratio"] = "not_impl"
        match = re.search("\s*quota_size:\s*(\d+)", str(response))
        status["quota_size"] = match.group(1)
    except Exception:
        status["arena_used_ratio"] = "?"
        status["quota_used_ratio"] = "?"
        status["quota_size"] = "0"
        if debug:
            print("except get status/arena")

    # get replication status
    try:
        sock.send(b"box.info().replication\n")
        response = sock.recv(4096)
        splt = response.decode().split("\n")
        matched = False
        for i in range(len(splt)):
            match = re.search("upstream:", splt[i])
            if match:
                matched = True
                line = splt[i + 1]
                match = re.search("\s*status:\s*(\S+)", line)
                if match:
                    status["repl_status"] = match.group(1)
                else:
                    status["repl_status"] = "not_repl"

                line = splt[i + 2]
                match = re.search("\s*idle:\s*(\S+)", line)
                if match:
                    status["repl_idle"] = match.group(1)
                else:
                    status["repl_idle"] = "not_idle"

                line = splt[i + 3]
                match = re.search("\s*peer:\s*\S*@(\S+)", line)
                if match:
                    status["peer"] = match.group(1)
                else:
                    status["peer"] = "not_repl"

                line = splt[i + 4]
                match = re.search("\s*lag:\s*(\S+)", line)
                if match:
                    status["repl_lag"] = match.group(1)
                else:
                    status["repl_lag"] = "not_repl"
                match = re.search("e(\S+)", line)
                if match:
                    status["repl_lag"] = status["repl_lag"][0:1] + "e" + match.group(1)

                break
        if matched == False:
            status["repl_status"] = ""
            status["repl_lag"] = ""
            status["repl_idle"] = ""
    except Exception:
        status["repl_status"] = "?"
        status["repl_lag"] = "?"
        status["repl_idle"] = "0"
        if debug:
            print("except get status/replication")
    sock.close()

    # check if master/replica vips are up
    if re.search((cfg["-- master_vip"] + "/").encode(), ips):
        status["master_vip_up"] = True
    else:
        status["master_vip_up"] = False
    if re.search((cfg["-- replica_vip"] + "/").encode(), ips):
        status["replica_vip_up"] = True
    else:
        status["replica_vip_up"] = False

    return status


def console(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances
    for instance in instances:
        print("console", instance)
        cfg = getConfig(instance)
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(("127.0.0.1", cfg["console"]))
        if args.c == None:
            print("enter commands. end with empty line.")
        while True:
            response = sock.recv(4096)
            print(response.decode())
            if args.c:
                for arg in args.c:
                    print(arg)
                    sock.send((arg + "\n").encode())
                    response = sock.recv(4096)
                    print(response.decode())
                break
            line = sys.stdin.readline()
            if line == "\n":
                break
            else:
                sock.send(line.encode())
        sock.close()


def tail(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    logs = ["/usr/bin/tail"]
    if args.f:
        logs.append("-f")

    for instance in instances:
        logs.append("/var/tarantool_{}/logs/tarantool_{}.log".format(instance, instance))
    os.system(" ".join(logs))


def replica_vip_down(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        cfg = getConfig(instance)
        os.system(
            "/usr/bin/grep -lw IPADDR="
            + cfg["-- replica_vip"].encode()
            + " /etc/sysconfig/network-scripts/ifcfg-* | /usr/bin/grep -P -o '[\d\w]+$' | /usr/bin/xargs -n 1 -t /usr/sbin/ifdown  2>&1 >> tnt.log"
        )


def replica_vip_up(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        cfg = getConfig(instance)
        # interface="vip$(ip -o link show | \
        #      perl -ne 'BEGIN { $max = 0 } $max = $1 if /vip(\d+):/ && $1 > $max; END { print $max }')"

        os.system(
            "/usr/bin/grep -lw IPADDR="
            + cfg["-- replica_vip"].encode()
            + " /etc/sysconfig/network-scripts/ifcfg-* | /usr/bin/grep -P -o '[\d\w]+$' | /usr/bin/xargs -n 1 -t /usr/sbin/ifup  2>&1 >> tnt.log"
        )


def master_vip_down(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        cfg = getConfig(instance)
        os.system(
            "/usr/bin/grep -lw IPADDR="
            + cfg["-- master_vip"].encode()
            + " /etc/sysconfig/network-scripts/ifcfg-* | /usr/bin/grep -P -o '[\d\w]+$' | /usr/bin/xargs -n 1 -t /usr/sbin/ifdown  2>&1 >> tnt.log"
        )


def master_vip_up(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        cfg = getConfig(instance)
        os.system(
            "/usr/bin/grep -lw IPADDR="
            + cfg["-- master_vip"].encode()
            + " /etc/sysconfig/network-scripts/ifcfg-* | /usr/bin/grep -P -o '[\d\w]+$' | /usr/bin/xargs -n 1 -t /usr/sbin/ifup  2>&1 >> tnt.log"
        )


def stop(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        os.system("systemctl stop  tarantool@tarantool_" + instance + ".service 2>&1 >> tnt.log")


def start(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        os.system("systemctl start tarantool@tarantool_" + instance + ".service  2>&1 >> tnt.log")


def restart(args):

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances

    for instance in instances:
        os.system("systemctl stop tarantool@tarantool_" + instance + ".service 2>&1 >> tnt.log")
        os.system("systemctl start tarantool@tarantool_" + instance + ".service 2>&1 >> tnt.log")


def snapshot(args):

    args.c = ["box.snapshot()"]
    console(args)


def showStatus(args):
    print(
        row_format_header.format(
            *[
                bcolors.BOLD + "instance",
                "status",
                "ro",
                "replica_of",
                "adm/listen",
                "master_vip",
                "replica_vip",
                "arena",
                "arena_used",
                "quota_used" + bcolors.ENDC,
            ]
        )
    )

    if len(args.instances) == 0:
        args.instances.append("all")

    if args.instances[0] == "all":
        instances = getInstancesList()
    else:
        instances = args.instances
    for instance in instances:
        line = []

        cfg = getConfig(instance)
        status = getStatus(cfg)

        line.append(cfg["instance"])

        if status["status"] == "running":
            strn = bcolors.GREEN + "running"
        else:
            strn = bcolors.RED + status["status"]
        strn += bcolors.ENDC
        line.append(strn)

        if status["ro"] == "true":
            strn = bcolors.YELLOW + "ro"
        else:
            strn = bcolors.GREEN + status["ro"]
        strn += bcolors.ENDC
        line.append(strn)

        if status["repl_status"] == "follow":
            line.append(
                status["peer"] + " flw:" + status["repl_lag"][0:5] + bcolors.YELLOW + bcolors.ENDC
            )
        else:
            line.append(
                cfg["replication"] + " " + bcolors.YELLOW + status["repl_status"] + bcolors.ENDC
            )

        line.append(str(cfg["console"]) + "/" + str(cfg["listen"]))

        if status["master_vip_up"]:
            strn = bcolors.GREEN
        else:
            strn = bcolors.RED
        strn += cfg["-- master_vip"] + bcolors.END
        line.append(strn)

        if status["replica_vip_up"]:
            strn = bcolors.GREEN
        else:
            strn = bcolors.RED
        strn += cfg["-- replica_vip"] + bcolors.ENDC
        line.append(strn)

        # line.append(format_bytes(eval(cfg['memtx_memory'])))
        line.append(format_bytes(int(status["quota_size"])))
        line.append(status["arena_used_ratio"] + "%")
        line.append(status["quota_used_ratio"] + "%")

        # print(line)

        print(row_format_data.format(*line))


######################################

# https://docs.python.org/3/library/argparse.html#other-utilities

import argparse

parser = argparse.ArgumentParser(description="tnt python utility")

parser.add_argument("-d", "--d", action="store_true", help="enable debug")

subparsers = parser.add_subparsers(
    title="subcommands", description="valid subcommands", help="additional help"
)

parser_status = subparsers.add_parser("status", help="status of tarantools")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=showStatus)

parser_console = subparsers.add_parser("console", help="console commands")
parser_console.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_console.add_argument(
    "-c", "--c", type=str, nargs="+", help='commands pass to console. for example --c "box.info()"'
)
parser_console.set_defaults(func=console)

parser_tail = subparsers.add_parser("tail", help="tarantool log tailing")
parser_tail.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_tail.add_argument("-f", "--f", action="store_true", help='continious tailing"')
parser_tail.set_defaults(func=tail)

parser_status = subparsers.add_parser("replica_vip_up", help="replica_vip_up")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=replica_vip_up)

parser_status = subparsers.add_parser("replica_vip_down", help="replica_vip_down")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=replica_vip_down)

parser_status = subparsers.add_parser("master_vip_up", help="master_vip_up")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=master_vip_up)

parser_status = subparsers.add_parser("master_vip_down", help="master_vip_down")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=master_vip_down)

parser_status = subparsers.add_parser("stop", help="stops instance")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=stop)

parser_status = subparsers.add_parser("start", help="starts instance")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=start)

parser_status = subparsers.add_parser("restart", help="restarts instance")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=restart)

parser_status = subparsers.add_parser("snapshot", help="snapshots instance")
parser_status.add_argument("instances", type=str, nargs="*", help="optional instance name or all")
parser_status.set_defaults(func=snapshot)

args = parser.parse_args()

# print(args)

if args.d:
    debug = True

args.func(args)
