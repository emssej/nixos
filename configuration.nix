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
		pkgs.gnome-photos pkgs.snapshot
	];

	boot = {
		kernelModules = [ "kvm-intel" ];
		tmp.cleanOnBoot = true;

		initrd = {
			availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage"
												"usbhid" "sd_mod" "firewire-ohci" ];
			luks.devices."crypted".device = "/dev/sda1";
		};

		loader = {
			efi.canTouchEfiVariables = true;

			systemd-boot = {
				configurationLimit = 5;
				editor = false;
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
		enableDefaultPackages = true;
		enableGhostscriptFonts = true;
	};

	hardware = {
		bluetooth.enable = true;
		cpu.intel.updateMicrocode =
			lib.mkDefault config.hardware.enableRedistributableFirmware; 
		opengl.driSupport32Bit = true;
	};

	networking = {
		hostName = "Komputer-Ze-Smieci";
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
		seahorse.enable = false;
		steam.enable = true;

		nano.nanorc = ''
			set autoindent
			set cutfromcursor
			set guidestripe 80
			set indicator
			set linenumbers
			set minibar
			set mouse
			set nohelp
			set saveonexit
			set tabsize 3
		'';

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
		printing.enable = true;

		xserver = {
			desktopManager.gnome.enable = true;
			enable = true;
			excludePackages = [ pkgs.xterm ];
			layout = "pl";
			videoDrivers = [ "nouveau" ];

			displayManager.gdm = {
				enable = true;
				wayland = true;
			};
		};
	};

	system = {
		stateVersion = "23.11";

		autoUpgrade = {
			dates = "daily";
			enable = true;
		};
	};

	users = {
		mutableUsers = false;

		extraUsers."emssej" = {
			description = "Emil Kosz";
			extraGroups = [ "wheel" "adbusers" "cdrom" "dialout" "pulse" "video"
								"networkmanager" ];
			hashedPassword = "$6$cpcwbA063Q$GkfWogFrQ1/hcmwZcAq9bawyc1Z605sR7hyqYtWPXHYumt.szSz6BXVVbjxVc59S7OPUdk1dmOPMshRklNEXf.";
			isNormalUser = true;
			uid = 1337;

			packages = with pkgs; [
				gnomeExtensions.alphabetical-app-grid
				gnomeExtensions.freon

				appimage-run
				audacity
				bleachbit
				curl
				dia
				evolution
				file
				gimp
				godot_4
				google-chrome
				inkscape
				lmms
				nicotine-plus
				onlyoffice-bin
				steam-run
				tdesktop
				teams-for-linux
				transmission-gtk
				vlc
			];
		};
	};
}
