#
# Copyright (c) 2017 Johnson and Johnson, All Rights Reserved.

red='/bin/tput setaf 1'
green='/bin/tput setaf 2'
yellow='/bin/tput setaf 3'
reset='/bin/tput sgr0'

function start_menu {
  if [ "$EUID" -ne 0 ]; then
    ${red}; echo "Please run as root"; ${reset}
    exit
  fi
  ${yellow}; echo "J&J Chef Workstation Configuration"; ${reset}
message="
This script will install the necessary software required to enable development of Chef cookbooks.
The following software packages will be installed
- Python36
- ChefDK
- git
- jq
- AWS CLI (optional if EC2 kitchen driver selected)

Additionally, script will:
- configure the J&J Cookbook Generate script
- enable Chef Kitchen driver

Do you want to continue? (y/n) "
  while true; do
    read -p "$message" yn
    echo ""
    case $yn in
         [Yy]* ) echo "Starting J&J Chef Workstation Setup"
                 echo ""
                 sleep .5
                 break;;
         [Nn]* ) echo "J&J Chef Workstation Configuration setup stopped"
                 exit;;
             * ) echo "Please answer yes or no.";;
    esac
  done
}

function install_python {
  py_version='3.6.3'
  #ver_chk=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
  if [ ! -f /usr/local/bin/python3.6  ]; then
    ${yellow}; echo "Installing yum packages"; ${reset}
    yum install -y gcc zlib-devel openssl-devel  > /dev/null 2>&1
    ${green}; echo "yum installation successful"; ${reset}
    cd /usr/src/

    ${yellow}; echo "Downloading Python$py_version"; ${reset}
    curl -s -O "https://s3.amazonaws.com/jnj-dvl-vpcx-scm/packages/python/Python-$py_version.tgz"
    if [ -f /usr/src/Python-$py_version.tgz ]; then
      ${green}; echo "Python$py_version downloaded...Extracting.."; ${reset}
    else
      ${red}; echo "Error downloading Python"; ${reset}
      exit
    fi
    tar -xvzf "Python-$py_version.tgz" > /dev/null 2>&1
    rm -f "Python-$py_version.tgz" 
    cd "/usr/src/Python-$py_version"

    ${yellow}; echo "Installing Python$py_version...Takes 3+ minutes...Please wait.."; ${reset}
    ./configure > /dev/null 2>&1
    make altinstall > /dev/null 2>&1
  else
    ${green}; echo "Python$ver_chk already installed. Skipping..."; ${reset}
  fi
}

function install_pip {
  if [ -f /usr/local/bin/pip3.6 ]; then
    ${green}; echo "Pip already installed. Skipping..."; ${reset}
    sleep .5
  else
    ${yellow}; echo "Installing pip..."; ${reset}
    wget -P /var/tmp/ https://bootstrap.pypa.io/get-pip.py > /dev/null 2>&1
    /usr/local/bin/python3.6 /var/tmp/get-pip.py --upgrade > /dev/null 2<&1
    if [ -f /usr/local/bin/pip3.6 ]; then
      ${green}; echo "Pip Installation Successful"; ${reset}
    else
      ${red}; echo "Error Installing Pip"; ${reset}
      exit
    fi
  fi
}

function install_pip_packages {

  /opt/JNJ_Workstation_Venv/bin/pip3.6 install --upgrade pip > /dev/null 2<&1
  /opt/JNJ_Workstation_Venv/bin/pip3.6 install -U setuptools > /dev/null 2<&1
  declare -a pip_packages=("requests" "stashy" "jsonmerge" "colorama")
  for i in "${pip_packages[@]}"
  do
    if /opt/JNJ_Workstation_Venv/bin/pip3.6 list --format=columns | grep -c $i > /dev/null 2<&1 ; then
      ${green}; echo "$i already installed. Skipping..."; ${reset}
      sleep .5
    else
      ${yellow}; echo "Installing $i..."; ${reset}
      umask 022
      /opt/JNJ_Workstation_Venv/bin/pip3.6 install $i > /dev/null 2<&1
      if /opt/JNJ_Workstation_Venv/bin/pip3.6 list --format=columns | grep -c $i > /dev/null 2<&1 ; then
        ${green}; echo "$i Installation Successful"; ${reset}
      else
        ${red}; echo "Error Installing $i"; ${reset}
        exit
      fi
    fi
  done
}

function virtual_env {
  # Setup virtual ENV for workstation setup
  if [ ! -d "/opt/JNJ_Workstation_Venv" ]; then
    /usr/local/bin/python3.6 -m venv "/opt/JNJ_Workstation_Venv" >/dev/null 2<&1
    /usr/bin/chmod -R 755 /opt/JNJ_Workstation_Venv
  fi
  if [ -f /home/$RUSER/SourceCode/workstation_scripts/workstation.py ]; then
    workstation_py="/home/$RUSER/SourceCode/workstation_scripts/workstation.py"
  else
    # Download workstation setup script
    cd /tmp
    # Production bucket
    if [ -z "$1" ]; then
      curl -s -O "https://s3.amazonaws.com/jnj-vpcx-scm/packages/chef/workstation.py"
    # Development bucket
    else
      curl -s -O "https://s3.amazonaws.com/jnj-dvl-vpcx-scm/packages/chef/workstation.py"
    fi
    workstation_py="/tmp/workstation.py"
  fi
  (. /opt/JNJ_Workstation_Venv/bin/activate)
  install_pip_packages
  # Invoke Python script
  if [ -z "$1" ]; then
    /opt/JNJ_Workstation_Venv/bin/python3.6 $workstation_py
  else
    /opt/JNJ_Workstation_Venv/bin/python3.6 $workstation_py --branch=$1
  fi
}

start_menu
install_python
install_pip
virtual_env $1