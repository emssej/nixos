{ config, lib, pkgs, ... }:

{
    documentation.dev.enable = true;
    i18n.defaultLocale = "pl_PL.UTF-8";
    imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];
    powerManagement.cpuFreqGovernor = "performance";
    security.sudo.wheelNeedsPassword = false;
    swapDevices = [ { device = "/dev/sda2"; } ];
    system.stateVersion = "22.11";
    time.timeZone = "Europe/Warsaw";
    
    boot = {
	cleanTmpDir = true;
	kernelModules = [ "kvm-amd" ];
	kernelParams = [ "mitigations=off" ];

	initrd = {
	    availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
	    luks.devices."crypted".device = "/dev/sda3";
	};

	loader.grub = {
	    device = "/dev/sda";
	    enable = true;
	    memtest86.enable = true;
	    version = 2;
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
	    fsType = "ext4";
	};
    };

    hardware = {
	cpu.amd.updateMicrocode = true;

	opengl = {
	    driSupport = true;
	    driSupport32Bit = true;
	    enable = true;
	    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
	};
    };

    networking = {
	hostName = "Laptop-Emila";
	networkmanager.enable = true;
	useDHCP = lib.mkDefault true;
    };

    nix = {
	buildCores = 2;
	maxJobs = lib.mkDefault 3;
    };

    nixpkgs = {
	config.allowUnfree = true;
	hostPlatform = lib.mkDefault "x86_64-linux";
    };
    
    programs = {
	adb.enable = true;
	nm-applet.enable = true;
	steam.enable = true;
	
	bash = {
	    interactiveShellInit = "unset HISTFILE";
	    loginShellInit = "unset HISTFILE";
	};

	git = {
	    enable = true;
	    packages = pkgs.gitMinimal;
	};
    };
    
    services = {
	printing.enable = true;

	xserver = {
	    enable = true;
	    excludePackages = with pkgs; [ xterm ];
	    layout = "pl";
	    libinput.enable = true;
	    videoDrivers = [ "ati" ];
	    windowManager.exwm.enable = true;
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
	    extraGroups = [ "wheel" "adbusers" "cdrom" "dialout" "pulse" "video" "networkmanager" ];
	    hashedPassword = "$6$cpcwbA063Q$GkfWogFrQ1/hcmwZcAq9bawyc1Z605sR7hyqYtWPXHYumt.szSz6BXVVbjxVc59S7OPUdk1dmOPMshRklNEXf.";
	    isNormalUser = true;
	    uid = 1337;

	    packages = with pkgs; [
		bleachbit
		curl
		file
		firefox-bin
		steam
		steam-run
		tdesktop
		teams
		transmission-gtk
		unrar
		unzip
		zip
	    ];
	};
    };
}
