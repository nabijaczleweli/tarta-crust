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

Note: this was replaced with a netdata -> prometheus -> grafana stack on my machine, and so remains unmaintained.

![Output dir listing](https://user-images.githubusercontent.com/6709544/69073962-b1717e80-0a2e-11ea-9151-a32574f99017.png)
![Load 8-hour average](https://user-images.githubusercontent.com/6709544/69074021-db2aa580-0a2e-11ea-87e0-82d885010275.png)
![1-hour network traffic](https://user-images.githubusercontent.com/6709544/69074081-fac1ce00-0a2e-11ea-8b12-1f1cc1578f20.png)
![CPU 0 one-day usage](https://user-images.githubusercontent.com/6709544/69074713-36a96300-0a30-11ea-8dd7-73bc322d24eb.png)

## ksmctl

A Rust reimplementation of https://github.com/osuosl/fedpkg-qemu/blob/603dd6670b5fbb851ceac54b4bc9a10ec82a9c9d/ksmctl.c with systemd config from https://packages.debian.org/buster/ksmtuned.

Additional features:
  * `KSM_SLEEP_MILLISECS` in `/etc/default/ksm` => `/sys/kernel/mm/ksm/sleep_millisecs`

## r710_fan_controller

Modified version of Rich Gannon's [`r710_fan_controller.sh`](http://richgannon.net/projects/dellfanspeed), and a systemd unit.

```shell
nabijaczleweli@tarta:~$ sudo systemctl start r710_fan_controller.service
nabijaczleweli@tarta:~$ sudo systemctl status r710_fan_controller.service
● r710_fan_controller.service - R710 fan controller
   Loaded: loaded (/etc/systemd/system/r710_fan_controller.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2019-12-09 21:57:33 CET; 51min ago
 Main PID: 24411 (r710_fan_contro)
    Tasks: 2 (limit: 4915)
   Memory: 13.9M
   CGroup: /system.slice/r710_fan_controller.service
           ├─ 6444 sleep 5
           └─24411 /bin/sh /usr/sbin/r710_fan_controller.sh

Dec 09 21:57:33 tarta systemd[1]: Started R710 fan controller.
Dec 09 21:57:33 tarta r710_fan_controller.sh[24411]: Changing to fan level 3.
Dec 09 21:57:33 tarta r710_fan_controller.sh[24411]: Highest CPU core temperature: 52 Celcius.
Dec 09 21:57:33 tarta r710_fan_controller.sh[24411]: Highest drive temperature: 40 Celcius.
Dec 09 21:58:20 tarta r710_fan_controller.sh[24411]: Changing to fan level 2.
Dec 09 21:58:20 tarta r710_fan_controller.sh[24411]: Highest CPU core temperature: 47 Celcius.
Dec 09 21:58:20 tarta r710_fan_controller.sh[24411]: Highest drive temperature: 39 Celcius.
```

```shell
nabijaczleweli@tarta:~$ sudo systemctl stop r710_fan_controller.service
nabijaczleweli@tarta:~$ sudo systemctl status r710_fan_controller.service

# ………
Dec 09 22:49:10 tarta systemd[1]: Stopping R710 fan controller...
Dec 09 22:49:10 tarta r710_fan_controller.sh[24411]: Exit requested.
Dec 09 22:49:10 tarta r710_fan_controller.sh[24411]: Enabling iDRAC automatic fan control.
Dec 09 22:49:10 tarta systemd[1]: r710_fan_controller.service: Succeeded.
Dec 09 22:49:10 tarta systemd[1]: Stopped R710 fan controller.
```

## prep-buildd

Create an tmpfs-on-directory overlay mount over a chroot from "~/store/chroots", with `/proc` bind-mounted:
```shell
nabijaczleweli@tarta:~$ prep-buildd
No base!
Must be one of: sid-i386  sid-with-nab
nabijaczleweli@tarta:~$ prep-buildd sid-i386 neomutt
Preparing sid-i386-neomutt/...
[sudo] password for nabijaczleweli:
nabijaczleweli@tarta:~$ # Copy your build files in
nabijaczleweli@tarta:~$ sudo chroot sid-i386-neomutt/
root@tarta:/# # Do your build
root@tarta:/# exit
nabijaczleweli@tarta:~$ prep-buildd --undo sid-i386 neomutt
UnPreparing sid-i386-neomutt/...
```

The created environment is destroyed when `prep-buildd` is re-ran with --undo,
the upperdir is tmpfs, so no changes are propagated to the base chroot.

## gen-equiv-build-dep

Generate a simple [`equivs`](https://packages.debian.org/equivs) descriptor from `[$1/][debian/]control`,
declaring the same `Depends:` as the `Build-Depends:` contained therein.

## .config/htop

`htop` config, of [**@ThePhD**](https://github.com/ThePhD/dotfiles/commit/e64186c944b5f08ac9e0e2a8498498dccbd22707) fame.

[![htop screenshot 1](screenshots/htop-647541072033218611.png)](https://raw.githubusercontent.com/nabijaczleweli/topfig/master/screenshots/htop-647541072033218611.png)
[![htop screenshot 2](screenshots/htop-647540165316968467.png)](https://raw.githubusercontent.com/nabijaczleweli/topfig/master/screenshots/htop-647540165316968467.png)

## dpkg-linux-doc-strip-html

Makes dpkg ignore `/usr/share/doc/linux-doc-*/html` and the symlink in `linux-doc` during unpack if placed in `/etc/dpkg/dpkg.cfg.d`.
