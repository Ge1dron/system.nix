# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = true;  
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ 
    "nix-command" "flakes" 
  ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leshii = {
    isNormalUser = true;
    description = "Leshii";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd"];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "leshii";

  # Install firefox.
  programs.firefox.enable = true;
  programs.adb.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    programs.tmux = {
      enable = true;
      clock24 = true;
      shortcut = "a";
      plugins = with pkgs.tmuxPlugins; [
            vim-tmux-navigator # CTRL+HJKL для переключения в стороны
            sensible # делает фигню с кнопкой ESC и чинит цвета
            dracula # твоя тема
        ];
    };

    environment.sessionVariables = {  DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
};

        # Nvidia Configuration 
         services.xserver.videoDrivers = [ "nvidia" ]; 
         hardware.graphics.enable = true; 
    hardware.nvidia.open = true;
      
         # Optionally, you may need to select the appropriate driver version for your specific GPU. 
         hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway 
         hardware.nvidia.modesetting.enable = true; 
      
         hardware.nvidia.prime = { 
           sync.enable = true; 
      
           # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
           nvidiaBusId = "PCI:01:00:0"; 
      
           # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
           intelBusId = "PCI:00:02:0"; 
         };


    environment.systemPackages = with pkgs; [
    
    arduino-ide
    arduino-core

    telegram-desktop

    nodejs_20
    gcc 
    gfortran13
    rubyPackages.rails
    dotnet-sdk

    wezterm
    obsidian
    scrcpy
    qpwgraph
    vscode
    blender
    
    python3Full
    python3
    python3.pkgs.matplotlib
    python3.pkgs.numpy
    
    gnuradio
    pkgs.rtl-sdr
    gqrx
    zip
    unzip
    clang-tools
    rubyPackages.solargraph
    bat
    masterpdfeditor
    rPackages.Anaconda
    
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
    
    (pkgs.writeShellScriptBin "rebuild" "sudo nixos-rebuild switch --flake /etc/nixos")
    (pkgs.writeShellScriptBin "update" ''
      cd /etc/nixos/
      nix flake update
      rebuild
    '')
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
    programs.steam.enable = true;
  programs.git.enable = true;
  programs.git.config = {
    init = {
      defaultBranch = "main";
      };
    user = {
      name = "leshii";
      email = "shishkov.dimentr@inbox.ru";
    };
  };

  programs.nvf = {
    enable = true;

    settings.vim = {
      # Цвета
      theme.enable = true;
      theme.name = "dracula";
      options.shiftwidth = 4;

      # Поддержка языков
      treesitter.enable = true;
      languages = {
        enableLSP = true;
        enableFormat = true;
        enableExtraDiagnostics = true;
        enableTreesitter = true;
    
        clang.enable = true;
        ruby.enable = true;
        nix.enable = true;
        # все остальные просто название-языка.enable = true;
      };
  
      # Подсказки
      binds.whichKey.enable = true; # Подсказки по самому виму (при нажатии пробела)
  
      autocomplete.nvim-cmp.enable = true; # Подсказки по Ctrl + Space в insert-режиме
      lsp.mappings = {
        goToDefinition = "<leader>gd"; # Перейти к определению функции
        hover = "<leader>k"; # Справка по функции
        renameSymbol = "<leader>r"; # Переименовать переменную / функцию / модуль
      };
  
      telescope = {
        enable = true;
        mappings.buffers = "<leader>b"; # Список открытых файлов (типо вкладок)
        mappings.findFiles = "<leader>f"; # Поиск по файлам проекта
        mappings.liveGrep = "<leader>/"; # Поиск по их содержимому
        mappings.lspReferences = "<leader>gr"; # Перейти к местам использования функции
      };
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
	services.syncthing = {
	  enable = true;
	  openDefaultPorts = true;
	};
	programs.bash.promptInit = ''PS1="\e[01;32m\u\e[00m@\h: \w\a "'';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
