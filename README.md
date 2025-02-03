<a href="https://lxrobotics.com/"><img align="right" src="https://raw.githubusercontent.com/lxrobotics/.github/main/logo/lxrobotics.png" width="15%"></a>
:floppy_disk: `fastrtps-whitelist-interfaces`
=============================================
[![Spell Check status](https://github.com/lxrobotics/fastrtps-whitelist-interfaces/actions/workflows/spell-check.yml/badge.svg)](https://github.com/lxrobotics/fastrtps-whitelist-interfacesactions/workflows/spell-check.yml)

This repository contains a script to whitelist specific interfaces to be used by [eProsima](https://www.eprosima.com/)'s [FastRTPS](https://fast-dds.docs.eprosima.com/en/v1.7.0/) [DDS](https://en.wikipedia.org/wiki/Data_Distribution_Service).

A blog article providing relevant background information can be found [here](https://lxrobotics.com/blog/restrict-ros2-dds-communication-to-specific-interfaces/).

### How-to-use
```bash
ros2 daemon stop
./fastrtps-whitelist-interfaces.sh wlan0 eth0 ...
export FASTRTPS_DEFAULT_PROFILES_FILE=$(pwd)/fastrtps-whitelist-interfaces.xml
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
```
