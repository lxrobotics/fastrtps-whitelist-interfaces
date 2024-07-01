#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Fast-DDS https://fast-dds.docs.eprosima.com/en/latest/fastdds/transport/whitelist.html
# needs actual ip for this interface
interface=wlan0
ipinet="$(ip a s $interface | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<profiles xmlns=\"http://www.eprosima.com/XMLSchemas/fastRTPS_Profiles\">
    <transport_descriptors>
        <transport_descriptor>
            <transport_id>CustomUDPTransport</transport_id>
            <type>UDPv4</type>
            <interfaceWhiteList>
                <address>${ipinet##inet }</address>
            </interfaceWhiteList>
        </transport_descriptor>

        <transport_descriptor>
            <transport_id>CustomTCPTransport</transport_id>
            <type>TCPv4</type>
            <interfaceWhiteList>
                <address>${ipinet##inet }</address>
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

</profiles>" > fastrtps-whitelist-wlan.xml
