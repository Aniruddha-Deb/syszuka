# Syszuka

<div align="center">
<img src="logo.png" alt="Syszuka Logo" style="text-align: center; width: 30%; max-width: 150px;">
<div><br></div>
<div><em>A racetrack for profiling your code</em></div>
</div>

## Intro

Syszuka is a minimal [buildroot][3] image (kernel + rootfs) that can be used to profile applications. 
The main motivation for using this is to increase determinism and eliminate 
system noise when profiling applications. Similar to [Sushi Roll][2], but without 
having to write your own kernel

## Features

* [X] Minimal (<30MB) kernel+rootfs (glibc, no systemd)
* [X] Small footprint enables booting remotely without reimaging disk and operating purely in memory
* [X] SSH tools (`dropbear`, `gesftpserver`, `rsync`) enabled for remote usage
* [X] `perf` enabled for easy profiling
* [X] `taskset` for core pinning
* [X] Kernel processor mitigations completely disabled for microarchitecture experiments
* [X] [`tsc_freq_khz`][1] module preconfigured to read TSC freq from `/sys/devices/system/cpu/cpu0/tsc_freq_khz`

## Getting Started

```
git clone https://github.com/Aniruddha-Deb/syszuka.git && cd syszuka
git submodule update --init --recursive
```

This will pull in buildroot. To configure and build:

```
cd buildroot
make BR2_EXTERNAL=../syszuka defconfig DEFCONFIG=../syszuka/defconfig
make -j
```

The resulting kernel + rootfs will be located in `buildroot/output/images/bzImage`.
As configured, the rootfs is baked into the kernel so you don't require a separate
initrd when booting. This is viable because of how minimal the build is: the resulting
bzImage is <30 MB.

## Using the kernel

### Booting with QEMU

To test boot the kernel, use qemu:

```
qemu-system-x86_64 \
  -enable-kvm -cpu host \
  -kernel buildroot/output/images/bzImage \
  -append "console=ttyS0,115200" \
  -nographic \
  -no-reboot
```

You should see the kernel boot and present you with a login prompt:
```
Welcome to Syszuka
syszuka login:
```

login with user `root` and password `root`

### Booting on a real machine

Syszuka doesn't have an 'installer image', so you'll have to either pack a 
bootloader with it yourself (grub, u-boot etc), or boot it over PXE. The latter
is much easier if you just want to profile on a machine without having to 
re-image it.

A `boot.ipxe` config file has been provided with optimal kernel cmdline parameters for 
profiling. There are enough resources online on setting up/chainloading iPXE, 
so I won't be covering them here. You'll need a DHCP/TFTP/HTTP server setup, 
or a utility that does all of those in one (see [PyPXE][5], [netbootd][6] or 
[pixiecore][7])

This setup was tested on a Dell Optiplex 9020 (Core i7 4770k), and it worked
without any glitches. If the image doesn't work on your machine, report an 
issue and/or submit a patch :)

## TODOs

* [ ] More kernel tuning


[1]: https://github.com/trailofbits/tsc_freq_khz
[2]: https://gamozolabs.github.io/metrology/2019/08/19/sushi_roll.html
[3]: https://buildroot.org/
[4]: https://www.kernel.org/
[5]: https://github.com/pypxe/PyPXE/
[6]: https://github.com/DSpeichert/netbootd
[7]: https://github.com/danderson/netboot/tree/main/pixiecore
