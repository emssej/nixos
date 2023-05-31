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
	kernelModules = [ "kvm-intel" ];

	initrd = {
	    availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage"
				       "usbhid" "sd_mod" "sr_mod" ];
	    luks.devices."crypted".device = "/dev/sda1";
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
	    device = "/dev/sda3";
	    fsType = "vfat";
	};
    };

    fonts = {
	enableDefaultFonts = true;
	enableGhostscriptFonts = true;
    };

    hardware = {
	cpu.intel.updateMicrocode =
	    lib.mkDefault config.hardware.enableRedistributableFirmware; 
	nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
	opengl.driSupport32Bit = true;

	bluetooth = {
	    enable = true;
	    package = pkgs.bluezFull;
	};
    };

    networking = {
	hostName = "Komputer-Emila";
	networkmanager.enable = true;
	useDHCP = lib.mkDefault true;
    };
    
    nix.settings = {
	cores = 4;
	max-jobs = lib.mkDefault 5;
    };

    nixpkgs = {
	config.allowUnfree = true;
	hostPlatform = lib.mkDefault "x86_64-linux";
    };

    programs = {
	adb.enable = true;
	file-roller.enable = false;
#	gnome-disks.enable = false;
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
	emacs.enable = true;
	gnome.gnome-browser-connector.enable = true;
	printing.enable = true;

	xserver = {
	    desktopManager.gnome.enable = true;
	    enable = true;
	    excludePackages = [ pkgs.xterm ];
	    layout = "pl";
	    videoDrivers = [ "nvidia" ];

	    displayManager.gdm = {
		enable = true;
		wayland = false;
	    };
	};
    };

    system = {
	stateVersion = "22.05";

	autoUpgrade = {
	    dates = "daily";
	    enable = true;
	};
    };

    users = {
	mutableUsers = false;

	extraUsers."emssej" = {
	    description = "Emil Kosz";
	    extraGroups = [ "wheel" "adbusers" "cdrom" "dialout" "pulse" "video" "networkmanager" ];
	    hashedPassword = "$6$cpcwbA063Q$GkfWogFrQ1/hcmwZcAq9bawyc1Z605sR7hyqYtWPXHYumt.szSz6BXVVbjxVc59S7OPUdk1dmOPMshRklNEXf.";
	    isNormalUser = true;
	    uid = 1337;

	    packages = with pkgs; [
		abiword
		appimage-run
		aspell
		audacity
		bada-bib
		bleachbit
		coolreader
		curl
		(dwarf-fortress-packages.dwarf-fortress-full.override {
		    theme = null;
		    enableIntro = false;
		    enableFPS = true;
		})
		evolution
		exaile
		file
		ghostscript
		gimp
		google-chrome
		gnumeric
		inkscape
		lmms
		lutris
		nicotine-plus
		pitivi
		steam-run
		tdesktop
		teams
		texmacs
		transmission-gtk
		unoconv
		unrar
		unzip
		vlc
		zip
	    ];
	};
    };
}
