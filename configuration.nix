{ config, lib, pkgs, ... }:

{
  environment.gnome.excludePackages = with pkgs; [ pkgs.gnome-tour ];
  documentation.dev.enable = true;
  i18n.defaultLocale = "pl_PL.UTF-8";
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];
  powerManagement.cpuFreqGovernor = "performance";
  security.sudo.wheelNeedsPassword = false;
  swapDevices = [ { device = "/dev/sda2"; } ];
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
	  buildCores = 2;
	  maxJobs = lib.mkDefault 3;
  };

  nixpkgs = {
    config.allowUnfree = true;
	  hostPlatform = lib.mkDefault "x86_64-linux";
  };
  
  programs = {
	  adb.enable = true;
	  steam.enable = true;

	  bash = {
	    interactiveShellInit = "unset HISTFILE";
	    loginShellInit = "unset HISTFILE";
	  };

	  git = {
	    enable = true;
	    package = pkgs.gitMinimal;
	  };
  };
  
  services = {
	  printing.enable = true;

    emacs = {
      enable = true;
      defaultEditor = true;
      package = with pkgs; (emacsWithPackages (with emacsPackagesNg; [
      	nix-mode
      ]));
    };

    gnome = {
      core-utilities.enable = false;
      gnome-browser-connector.enable = false;
    };
    
	  xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
	    enable = true;
	    excludePackages = with pkgs; [ xterm ];
	    layout = "pl";
	    libinput.enable = true;
	    videoDrivers = [ "ati" ];
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
		    bleachbit
		    curl
		    file
        firefox-bin
        netsurf.browser
        pcmanfm
		    steam
		    steam-run
		    tdesktop
		    teams
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
