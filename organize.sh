#!/usr/bin/env bash
# Reorganize Huawei labs into a clean, categorized structure.
# Usage (run from inside the "huawei labs" folder):
#   bash organize.sh          # dry run: only shows what would happen
#   bash organize.sh --run    # actually moves the folders

RUN=0
[ "$1" = "--run" ] && RUN=1

if [ ! -d .git ]; then
  echo "Run this from the root of your git repo (the folder containing .git)."
  exit 1
fi

move() {
  local src="$1" dest="$2"
  if [ ! -d "$src" ]; then
    echo "SKIP (not found): $src"
    return
  fi
  if [ -e "$dest" ]; then
    echo "SKIP (destination exists): $dest"
    return
  fi
  if [ $RUN -eq 0 ]; then
    echo "WOULD MOVE: $src  ->  $dest"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -n "$(git ls-files -- "$src" | head -1)" ]; then
    git mv "$src" "$dest" && echo "git mv: $src -> $dest"
  else
    mv "$src" "$dest" && echo "mv:     $src -> $dest"
  fi
}

# 01 - Datacom basics
move "DATACOM LAB 01"                       "01-datacom-basics/datacom-lab-01"

# 02 - Switching
move "STP LAB 01"                           "02-switching/stp-lab-01"
move "VLANIF LAB"                           "02-switching/vlanif-lab"
move "INTER_VLAN LAB 01"                    "02-switching/inter-vlan-lab-01"
move "ETH-TRUNK LAB 01"                     "02-switching/eth-trunk-lab-01"
move "SWITCHED NETWORK"                     "02-switching/switched-network"
move "DAD LAB"                              "02-switching/dad-lab"

# 03 - Routing
move "Static routing"                       "03-routing/static-routing"
move "OSPF LAB 01"                          "03-routing/ospf/ospf-lab-01"
move "OSPF LAB 3 authentication"            "03-routing/ospf/ospf-lab-03-authentication"
move "OSPF_VLAN_CONF"                       "03-routing/ospf/ospf-vlan-conf"
move "SINGLE AREA OSPF"                     "03-routing/ospf/single-area-ospf"
move "SINGLE AREA OSPF LAB 2"               "03-routing/ospf/single-area-ospf-lab-02"
move "HCIP_OSPF LAB 01"                     "03-routing/ospf/hcip-ospf-lab-01"
move "HCIP_OSPF LAB 2 MULT_AREA"            "03-routing/ospf/hcip-ospf-lab-02-multiarea"
move "HCIP_OSPF ADJANCIES AND LSA"          "03-routing/ospf/hcip-ospf-adjacencies-and-lsa"
move "STUB  AND NSSA"                       "03-routing/ospf/stub-and-nssa"
move "STUBY AND NSSA AREAS"                 "03-routing/ospf/stub-and-nssa-areas"
move "IS-IS MULT AREA CONFIG"               "03-routing/isis/isis-multi-area"
move "ADVANCED IS-IS CONFI LAB 2"           "03-routing/isis/advanced-isis-lab-02"

# 04 - IP services
move "DHCP GLOBAL"                          "04-ip-services/dhcp-global"
move "DHCP INTERFACE"                       "04-ip-services/dhcp-interface"
move "DHCP RELAY"                           "04-ip-services/dhcp-relay"
move "DHCPV6"                               "04-ip-services/dhcpv6"
move "ipv6 configuration"                   "04-ip-services/ipv6-configuration"
move "STATIC NAT LAB 01"                    "04-ip-services/static-nat-lab-01"
move "FTP LAB"                              "04-ip-services/ftp-lab"
move "TELNET LAB"                           "04-ip-services/telnet-lab"

# 05 - Security
move "ACL LAB 01"                           "05-security/acl-lab-01"
move "FIREWALL BASIC CONFIG"                "05-security/firewall-basic-config"
move "FIREWALL CONFIG"                      "05-security/firewall-config"
move "FIREWALL ACTIVE STANDBY"              "05-security/firewall-active-standby"
move "HOT HRP ACTIVE STANDY LAB01"          "05-security/hrp-active-standby-lab-01"
move "HRP STANDBY MIRRORING MODE"           "05-security/hrp-standby-mirroring-mode"

# 06 - WAN
move "PPP_PAP authentication"               "06-wan/ppp-pap"
move "PPP_CHAP authentication"              "06-wan/ppp-chap"
move "PPPoE LAB 01"                         "06-wan/pppoe-lab-01"
move "PPPOE LAB 02 (complex)"               "06-wan/pppoe-lab-02-complex"
move "AR HOTSTANBY CONFIGURATION"           "06-wan/ar-hot-standby"

# 07 - WLAN
move "WLAN LAB 01"                          "07-wlan/wlan-lab-01"
move "WLAN LAB O3"                          "07-wlan/wlan-lab-03"
move "LAYER 2 OFF-PATH WLAN"                "07-wlan/layer-2-off-path-wlan"
move "LAYER 3 OFF PATH NETWORKING"          "07-wlan/layer-3-off-path-networking"
move "LAYER 3 OFF-PATH NETWORK WLAN DESIGN" "07-wlan/layer-3-off-path-wlan-design"

# 08 - Campus network
move "CAMPUS NETWORK"                       "08-campus-network/campus-network"

echo
if [ $RUN -eq 0 ]; then
  echo "Dry run finished. If it looks right, run:  bash organize.sh --run"
else
  echo "Done. Review with:  git status"
  echo "Then:  git add . && git commit -m \"Reorganize labs by topic\" && git push origin main"
fi
