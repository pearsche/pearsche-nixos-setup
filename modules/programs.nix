{ lib, pkgs, ... }:{
	programs = {
		mtr.enable = true;
		fish = {
			enable = true; 
			useBabelfish = true;
		};
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		};
		adb.enable = true;
		usbtop.enable = true;
		atop = {
			enable = true;
			setuidWrapper.enable = true;
			atopService.enable = true;
			atopacctService.enable = true;
			# Nah, only supports Nvidia. #intelFTW
			#atopgpu.enable = true;
			netatop.enable = true;
		};
		# Gnome area
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		gnome-terminal.enable = true;
		calls.enable = true;
	};
}