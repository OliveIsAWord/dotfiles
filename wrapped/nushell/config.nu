let starship_installed = not (which starship | is-empty)

$env.config = {
  show_banner: false
  # use_ansi_coloring: false
  render_right_prompt_on_last_line: true
  # shell_integration: false
  hooks: {
    command_not_found: {
      |cmd_name| (
        if ($nu.os-info.name == "linux" and 'CNF' in $env) {try {
          let raw_results = (nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root $"/bin/($cmd_name)")
          let parsed = ($raw_results | split row "\n" | each {|elem| ($elem | parse "{attr}.{output}" | first) })
          let names = ($parsed | each {|row|
            if ($row.output == "out") {
              $row.attr
            } else {
              $"($row.attr).($row.output)"
            }
          })
          let names_display = ($names | str join "\n")
          (
            "nix-index found the follwing matches:\n\n" + $names_display
          )
        } catch {
          null
        }}
      )
    }
  }
  rm: {
    always_trash: true
  }
  table: {
    mode: compact
    index_mode: auto
  }
  completions: {
    quick: true
    partial: true
    case_sensitive: false
    algorithm: "fuzzy"
  }
  history: {
    file_format: "sqlite"
  }
  filesize: {
    metric: false
  }
  highlight_resolved_externals: true
}

if $starship_installed {
  $env.STARSHIP_SHELL = "nu"
  $env.STARSHIP_SESSION_KEY = (random chars -l 16)
  $env.STARSHIP_SESSION_KEY = (random chars -l 16)
  $env.PROMPT_MULTILINE_INDICATOR = (starship prompt --continuation)
  $env.PROMPT_INDICATOR = ""
  $env.PROMPT_COMMAND = {|| starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" }
  $env.PROMPT_COMMAND_RIGHT = ''
} else {}
