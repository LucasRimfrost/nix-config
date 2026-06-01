{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    # Native replacements for the two plugins you sourced from /usr/share
    # (those paths don't exist on NixOS):
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    enableCompletion = true;
    autocd = true; # AUTO_CD

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "history-substring-search"
        "command-not-found" # NOTE: stock OMZ version is Debian/Fedora-oriented;
                            #       see comment at the bottom for the NixOS-native option.
        "colored-man-pages"
        "extract"
        "z"
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
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      # Editor
      vim = "nvim";
      vi = "nvim";
      # ls family
      ls = "ls --color=auto --group-directories-first";
      ll = "ls -lh";
      la = "ls -lAh";
      l = "ls -CF";
      # Safe file ops
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      # Quick edits (zshconfig repointed at the Nix module — editing ~/.zshrc
      # does nothing on NixOS since it's a read-only store symlink)
      reload = "source $HOME/.zshrc";
      zshconfig = "$EDITOR $HOME/nix-config/modules/home/shell.nix";
      nvimconfig = "$EDITOR ~/.config/nvim";
      hyprconfig = "$EDITOR $HOME/.config/hypr/hyprland.conf"; # Hyprland leftover; you're on KDE now
      # Dev
      dev = "cd ~/dev/";
      # build.sh shortcuts
      b = "./build.sh";
      br = "./build.sh run";
      bc = "./build.sh clean";
      bcr = "./build.sh clean run";
      bf = "./build.sh fresh";
      bfr = "./build.sh fresh run";
      bd = "./build.sh debug";
      bdr = "./build.sh debug run";
      bcd = "./build.sh clean debug";
      bcdr = "./build.sh clean debug run";
      # NixOS helpers
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#lucas";
      update = "nix flake update --flake ~/nix-config && sudo nixos-rebuild switch --flake ~/nix-config#lucas";
    };

    initContent = lib.mkMerge [
      # ---- 550: early, before oh-my-zsh and the plugins load ----
      (lib.mkOrder 550 ''
        ZSH_DISABLE_COMPFIX="true"
        HYPHEN_INSENSITIVE="true"
        DISABLE_UNTRACKED_FILES_DIRTY="true"

        zstyle ':omz:update' mode auto
        zstyle ':omz:update' frequency 13
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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

        # Modern tool replacements (only if the tool is installed)
        command -v bat  >/dev/null 2>&1 && alias cat='bat --style=plain' && alias catt='bat'
        command -v rg   >/dev/null 2>&1 && alias grep='rg'
        command -v fd   >/dev/null 2>&1 && alias find='fd'
        command -v btm  >/dev/null 2>&1 && alias htop='btm'
        command -v dust >/dev/null 2>&1 && alias du='dust'
        command -v duf  >/dev/null 2>&1 && alias df='duf'
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

  # CLI tools your aliases call (ripgrep + fd are already in editor.nix).
  home.packages = with pkgs; [
    bat     # cat
    bottom  # btm
    du-dust # dust
    duf     # df
  ];

  # Extra PATH entries from your old .zshrc.
  # The TeXLive 2026 paths were dropped: install LaTeX via Nix instead
  # (ask me to add texliveMedium/Full to dev.nix and tex lands on PATH + man/info
  # automatically — far cleaner than /usr/local/texlive).
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.fly/bin"
  ];

  # EDITOR=nvim is already set via programs.neovim.defaultEditor (editor.nix).
  #
  # nvm was intentionally dropped: Node binaries that nvm downloads usually
  # fail on NixOS (dynamic-linker mismatch). Use the Nix `nodejs` from dev.nix,
  # or add `fnm`. Likewise `command-not-found`: the NixOS-native path is to
  # enable `programs.nix-index` + its database; ask and I'll wire it in.
}
