{ lib, pkgs, ... }:
{
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/opentype/Inter-Regular.otf";
		};
		kernel.sysctl = {
			# Memory
			# Disable swap read ahead, increases latency when dealing with swap and it's rather meaningless when using zram+zstd anyway
			"vm.page-cluster" = 0;
			# Hugepages configuration, mostly for xmrig
			"vm.nr_hugepages" = 25;
			"vm.nr_overcommit_hugepages" = 150;
			# Prefer to keep application memory over filesystem cache memory
			"vm.vfs_cache_pressure" = 250;
			# Maximum swappiness
			"vm.swappiness" = 200;
			# Set the bytes of my current laptop's storage speed
			"vm.dirty_bytes" = 1000000000;
			"vm.dirty_background_bytes" = 1800000000;
			# 5% physical ram / # of threads
			"vm.min_free_kbytes" = 77050;
			# Best value, according to phoronix
			"vm.page_lock_unfairness" = 3;
			# Disable watermark boosting
			#"vm.watermark_boost_factor" = 0; # Needed when not using the zen-kernel
			# Increase kswapd activity
			"vm.watermark_scale_factor" = 375;
			# Increase the compaction activity slightly
			"vm.compaction_proactiveness" = 25;
			# Compact also unevictable memory (testing)
			#"vm.compact_unevictable_allowed" = 1;
			# Fedora change, for some games. Shouldn't affect most things
			# Higher memory map count for some games that need it
			# https://www.phoronix.com/news/Fedora-39-Max-Map-Count-Approve
			"vm.max_map_count" = 1048576;

			# Internet
			"net.ipv4.tcp_fastopen" = 3;
			"net.ipv4.tcp_low_latency" = 1;
			"net.ipv4.tcp_ecn" = 1;
			"net.ipv4.tcp_congestion_control" = "bbr";

			# Cpu
			#"kernel.sched_child_runs_first" = 1;
			#"kernel.sched_cfs_bandwidth_slice_us" = 3000;
			#"kernel.perf_cpu_time_max_percent" = 3;
			
			# Intel GPU
			# Disable the paranoid mode over some stats
			"dev.i915.perf_stream_paranoid" = 0;
		};
		initrd = {
			availableKernelModules = [ "i915" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
				devices = {
					"Taihou-Disk" = {
						device = "/dev/disk/by-uuid/b9d5979c-bd51-4b40-a759-d24cce9e4c09";
						allowDiscards = true;
						bypassWorkqueues = true;
					};
				};
			};
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-pearsche;
		# TODO: currently using the 6.3 kernel because 6.4 has the audio bug.
		#kernelPackages = pkgs.linuxPackages_6_3;
		kernelParams = [ 
			# Find out whether this is a good idea or not
			#"pcie_aspm=force"
			"preempt=full"
			"i915.enable_guc=2"
			"i915.enable_psr2_sel_fetch=1"
			"iwlwifi.power_save=Y"
			"zswap.enabled=Y"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=25"
			"zswap.accept_threshold_percent=95"
		];
		loader = {
			systemd-boot = {
				enable = true;
				# configurationLimit = 10;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};
		};
	};
}
