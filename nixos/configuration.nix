# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {


imports = [ # Include the results of the hardware scan.
	./hardware-configuration.nix
];

# Nix store cleanup. Keeps 10 most recent rollbacks. rest gets purged after 1 week
nix = {
  gc = {
    automatic = true;
    dates = "604800";  # 1 week (60 seconds * 60 minutes * 24 hours * 7 days)
    options = ''
      keep-rollback-generations 10
    '';
  };
};


# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking = {
	hostName = "zebby"; # machine name
	networkmanager.enable = true;
#	wireless.enable = true; # redundant if networkmanager enable
};

# Set your time zone.
time.timeZone = "Europe/Amsterdam";

# Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";
i18n.extraLocaleSettings = {
    	LC_ADDRESS = "nl_NL.UTF-8";
    	LC_IDENTIFICATION = "nl_NL.UTF-8";
   	LC_MEASUREMENT = "nl_NL.UTF-8";
    	LC_MONETARY = "nl_NL.UTF-8";
    	LC_NAME = "nl_NL.UTF-8";
    	LC_NUMERIC = "nl_NL.UTF-8";
    	LC_PAPER = "nl_NL.UTF-8";
    	LC_TELEPHONE = "nl_NL.UTF-8";
    	LC_TIME = "nl_NL.UTF-8";
};

# Enable Z-Shell
programs.zsh.enable = true;

services = { # System services to enable
	xserver.enable = true;
	displayManager.sddm.enable = true;
	power-profiles-daemon.enable = true;
};

programs.hyprland = {
	enable = true; 
	xwayland.enable = true;
};

# Hint Electon apps to use wayland
environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";
  	NIXOS_OZONE_WL = "1";
};

hardware = {
	opengl.enable = true;
	opengl.driSupport = true;
	opengl.driSupport32Bit = true;
	nvidia.modesetting.enable = true;
};

# Configure keymap in X11
services.xserver.xkb = {
    	layout = "us";
    	variant = "";
};

# Enable Microsof OneDrive
services.onedrive.enable = true;

# Enable CUPS to print documents.
services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
# services.blueman.enable = true; # Not needed with PLASMA
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

services.dbus.enable = true;
xdg.portal = {
  enable = true;
 # wlr.enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
};

fonts.packages = with pkgs; [
  nerdfonts
  meslo-lgs-nf
];

nixpkgs.overlays = [
  (self: super: {
    waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  })
];

nixpkgs.config.permittedInsecurePackages = [
	"electron-25.9.0"
	"electron-19.1.9"
];

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.lphoo = {
	isNormalUser = true;
	description = "Laurens Hoogenboom";
    	shell = pkgs.zsh;
	extraGroups = [ "networkmanager" "wheel" ];
    	packages = with pkgs; [
      		kate
		ungoogled-chromium
      		vscodium
      		latte-dock
      		obsidian    
      		spotify
		discord
    		teams-for-linux
		protonvpn-gui
		zotero
		typst
		typst-lsp
	];
};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
	zsh
	firefox
	kitty

	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	neovim
	zed-editor

	wget
	git	
	inkscape
	neofetch
	ranger

	hyprland
	waybar
	swww # for wallpapers
	xdg-desktop-portal-gtk
	xdg-desktop-portal-hyprland
	xwayland
	rofi-wayland
	pavucontrol # GUI sound audio controls
	networkmanagerapplet # GUI internet controls
	meson
	wayland-protocols
	wayland-utils
	wl-clipboard
	wlroots

	#bluetooth compatibility
	bluez #protocol stack
# Depricated	bluez-utils #for bluetoothctl cli
	bluetuith # terminal frontend
	blueman # GUI frontend
	power-profiles-daemon # Control Power Consumption
	brightnessctl # screen brightness controller service
	pulseaudioFull
	];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
