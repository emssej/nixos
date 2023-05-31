{ config, lib, pkgs, modulesPath, ... }:

{
  documentation.dev.enable = true;
  i18n.defaultLocale = "pl_PL.UTF-8";
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  security.sudo.wheelNeedsPassword = false;
  swapDevices = [ { device = "/dev/sda2"; } ];
  time.timeZone = "Europe/Warsaw";

  environment.gnome.excludePackages = with pkgs.gnome; [
	baobab cheese epiphany geary gedit gnome-calculator gnome-calendar
	gnome-characters gnome-clocks gnome-contacts gnome-shell-extensions
	gnome-font-viewer gnome-logs gnome-music gnome-screenshot gnome-software
	gnome-weather totem simple-scan yelp
  ] ++ [ 
	pkgs.gnome-connections pkgs.gnome-text-editor pkgs.gnome-tour
	pkgs.gnome-photos
  ];

  boot = {
	  cleanTmpDir = true;
	  kernelModules = [ "kvm-amd" ];

	  initrd = {
	    availableKernelModules = [];
	    luks.devices."crypted".device = "";
	  };


	loader = {
	    efi.canTouchEfiVariables = true;
	    
	    systemd-boot = {
		configurationLimit = 5;
		consoleMode = "auto";
		enable = true;
		memtest86.enable = true;
	    };
	};
  };

  console = {
	  font = "Lat2-Terminus16";
	  keyMap = "pl";
  };

  fileSystems = {
	  "/" = {
	    device = "/dev/mapper/crypted";
	    fsType = "ext4";
	  };

	  "/boot" = {
	    device = "/dev/sda1";
	    fsType = "vfat";
	  };
  };

    fonts = {
	enableDefaultFonts = true;
	enableGhostscriptFonts = true;
    };

  hardware = {
	  cpu.amd.updateMicrocode = true;

	bluetooth = {
	    enable = true;
	    package = pkgs.bluezFull;
	};

	  opengl = {
	    driSupport = true;
	    driSupport32Bit = true;
	    enable = true;
	    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
	  };

	  pulseaudio = {
	    enable = true;
	    support32Bit = true;
	  };
  };

  networking = {
	  hostName = "Laptop-Emila";
	  networkmanager.enable = true;
	  useDHCP = lib.mkDefault true;
  };

  nix = {
	  buildCores = 4;
	  maxJobs = lib.mkDefault 5;
  };

  nixpkgs = {
    config.allowUnfree = true;
	  hostPlatform = lib.mkDefault "x86_64-linux";
  };
  
  programs = {
	  adb.enable = true;
	  file-roller.enable = false;
	seahorse.enable = false;
	  steam.enable = true;

	  bash = {
	    interactiveShellInit = "unset HISTFILE";
	    loginShellInit = "unset HISTFILE";
	    
	    undistractMe = {
		enable = true;
		playSound = true;
	    };
	  };

	  git = {
	    enable = true;
	    package = pkgs.gitMinimal;
	  };
  };
  
  services = {
  	gnome.gnome-browser-connector.enable = true;
	  printing.enable = true;

    emacs = {
      enable = true;
      defaultEditor = true;
      package = with pkgs; (emacsWithPackages (with emacsPackagesNg; [
      	nix-mode
      ]));
    };
    
	  xserver = {
      		desktopManager.gnome.enable = true;
      		displayManager.gdm.enable = true;
	    	enable = true;
	    	excludePackages = with pkgs; [ xterm ];
	    	layout = "pl";
	    	libinput.enable = true;
	    	videoDrivers = [ "amdgpu" ];
	  };
  };

  system = {
	  stateVersion = "22.11";

	  autoUpgrade = {
	    dates = "daily";
	    enable = true;
	  };
  };

  users = {
	  mutableUsers = false;

	  extraUsers."emssej" = {
	    description = "Emil Kosz";
	    extraGroups = [ "wheel" "adbusers" "cdrom" "dialout" "pulse" "video" "networkmanager" "audio" ];
	    hashedPassword = "$6$cpcwbA063Q$GkfWogFrQ1/hcmwZcAq9bawyc1Z605sR7hyqYtWPXHYumt.szSz6BXVVbjxVc59S7OPUdk1dmOPMshRklNEXf.";
	    isNormalUser = true;
	    uid = 1337;

	    packages = with pkgs; [
	    	abiword
	    	appimage-run
		aspell
		bleachbit
		curl
		evolution
		exaile
		file
		ghostscript
		gimp
		google-chrome
		gnumeric
        	netsurf.browser
		nicotine-plus
		steam-run
		tdesktop
		teams
		texmacs
		transmission-gtk
		unrar
		unzip
        	vlc
		zip

        gnomeExtensions.alphabetical-app-grid
        gnomeExtensions.hide-activities-button
        gnomeExtensions.openweather
        gnomeExtensions.vitals
	    ];
	  };
  };
}
