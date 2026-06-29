{ config, pkgs, ... }:

{
  home.username      = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion  = "25.11";

  home.packages = with pkgs; [
    # ── Shell & prompt ─────────────────────────────────────────────────────
    fish
    zsh
    starship
    antidote

    # ── Editor ─────────────────────────────────────────────────────────────
    neovim

    # ── Git ────────────────────────────────────────────────────────────────
    git
    git-delta
    gh
    lazygit
    git-filter-repo

    # ── Dotfiles ───────────────────────────────────────────────────────────
    stow

    # ── Tmux & session manager ─────────────────────────────────────────────
    tmux
    sesh

    # ── Core CLI ───────────────────────────────────────────────────────────
    fzf
    fd
    bat
    eza
    ripgrep
    zoxide
    vivid
    jq

    # ── File manager & preview deps ────────────────────────────────────────
    yazi
    ffmpeg
    imagemagick
    poppler
    resvg
    p7zip
    ouch

    # ── Node ───────────────────────────────────────────────────────────────
    fnm       # manages Node versions
    pnpm      # package manager (aliased as pn in shells)

    # ── Go ─────────────────────────────────────────────────────────────────
    go        # GOPATH configured in .zshenv / env.fish

    # ── Python & Ruby version managers ────────────────────────────────────
    pyenv     # .zprofile: pyenv init
    rbenv     # .zprofile: rbenv init

    # ── Fonts ──────────────────────────────────────────────────────────────
    # Installed to ~/.nix-profile/share/fonts/ — picked up by fc-cache on Linux,
    # and by fontconfig on macOS when ghostty searches system fonts.
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only

  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    ghostty
  ];

  programs.home-manager.enable = true;
}
