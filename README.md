# tarta-crust [![Licence](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
Just some crunch to make the experience that much better,
	or a couple [miseries](https://twitter.com/q3k/status/1187017050260213760) to help it slide down so much smoother.

Each subfolder contains a self-contained utility, as extracted from a living system, with the directory structure preserved from the root down.

## dnsmasq-adblock
Downloads and sanitises ad-blocking hosts,
	with the list extracted from [here](https://github.com/StevenBlack/hosts/tree/97c4b4877812f36a00c72de2bf21ada8b288ce9e/data),
	a config for dnsmasq and a weekly cronjob by default.

## rrd_graph
Generates rrd graphs, vaguely modelled after OMV's.

See `rrd_graph_config.sh` for configuration – default
	rrd database location is `/var/lib/rrdcached/db/$(hostname)`,
	collectd config in `/etc/collectd/collectd.conf.d/{subsystem}.conf`, and
	output directory is `/var/www/html/status/rrd`.

![Output dir listing](https://user-images.githubusercontent.com/6709544/69073962-b1717e80-0a2e-11ea-9151-a32574f99017.png)
![Load 8-hour average](https://user-images.githubusercontent.com/6709544/69074021-db2aa580-0a2e-11ea-87e0-82d885010275.png)
![1-hour network traffic](https://user-images.githubusercontent.com/6709544/69074081-fac1ce00-0a2e-11ea-8b12-1f1cc1578f20.png)
![CPU 0 one-day usage](https://user-images.githubusercontent.com/6709544/69074713-36a96300-0a30-11ea-8dd7-73bc322d24eb.png)

## ksmctl

A Rust reimplementation of https://github.com/osuosl/fedpkg-qemu/blob/603dd6670b5fbb851ceac54b4bc9a10ec82a9c9d/ksmctl.c with systemd config from https://packages.debian.org/buster/ksmtuned.

Additional features:
  * `KSM_SLEEP_MILLISECS` in `/etc/default/kvm` => `/sys/kernel/mm/ksm/sleep_millisecs`
