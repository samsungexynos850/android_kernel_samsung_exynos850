# Lineage Kernel For SM-A217F S8 Binary
**Based on A217FXXS8DWC2**

## About
My goal in this project is to make a stable kernel for the A217F S8 - and other variants - with numerous performance boosts and,
edits to the kernel config. I intend to eventually mainline this kernel, so look forward to that :D!
 
## Features

**Compiler**
* GCC v4.9 Toolchain, with clang


**General**
* SELinux enforcing
* Halium config options applied
* Underclocked and overclocked some CPU cores.

## Download
* [Lineage A12](https://github.com/Samsung-Galaxy-A21s/kernel_samsung_a21s/releases/latest)

## Installation
* Make sure to enabled OEM unlocking and USB debugging in settings
* Open Odin on your computer and boot the phone into download mode
* Add patched vbmeta.img for the S8 in Odin 'BL' and 'USERDATA' slot [VBMETA](https://drive.google.com/file/d/1OczSbdScy6kL9nxjoZg__7b_Gz949jQf/view?usp=sharing) 
* Add this to Odin slot 'AP' [TWRP](https://github.com/DozNaka/android_device_samsung_a21s/releases) and press start
* Boot into recovery mode from download mode by pressing, Volume Up + Power Button
* Go to, Wipe -> format data -> yes, then reboot back to recovery
* Go to Terminal and type: $ multidisabler  :then reboot to recovery
* Press adb sideload option
* Run the command $ adb sideload "A217F-Lineage.zip" using [SDK Tools](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)
* Then reboot to system and enjoy Lineage Kernel!!

## Credits

* Credit to [physwizz](https://github.com/physwizz) for the CPU overclocking and underclocking code.
* Credit to [Osmosis](https://github.com/osm0sis) for the Android Image Kitchen tools
