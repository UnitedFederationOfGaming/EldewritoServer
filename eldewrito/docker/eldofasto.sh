#!/usr/bin/env bash
#===============================================================================================================================================
# (C) Copyright 2019 under the United Federation of Gaming (https://ufg.gg).
#
# Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#===============================================================================================================================================
# title            :eldofasto
# description      :Setup/Installer for Eldewrito
# author           :A Project Under The United Federation of Gaming.
# contributors     :Beard, Kirk,
# date             :04-28-2019
# version          :0.0.8 Alpha
# os               :Debian/Ubuntu (Debian 8 - 9 | Ubuntu 14.04 - 18.04)
# usage            :bash eldofasto.sh
# notes            :If you have any problems feel free to email us: help [AT] UFG [DOT] gg
#===============================================================================================================================================

# Setting up an update/upgrade global function
    function upkeep() {
      apt-get update -y
      apt-get dist-upgrade -y
      apt-get clean -y
    }

    # START
        
  # Checking for multiple "required" pieces of software.
    tools=( lsb_release wget curl dialog bsdtar software-properties-common gnupg2 dirmngr apt-transport-https ca-certificates )
     grab_eware=""
       for e in "${tools[@]}"; do
         if command -v "$e" >/dev/null 2>&1; then
           echo "Dependency $e is installed.."
         else
           echo "Dependency $e is not installed..?"
            upkeep
            grab_eware="$grab_eware $e"
         fi
       done
      apt-get install $grab_eware

    # Grabbing info on active machine.
      flavor=`lsb_release -cs`
      system=`lsb_release -i | grep "Distributor ID:" | sed 's/Distributor ID://g' | sed 's/["]//g' | awk '{print tolower($1)}'`

      # Fetch for Docker and Setup/Install Eldewrito.
          read -r -p "Do you want to fetch Docker and install Eldewrito? (Y/N) " REPLY
            case "${REPLY,,}" in
              [yY]|[yY][eE][sS])
                    echo "Performing setup, and install of Eldewrito, and its utilities.."
                      curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
                       add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$system $flavor stable"
                    echo "Performing upkeep.."
                      upkeep
                    echo "Fetching Docker.."
                      apt-cache policy docker-ce
                    echo "Performing install of Docker.."
                      apt install docker-ce
                    echo "Grabbing Docker Compose, and setting up Folder Paths.."
                      apt install docker-compose
                      mkdir -p /home/eldofasto/games
                      mkdir -p /home/eldofasto/logs/
                      mkdir -p /home/eldofasto/config/
                      wget -qO- https://yourdomainhere.com/games.zip | bsdtar -xvf- -C /home/eldofasto/games
                    echo "Starting Eldewrito Docker Hold ON.."
                      cd /home/eldofasto/games
                      wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/docker-compose.yml
                      wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/defaults/dewrito_prefs.cfg
                      docker-compose up -d
                    ;;
                [nN]|[nN][oO])
                  echo "You have said no? We cannot work without your permission!"
                  ;;
                *)
                  echo "Invalid response. You okay?"
                  ;;
            esac

      # Fetch for Custom Gamemodes for Setup/Install for Eldewrito.
            read -r -p "Would you like to setup Custom Gamemodes, and Maps? (Y/N): "  REPLY
              case "${REPLY,,}" in
                [yY]|[yY][eE][sS])
                  HEIGHT=20
                  WIDTH=120
                  CHOICE_HEIGHT=7
                  BACKTITLE="EldewritoServer Custom Gamemode Setup"
                  TITLE="ELDOFASTO"
                  MENU="Choose one of the following options:"

                  OPTIONS=(1 "Sharp Shooters"
                           2 "Action Sack"
                           3 "Viva La Fiesta"
                           4 "Vanilla Custom"
                           5 "Bitesized Maps"
                           6 "Halo 1 Remakes"
                           7 "Halo 2 Remakes")

                  CHOICE=$(dialog --clear \
                                  --backtitle "$BACKTITLE" \
                                  --title "$TITLE" \
                                  --menu "$MENU" \
                                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                  "${OPTIONS[@]}" \
                                  2>&1 >/dev/tty)

                  clear

  # Attached Arg for dialogs $CHOICE output
              case $CHOICE in
                1)
                echo "Setting up Gamemode: Sharp Shooters"
                mkdir -p /home/eldofasto/games/mods/variants
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.TEAM -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                2)
                echo "Setting up Gamemode: Action Sack"
                mkdir -p /home/eldofasto/games/mods/variants
                wget -qO- https://dl.unitedfederationofgaming.com/eldofasto/variants/action-sack.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.ACTION -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                3)
                echo "Setting up Gamemode: Viva La Fiesta"
                mkdir -p /home/eldofasto/games/mods/variants
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.FIESTA -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                4)
                echo "Setting up Gamemode: Vanilla Custom"
                mkdir -p /home/eldofasto/games/mods/variants
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.VANILLA -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                5)
                echo "Setting up Gamemode: Bitsized Maps"
                mkdir -p /home/eldofasto/games/mods/variants
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.BITESIZED -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                6)
                echo "Setting up Gamemode: Halo 1 Remakes"
                mkdir -p /home/eldofasto/games/mods/variants
                mkdir -p /home/eldofasto/games/mods/maps
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget -qO- https://dl.unitedfederationofgaming.com/eldofasto/maps/halo1/halo1.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/maps
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.HALO1 -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
                7)
                echo "Setting up Gamemode: Halo 2 Remakes"
                mkdir -p /home/eldofasto/games/mods/variants
                mkdir -p /home/eldofasto/games/mods/maps
                wget -qO- https://eldewritoserver.com/gametypes/all.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/variants
                wget -qO- https://dl.unitedfederationofgaming.com/eldofasto/maps/halo2/halo2.zip | bsdtar -xvf- -C /home/eldofasto/games/mods/maps
                wget https://raw.githubusercontent.com/UnitedFederationOfGaming/EldewritoServer/master/eldewrito/docker/games/server/voting.json.HALO1 -O /home/eldofasto/games/mods/server/voting.json
                echo "Grabbing Docker Status"
                  service docker status
                  docker stats
                  ;;
              esac
          clear
          ;;
        [nN]|[nN][oO])
          echo "You have said no? We cannot work without your permission!"
          ;;
        *)
          echo "Invalid response. You okay?"
          ;;
      esac
