# GTNH-HTTP-Robot-Controller

## Content

- [Information](#information)
- [Installation](#installation)
- [Robot Examples](#robot-examples)
- [Credits](#credits)


<a id="information"></a>

## Information

Program is designed to control opencomputer robots using http requests.
And there is also the possibility of auto update at startup.


<a id="installation"></a>

## Installation

> [!CAUTION]
> If you are using 8 java, the installer will not work for you.
> The only way to install the program is to manually transfer it to your computer.
> The problem is on the java side.

To install program, you need a t3 computer with:
- Graphics Card (Tier 1+)
- Central Processing Unit (CPU) (Tier 1+)
- Memory (Tier 3.5)
- Hard Disk Drive (Tier 3) (4MB)
- EEPROM (Lua BIOS)
- Internet Card

![Computer Example](/docs/installation_computer.png)

### Downloading softwere using installer:

- Install the basic Open OS on your computer.
- Then run the command to start the installer.
```shell
wget -f https://raw.githubusercontent.com/MarkinoTeck/GTNH-OC-Installer/main/installer.lua && installer
```
- Select the "Robot" program in the installer.
- Enable auto restart typing "y" when prompted.

After installation is completed, you can take move the 'EEPROM' and the 'Hard Disk Drive' to the new robot.

<b>To work the robot equires these upgrades</b> (one each):

- EPROMM and Hard Disk Drive <b>with loaded softwere</b>
- Internet Card
- Navigation Upgrade
- Inventory Upgrade
- Geolyzer
- Memory (Tier 3.5)
- Accelerated Processing Unit (APU) (Tier 2+)
- Hover Upgrade (Tier 2)
- Chunkloader Upgrade
- Angel Upgrade
- <b>Needed for block placement:</b><br>
    Inventory controller upgrade<br>
    ME Upgrade (Tier 3)<br>
    Database (Tier 1)

Optional Upgrades (one each):

- <b>To use a screen:</b><br>
    Screen + Keyboard + Graphics card


<a id="robot-examples"></a>

## Robot Examples:

Inside robot:

- 1x "Screen (Tier 1)"
- 1x Keyboard
- 1x "ME Upgrade" (tier 3)
- 1x "Database Upgrade (Tier 1)"
- 1x "Angel Upgrade"
- 1x "Hover Upgrade (Tier 2)"
- 1x "Chunkloader Upgrade"
- 1x "Memory (Tier 3.5)"
- 1x "Central Processing Unit (CPU) (Tier 3)"
- 1x "Internet Card"
- 1x "EEPROM (Lua BIOS)" <b>with loaded softwere</b>
- 1x "Hard Disk Drive (Tier 3) (4MB)" <b>with loaded softwere</b>
- 1x "Computer Case (Tier 3)"
- 1x "Navigation Upgrade"
- 1x "Inventory Controller Upgrade"
- 2x "Upgrade Container (Tier 1)"

In Upgrade Containers:

- 1x "Inventory Upgrade" (Upgrade Container)
- 1x Geolyzer (Upgrade Container)

![Computer Example](/docs/robot_preset.png)


<a id="credits"></a>

## Credits:
~~~
Install Script: based on Navatusein's code
~~~