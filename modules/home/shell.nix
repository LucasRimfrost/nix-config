{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    # Native replacements for the two plugins you sourced from /usr/share
    # (those paths don't exist on NixOS):
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    enableCompletion = true;
    autocd = true;                  # AUTO_CD

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"                       # git aliases & helpers
        "sudo"                      # double-tap ESC to prepend sudo
        "history-substring-search"  # arrow keys search prior commands by prefix
        "colored-man-pages"
        "extract"                   # universal extract function
        "z"                         # jump to frequently-used directories
        "copypath"
      ];
    };

    history = {
      size = 50000;
      save = 50000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;                 # SHARE_HISTORY
      ignoreAllDups = true;         # HIST_IGNORE_ALL_DUPS
      ignoreSpace = true;           # HIST_IGNORE_SPACE
      saveNoDups = true;            # HIST_SAVE_NO_DUPS
      expireDuplicatesFirst = true; # HIST_EXPIRE_DUPS_FIRST
    };

    shellAliases = {
      # Editor
      vim = "nvim";
      vi = "nvim";

      # ls family
      ls = "ls --color=auto --group-directories-first";

      cat = "bat --style=plain";

      # Safe file ops
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Quick edits (zshconfig repointed at the Nix module — editing ~/.zshrc
      # does nothing on NixOS since it's a read-only store symlink)
      reload = "source $HOME/.zshrc";
      zshconfig = "$EDITOR $HOME/nix-config/modules/home/shell.nix";
      nvimconfig = "$EDITOR ~/.config/nvim";

      # NixOS helpers
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#lucas";
      update = "nix flake update --flake ~/nix-config && sudo nixos-rebuild switch --flake ~/nix-config#lucas";
    };

    initContent = lib.mkMerge [
      # ---- 550: early, before oh-my-zsh and the plugins load ----
      (lib.mkOrder 550 ''
        ZSH_DISABLE_COMPFIX="true"              # skip insecure-dir verification
        HYPHEN_INSENSITIVE="true"               # case-insensitive tab completion
        DISABLE_UNTRACKED_FILES_DIRTY="true"    # faster git status in big repos
        DISABLE_MAGIC_FUNCTIONS="true"          # skip slow paste-quoting wrappers

        # Nix owns oh-my-zsh from an immutable store path, so the updater can
        # never succeed - "reminder" would just nag on a 30-day cycle forever.
        zstyle ':omz:update' mode disabled

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

        # Cache completion results
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

        # zsh-autosuggestions tuning
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_USE_ASYNC=true
      '')

      # ---- 1200: general, after oh-my-zsh ----
      (lib.mkOrder 1200 ''
        # ls / file colors
        if command -v dircolors >/dev/null 2>&1; then
          if [[ -r ~/.dircolors ]]; then
            eval "$(dircolors -b ~/.dircolors)"
          else
            eval "$(dircolors -b)"
          fi
        fi
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        # cd to previous directory
        alias -- -='cd -'

        command -v tmux-sessionizer >/dev/null 2>&1 && alias tms='tmux-sessionizer'

        # Functions
        mkcd() { mkdir -p "$1" && cd "$1"; }
        backup() { cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"; }

        # setopts not covered by the history/autocd options above
        setopt HIST_VERIFY
        setopt HIST_REDUCE_BLANKS
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT
      '')
    ];
  };

  # CLI tools your aliases call
  home.packages = with pkgs; [
    bat     # cat
  ];

  # compinit silently skips caching if this directory doesn't exist
  home.file.".cache/zsh/.keep".text = "";

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
