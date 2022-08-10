[![Sticky Photo Wall](./resources/photos/StickyPhotoWall.png)](https://cthru.hopto.org/sticky-photo-wall)

[![CC BY-NC-SA 4.0][shield cc-by-nc-sa]][cc-by-nc-sa]
[![GitHub release (latest by date)][shield release]][latest release]
[![GitHub Release Date][shield release date]][latest release]
[![PayPal][shield paypal]][paypal]
[![Buy me a coffee][shield buymeacoffee]][buymeacoffee]


----------
## Introduction
----------
Sticky Photo Wall transforms your Linux desktop in an attractive photo wall with all your nicest pictures.

## Table of Contents
- [Introduction](#introduction)  
- [Features](#features)  
- [Installation](#installation)  
- [Upgrading](#upgrading)
- [Usage](#usage)  
    - [Examples](#usage-examples)
- [Release Notes](#release-notes)  
- [Copyright and License](#copyright-and-license)

## Features
- 2 orientations: landscape and portrait.
- 3 sizes: small, medium, large.
- 3 rotations: straight, skewed clockwise, skewed counterclockwise.

## Installation
### Requirements
To use StickyPhotoWall, you need:
- A Linux operating system.
- The latest release of [Conky](https://github.com/brndnmtthws/conky).

### Installation Procedure
#### Step 1 - Install Conky
Install [Conky](https://github.com/brndnmtthws/conky) using a package manager on your Linux OS or using the latest version from the [Conky website](https://github.com/brndnmtthws/conky).

#### Step 2 - Download and Extract StickyPhotoWall
- Go to the [Releases page][latest release] to download the source code of the latest StickyPhotoWall release.
- On the [Releases page][latest release], in the _Assets_ section, click on the _Source code (tar.gz)_ link to download 
  the sources.
- Save the tar.gz file with the sources on your system.
- Create a folder `.conky/sticky_photo_wall` in your home directory.
- Extract all contents of the tar.gz file to the `.conky/sticky_photo_wall` folder in the home directory of your system.

#### Step 3 - Prepare for first run
- Open the `~/.conky/sticky_photo_wall` directory.
- Open the file `sticky_photo_wall.conky` in that directory and replace the occurences of `_your_user_home_dir_name_` with your user home directory name.

```lua
	lua_load = '/home/_your_user_home_dir_name_/.conky/sticky_photo_wall/sticky_photo_wall.lua',
	lua_startup_hook = 'conky_config /home/_your_user_home_dir_name_/.conky/sticky_photo_wall/',
```

should be replaced with the code below (in this example the user home directory name is cthru)

```lua
	lua_load = '/home/cthru/.conky/sticky_photo_wall/sticky_photo_wall.lua',
	lua_startup_hook = 'conky_config /home/cthru/.conky/sticky_photo_wall/',
```

#### Step 4 - First run
- Open a Terminal window.
- Change the current directory.

> cd ~/.conky/sticky_photo_wall

- Start StickyPhotoWall using the command below. Replace _your_user_home_dir_name_ with your user home directory name.

> conky -c /home/_your_user_home_dir_name_/.conky/sticky_photo_wall/sticky_photo_wall.conky

#### Step 5 (optional) - Autostart
- Open the `autostart_sticky_photo_wall.sh` with a text editor and change the second line to your home directory.
	```sh
	#!/bin/sh
	MY_HOME=/home/_your_user_home_dir_name_
	```
	Example: for a user that is called cthru, change the second line as follows:
	```sh
	#!/bin/sh
	MY_HOME=/home/cthru
	```
- Add the `autostart_sticky_photo_wall.sh` script to the Startup Applications of your linux OS. You can do this via the user interface.  
Alternatively, you can create a `sticky_photo_wall.desktop` file in the `~/.config/autostart` folder.  
You can use the example `sticky_photo_wall.desktop` file provided, but you need to edit the file as follows.  
	- Replace the text `_your_user_home_dir_name_` from the line below with your user home directory name.
		```
		Exec=/home/_your_user_home_dir_name_/.conky/sticky_photo_wall/autostart_sticky_photo_wall.sh
		```
	- Copy the file.
		> cd ~/.conky/sticky_photo_wall  
		> cp sticky_photo_wall.desktop ~/.config/autostart/sticky_photo_wall.desktop

## Upgrading
- Take a backup of your configuration files
	> cd  ~/.conky/sticky_photo_wall  
	> mkdir backup  
	> cp sticky_photo_wall.conky backup/  
	> cp my_photo_wall.lua backup/

- Download and extract the upgrade as explained in the [Installation section](#step-2---download-and-extract-stickyphotowall) above.

- Check the [release notes](./CHANGELOG.md) for any syntax changes to the configuration files to be able to apply them as necessary to your configuration.

- Copy or manually edit (as necessary) (the contents of) your configuration files in the `~/.conky/sticky_photo_wall` directory.  
  
  To copy your backed up configuration files, you can use the following commands in a terninal window:
	> cd  ~/.conky/sticky_photo_wall  
	> cp backup/sticky_photo_wall.conky .  
	> cp backup/my_photo_wall.lua .

## Usage
To customize your personal photo wall, you will need to perform the following steps.

### Prepare your photos
All pictures you wish to use must be in the PNG (Portable Network Graphics) format.

Create a .png file of your photos in the folder `~/.conky/sticky_photo_wall/resources/photos`.

### Place your photos on the desktop
#### Set the relative position on screen
To change the relative position of your photo wall on screen, follow the steps below.

- Open the `sticky_photo_wall.conky` file and look for the section with conky's parameters below
```lua
	-- alignment: [top /  middle / bottom]-[ left / middle / right]
	alignment = 'middle_middle',
	-- change minimum_width and minimum_height parameters to your screen resolution for full screen display
	minimum_width = 640,
	minimum_height = 480,
	gap_x = 0,
	gap_y = 0,
```

E.g. if you have a Full HD display with resolution 1920x1080, and you want a sticky photo wall over your whole screen with a margin of 10 pixels on each side, you would have a configuration that looks like this

```lua
	-- alignment: [top /  middle / bottom]-[ left / middle / right]
	alignment = 'top_left',
	-- change minimum_width and minimum_height parameters to your screen resolution for full screen display
	minimum_width = 1900,
	minimum_height = 1060,
	gap_x = 10,
	gap_y = 10,
```

#### Put your photos on screen
To create your own photo wall file, follow the steps below.

- Create a `my_photo_wall.lua` file in the folder `~/.conky/sticky_photo_wall`.   
For first time users, you can copy the demo code from the file `~/.conky/sticky_photo_wall`
>cd ~/.conky/sticky_photo_wall  
>cp demo_photo_wall.lua my_photo_wall.lua 

- Change the name of the function `draw_demo_photo_wall` to `draw_my_photo_wall`.

- Follow the instructions in the file.

## Release Notes
For a full changelog of all versions, please look in [`CHANGELOG.md`](./CHANGELOG.md).

## Copyright and License
[![cc-by-nc-sa][shield cc-by-nc-sa]][cc-by-nc-sa]  

Copyright (c) 2022 Christoph Vanthuyne

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

Read the full license information [`here`](./LICENSE.md).

If you're more into a TL;DR approach, start [`here`][tldrlegal cc-by-nc-sa].

[shield cc-by-nc-sa]: https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png
[tldrlegal cc-by-nc-sa]: https://tldrlegal.com/license/creative-commons-attribution-noncommercial-sharealike-4.0-international-(cc-by-nc-sa-4.0)
[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[shield release]: https://img.shields.io/github/v/release/CTHRU/StickyPhotoWall?color=orange
[shield release date]: https://img.shields.io/github/release-date/CTHRU/StickyPhotoWall?color=orange
[latest release]: https://github.com/CTHRU/StickyPhotoWall/releases/latest
[shield buymeacoffee]: https://img.shields.io/static/v1?label=Buy%20me%20a%20coffee&message=Thank%20You&logo=buymeacoffee
[buymeacoffee]: https://www.buymeacoffee.com/CTHRU
[shield paypal]: https://img.shields.io/static/v1?label=Donate&message=Thank%20You&logo=PayPal
[paypal]: https://www.paypal.com/donate/?hosted_button_id=SSSHR299GZEKQ
