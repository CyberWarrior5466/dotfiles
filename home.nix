{ config, pkgs, unstable, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  fonts.fontconfig.enable = true;

  home.username = "alis";
  home.homeDirectory = "/home/alis";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    ANKI_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  home.file.".gitconfig".source = ~/Dropbox/dotfiles/.gitconfig;

  home.packages = (with pkgs; [
    # gui programs
    eyedropper
    foliate
    gnome.pomodoro
    gnomeExtensions.pano
    maestral
    maestral-gui
    kitty

    # c/c++
    clang-tools
    gnat
    gnumake
    lldb

    # java
    jdt-language-server
    maven

    # python
    nodePackages.pyright
    python311
    ruff-lsp
    ruff

    # web
    biome
    nodePackages.typescript-language-server
    typescript
    vscode-langservers-extracted

    # other languages
    dockerfile-language-server-nodejs
    ghc
    haskell-language-server
    lemminx
    lua-language-server
    markdownlint-cli
    nil
    nixpkgs-fmt
    nodePackages.bash-language-server
    rustup

    # cli programs
    direnv
    eza
    fd
    fzf
    git
    man-pages
    moreutils
    nixfmt
    nmap
    ripgrep
    sqlite-interactive
    tesseract4
    trash-cli
    unzip
    wl-clipboard

  ]) ++ (with unstable; [
    eclipses.eclipse-java
    gh
    glab
    jdk22
    vscode-fhs
  ]);

  # `dconf watch /` or `dconf dump / | dconf2nix`
  dconf.settings = {
    "org/gnome/desktop/input-sources".xkb-options =
      [ "terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock" ];

    "org/gnome/desktop/interface".enable-hot-corners = true;

    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;

    "org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];
    "org/gnome/mutter".dynamic-workspaces = true; 

    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    ];

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>t";
        command = "kitty";
        name = "Open Terminal";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Super>e";
        command = "nautilus";
        name = "Open Files";
      };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      diff = "nvim -d";
      find = "fd";
      grep = "rg";
      ls = "eza";
      tree = "eza --tree";
    };
    interactiveShellInit = ''
      function prompt_hostname --description 'short hostname for the prompt'
          if set -q IN_NIX_SHELL
              echo nix-shell
          else
              string replace -r "\..*" "" $hostname
          end
      end
    '';
  };

  programs.home-manager.enable = true;

  # programs.kitty = {
  #   enable = true;
  #   font.name = "Source Code Pro";
  #   font.package = pkgs.source-code-pro;
  #   settings.allow_remote_control = "yes";
  #   shellIntegration.enableFishIntegration = true;
  #   theme = "Adwaita light";
  # };

 programs.neovim = {
    defaultEditor = true;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # friendly-snippets
      # indent-blankline-nvim
      # nvim-treesitter-textobjects
      # vim-rhubarb
      # which-key-nvim

      adwaita-nvim
      auto-save-nvim
      cmp-nvim-lsp
      comment-nvim
      fidget-nvim
      gitsigns-nvim
      luasnip
      markdown-preview-nvim
      none-ls-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      vim-easy-align
      vim-fugitive
      vim-sleuth
    ];
    viAlias = true;
    vimAlias = true;
  };

  xdg.userDirs = {
    enable = true;
    documents = "${config.home.homeDirectory}/Dropbox/Documents";
    pictures = "${config.home.homeDirectory}/Dropbox/Pictures";
  };
}
