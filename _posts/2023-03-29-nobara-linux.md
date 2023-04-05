---
layout: post
title: Nobara Linux Installation
date: 2023-03-29 18:11 +0000
categories: [Linux, Hardware]
---

[This Article is in Progess]
=======
------------------------------------------------------------------


![Nobara Linux](https://nobaraproject.org/wp-content/uploads/2022/10/cropped-nobara_penguin_logotype.png)

Why Nobara
----
I've been a Windows user for all my life and it's no different in my personal gaming rig. That said, It's still going to be my primary gaming OS only due to the fact that some of the games I play ; Valorant , and soon to be released Honkai StarRail aren't gonna be on Linux. But then I came across Nobara Linux , touted as the ultimate linux gaming distro with out of the box support for Nvidia , Lutris , Wine , Steam and so on. This looked promising I thought to myself, so I decided to give it a try.

I'm a novice when it comes to Linux, so bear with me here as I document my installation proccess. You'll definitely see my ignorance when it comes to Linux. But I still wanna give it a try. Apart from gaming I just want to use Linux day-to-day just to get better at it.

------------------------------------------------------------------

My Rig
-------

So my rig is decently powerful it's running the following hardware
:   * CPU:  AMD Ryzen 5 5600X
    * Motherboard:  MSI MAG B550 Tomahawk
    * RAM:  24GB DDR4 3200MHZ
    * Storage: 
        * NVME: WD Blue SN570 1TB
        * SSD0: SanDisk 500GB
        * SSD1: Kingston 500GB
    * GPU: Colorful IGAME RTX3070 
    * PSU: Superflower 550W Silver

------------------------------------------------------------------

Preparing the Installation Media
----

Preparing the installation media is as simple as going to [Nobara](https://nobaraproject.org/download-nobara/) and downloading the ISO image, and flashing it to a USB drive using [Balena Etcher](https://www.balena.io/etcher). I've read that balena doesnt work for some people, you might want to flash the drive with ```dd``` , theres plenty of guides for that. 

I made the descision to choose the GNOME iso. In my opinion KDE is pretty much a Windows UI experience, and I didnt want that. I wanted to try something different so I opted for GNOME.

----

Installation
---

So after I've prepared my installation media, I plugged it into the front usb port on my case and popped into the BIOS to boot override and directly boot into the installation media.
I was then greeted by Grub asking me to choose one of 3 options there as you can see in the image below

![Nobara Live USB Grub Menu](https://nobaraproject.org/wp-content/uploads/2023/03/Screenshot-from-2023-03-04-15-30-48-1024x643.png)

Here's where all the fun stuff starts to happen. I chose Start Nobara Linux 37 and it shows me the loading circle , after a bit it just gives me a blank screen. At this point i gave it a few restarts and thought it might be the USB port acting silly, so I plugged the USB drive at the back of my motherboard. But the results were the same, black screen.

Tried a few solutions i found on reddit :-

* Unplugging my DisplayPort monitor , only running HDMI monitor
* Booting into multi user mode shell and updating dnf packages
* Reflashing the USB drive

All of these did nothing. And at this point I have no idea why I didn't try the troubleshooting option on the grub menu, which would boot into the liveusb in basic graphics mode. So, I gave that a shot and **voila!** we have a gui!

I then proceeded with the installation steps, all of these were straightforward, nothing to note. Took about 10 minutes to install on my NVME drive. I rebooted my machine, unplugged the USB drive. After rebooting , I popped into my BIOS changed the boot order to my NVMe and made Windows boot option #2. Save and exit, all is well.

I rebooted and was greeted by the grub menu which detected Nobara and Windows . I went on and chose Nobara. Lo and behold, black screen like the usb drive. *Fuck* .

I was ready to give up, but then i remembered that I have an Nvidia card and that Linux doesnt particularly play well with Nvidia at times. So off to Reddit!

Found some posts about people having the same issue ; some replies would suggest booting into multi-user rescue mode from grub and running the following

```bash 
sudo dnf remove *nvidia*
sudo dnf update nobara-login
reboot
```
But when ran ```sudo dnf remove *nvidia* ``` it gave me an error along the lines of 

> ERROR: This command involves removing a protected package : nobara-login

This meant I couldnt uninstall any nvidia related packages so I was pretty much blank myself, didn't know what to do. I ran ```lspci``` and my RTX3070 did show up, so then i thought, *oh it's the driver not installed* .

Noob lightbulb moment. Sure enough a quick ``` modinfo -F version nvidia ``` didnt output any installed nvidia drivers. Since nobara didn't automatically pull the drivers , i then attempted to install the drivers manually. One of the replies on a [thread](https://www.reddit.com/r/NobaraProject/comments/wu8s4e/comment/ildyzcw/) by GloriousEggroll (Nobara's Developer) was my saviour. 

I ran the commands that GE posted on the reply :- 

```bash
sudo dnf remove *nvidia*
sudo dnf install install -y nvidia-driver nvidia-driver-libs.i686 nvidia-settings nvidia-driver-cuda cuda-devel
sudo sed -i 's/initcall_blacklist=simpledrm_platform_driver_init //g' /etc/default/grub
sudo sed -i 's/rhgb quiet/rhgb quiet nvidia-drm.modeset=1/g' /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

After about 20 minutes it finished installing, i ran ``` modinfo -F version nvidia ``` again and i got a driver version installed! Thank god. Then i just rebooted the system , crossed my fingers and prayed to god. BAM we got a gui. 

<p  align="center" ><img src="/assets/img/posts/nobara-linux/nobara-installed-neofetch.jpg" width="50%"></p>

Then it was pretty much smooth sailing, updated the system, installed discord and all is well.

It remains to be seen if I'll run into anymore bugs like this but I hope it's all a smooth ride from here on out. I have high hopes for this distro, once Gnome 44 is out i'll customize the shell to my liking and start doing work on it.

All my other peripheral devices were detected straight away, wacom tablet , g pro superlight , custom keyboard , soundcard , etc. Aside from the gpu, everything was smooth as butter afterwards. 

