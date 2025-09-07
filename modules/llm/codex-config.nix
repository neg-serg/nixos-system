_: {
  # System-wide Codex CLI configuration. Tools respecting XDG will read this from /etc/xdg.
  environment.etc."xdg/codex/config.yaml".text = ''
    # main settings
    auto-commits: false
    watch-files: true
    read:
      - CONVENTIONS.md
      - AI_RULES.md
    vim: true
    cache-prompts: true
    editor: hx
    architect: true

    # theme settings
    dark-mode: true
    code-theme: lightbulb

    ## Set the color for user input (default: #00cc00)
    user-input-color: '#A6DA95'

    ## Set the color for tool output (default: None)
    tool-output-color: '#CAD3F5'

    ## Set the color for tool error messages (default: #FF2222)
    tool-error-color: '#ED8796'

    ## Set the color for tool warning messages (default: #FFA500)
    tool-warning-color: '#EED49F'

    ## Set the color for assistant output (default: #0088ff)
    assistant-output-color: '#8AADF4'

    ## Set the color for the completion menu (default: terminal's default text color)
    completion-menu-color: '#7DC4E4'

    ## Set the background color for the completion menu (default: terminal's default background color)
    completion-menu-bg-color: '#5B6078'

    ## Set the color for the current item in the completion menu (default: terminal's default background color)
    completion-menu-current-color: '#8087A2'

    ## Set the background color for the current item in the completion menu (default: terminal's default text color)
    completion-menu-current-bg-color: '#7DC4E4'

    # models settings here
    model: deepseek/deepseek-reasoner
    editor-model: deepseek/deepseek-chat
    api-key:
    - deepseek=your_api_key # FIXME
  '';
}
