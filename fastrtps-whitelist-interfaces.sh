# Alexander Entinger, LXRobotics GmbH (https://lxrobotics.com/)
# Based on Olivier Kermorgant's reply on answers.ros.org ( https://answers.ros.org/question/405753/limit-ros-traffic-to-specific-network-interface/ )
# Blog article with background information https://www.lxrobotics.com/restrict-ros2-dds-communication-to-specific-interfaces/

#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

if [ "$#" -lt 1 ]
then
  echo "Usage: ./fastrtps-whitelist-interfaces.sh wlan0 [eth0, ...]"
  exit 1
fi

# Fast-DDS https://fast-dds.docs.eprosima.com/en/latest/fastdds/transport/whitelist.html
# needs actual ip for this interface
ipinet_list=""
for interface in "$@"
do
    ipinet="$(ip a s $interface | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
    newline=$'\n'
    ipinet_list+="                <address>${ipinet##inet }</address>${newline}"
done

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<profiles xmlns=\"http://www.eprosima.com/XMLSchemas/fastRTPS_Profiles\">
    <transport_descriptors>
        <transport_descriptor>
            <transport_id>CustomUDPTransport</transport_id>
            <type>UDPv4</type>
            <interfaceWhiteList>
${ipinet_list}
            </interfaceWhiteList>
        </transport_descriptor>

        <transport_descriptor>
            <transport_id>CustomTCPTransport</transport_id>
            <type>TCPv4</type>
            <interfaceWhiteList>
${ipinet_list}
            </interfaceWhiteList>
        </transport_descriptor>

    </transport_descriptors>

    <participant profile_name=\"CustomTransportParticipant\" is_default_profile=\"true\">
        <rtps>
            <userTransports>
                <transport_id>CustomUDPTransport</transport_id>
                <transport_id>CustomTCPTransport</transport_id>
            </userTransports>
            <useBuiltinTransports>false</useBuiltinTransports>
        </rtps>
    </participant>

</profiles>" >> fastrtps-whitelist-interfaces.xml
