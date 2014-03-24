#! /bin/sh

# bootstrap — provision a new system with essential packages

# Unfortunately, this has to be bash since assuming nothing (zsh) on system.
#
# We're basing the OS/family on package mgr available.
# Could be run as one-liner straight from curl!

# Variables you can set for bypasses (make script non-interactive):
# - GH_USER:  github user
# - C4R_USER: regular student/user

#linos=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)
#SKIP_I3=False
WM=i3

# Try to make running as simple as possible (should not be required)
usage() { echo USAGE: bootstrap USERNAME GITHUB_USERNAME; }
err() { echo -e "ERROR: $@" 2>&1 ; exit 1; }

set_targets() {
  common=( zsh gawk rxvt-unicode tmux tree )
  xpkgs=(  # hopefully these are common across systems
    xclip arandr bdftopcf growl-for-linux gvolwheel
    gtmixer parcellite )
  yums=(    ${common[@]} git vim vim tree rubygem-coderay )
  apts=(    ${common[@]} git vim vim tree rubygem-coderay )
  pacmans=( ${common[@]} git vim vim tree rubygem-coderay )
  zyppers=( ${common[@]} git vim vim tree rubygem-coderay )
  pkgngs=(  ${common[@]} git vim vim tree rubygem-coderay )
  brews=(   ${common[@]} git vim vim tree rubygem-coderay )
}

# Check for sudo privileges or existence of required packages.
check_privs() {
  has_sudo=True
  if ! sudo ls >/dev/null; then
    echo -e "Looks like you don't have super powers."
    echo -e "Set up sudo if you wish to remedy this."
    has_sudo=False
  fi
}

find_pkg_mgr() {
  echo -e "Determining your package manager"
  for pm_maybe in yum apt-get pacman zypper pkg brew; do
    if which $pm_maybe 2>/dev/null; then
      pm=$pm
      echo "  package manager: $pm"
      break
    fi
  done
  if [[ -z $pm ]]; then
    err "could not determine package manager"
    exit 1
  fi
}

grok_system() {
  case $pm in
    yum)      pmi="$pm install -y";     osfam=redhat; pkgs="${yums[@]}"    ;;
    apt-get)  pmi="$pm install -y";     osfam=debian; pkgs="${apts[@]}"    ;;
    pacman)   pmi="$pm -S --noconfirm"; osfam=arch;   pkgs="${pacmans[@]}" ;;
    zypper)   pmi="$pm install -n";     osfam=suse;   pkgs="${zyppers[@]}" ;;
    pkg)      pmi="$pm install";        osfam=bsd;    pkgs="${pkgngs[@]}"  ;;
    brew)     pmi="$pm install";        osfam=mac;    pkgs="${brews[@]}"   ;;
  esac
}

set_up_os_specials() {  # aka homebrew
  if [[ osfam == mac ]]; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    # FIXME: more to do here, I'm sure
  elif [[ osfam == bsd ]]; then
    #echo "ENABLE: X11 setup by adding this line to ~/.pcdmsessionstart"
    echo -e "\n./.xinitrc" >> ~/.xprofile
    # Set up pkgng?
  elif [[ osfam == redhat ]]; then
    # Enable EPEL, but consider that fedora probably doesn't need this
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sudo rpm -Uvh epel-release-*.rpm
  fi
}

check_for_installed_pkgs() {
  missings=()
  for p in $pkgs; do
    which $p >/dev/null 2>&1 || missings+=$p
  done
  if [[ ${#missings} != 0 ]]; then
    echo -e "Missing the following essential packages:"
    for m in $missings; do echo "  $m"; done
    echo -e "\nI'll try installing them for you shortly.\n"
  fi
}

install_prelims() {
  if ! $pmi zsh wget; then
    err "unable to install preliminary packages (zsh, wget) so cannot proceed."
  fi
}

prompt_for_info() {
  [[ -z $C4R_USER ]] &&
    read -p 'New local system username (leave blank to skip creation): ' user
  newuser='EXISTING'
  if [[ -z $user ]]; then
    user=$USER
    newuser='NEW'
    #read -p 'New passwd: ' user
    #echo $passwd |passwd $user
    passwd $user
  fi
  echo -e "Setting up for $newuser user: $user\n"
  [[ -z $GH_USER ]] &&
    read -p 'GitHub username: ' ghuser
  if wget -s https://github.com/$ghuser/dotfiles; then
    echo "Cool, looks like you've already forked your dotfiles repo."
  else
    #echo "Oops. You need to fork this dotfiles repo on github.com:"
    #echo "  https://github.com/code4real/dotfiles"
    #echo "(and then re-run this)"
    #echo -e "\nInstructions: https://github.com/help/forking"
    err "Oops. You need to fork this dotfiles repo on github.com:\n" \
        "  https://github.com/code4real/dotfiles\n" \
        "(and then re-run this)\n" \
        "\nInstructions: https://github.com/help/forking\n"  # FIXME
  fi
}

create_user() {
  wzsh=$(whereis zsh |cut -f2 -d' ')
  case $pm in
    pacman|yum|apt-get|zypper)
      useradd    -m -s $wzsh $user ;;
    pkg)
      pw useradd -m -s $wzsh $user ;;
    brew)
      wget https://raw.github.com/code4real/dotfiles/master/contrib/bin/useradd-mac.sh
      bash ./useradd-mac.sh 
      ;;
  esac
}

install_sys_pkgs() {
  echo -e "About to install the following essential system packages:"
  for p in $pkgs; do echo $p; done
  $pmi ${pkgs[@]}
  read -p 'Do you want to install the recommended X11 packages? [Y/n]: ' -n1 x11s
  $pmi ${xpkgs[@]}
}

#---------------------------------------------------------------------
# Luser

install_zsh_syntax() {
  zhi=git://github.com/zsh-users/zsh-syntax-highlighting.git
  zhi_local=~/local/src/zsh-syntax-highlighting
  mkdir -p ~/local/src
  echo -e "\nInstalling zsh syntax highlighting to $zhi_local\n"
  git clone $zhi $zhi_local
  echo -e "\nHighlighting will be auto-enabled/configured by your dotfiles.\n"
}

install_dotfiles() {
  # http://silas.sewell.org/blog/2009/03/08/profile-management-with-git-and-github/
  echo -e "\nInstalling dotfiles\n"
  cd ~
  # Check for existence of ~/dotfiles before proceeding
  if [[ -d .git ]]; then
    print "Whoa, you already have a git repo here."
    exit 1
  fi
  if [[ ! -d dotfiles ]]; then
    echo -e "\nCloning your git repo"
    git clone git@github.com:$ghuser/dotfiles.git
    existing=()
    for resource in dotfiles/.* dotfiles/* ; do
      [[ -e $resource ]] && existing+=$resource
      if (( $resource > 0 )); then
        echo "You seem to already have resources in your home. rm or mv these:"
        echo ${resources[@]}
        exit 1
      fi
    done
    mv dotfiles/.* dotfiles/* .
    mv .git .dotfiles.git/
  fi
}

install_vim_bundles() {
  echo "\nInstalling vim bundles\n"
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  vim +BundleInstall +qall
}

install_orp() {
  echo "\nInstalling fancy small bitmap font\n"
  git clone https://github.com/MicahElliott/Orp-Font ~/local/src/Orp-Font
  cd ~/local/src/Orp-Font
  for font in lib/*.bdf; do ./xfont-install.zsh $font; done
}

install_nvm() {
  echo -e "\nInstalling Node Version Manager (NVM) to ~/.nvm\n"
  git clone https://github.com/creationix/nvm.git ~/.nvm
  echo -e "Installing your first Node\n"
  en-nvm
  node install 0.10
  npm install -g LiveScript
  echo -e "You can now fire up an interactive LiveScript REPL:"
  echo -e "  % ils\n"
}

set_targets
check_privs
find_pkg_mgr
grok_system
set_up_os_specials
check_for_installed_pkgs
install_prelims
prompt_for_info
create_user
install_sys_pkgs
install_reqs

# Lusers
install_zsh_syntax
install_dotfiles
install_vim_bundles
install_orp
install_nvm

echo
echo 'DONE!'
echo -e "\nTry out the git proxy now in your path:"
echo "  % dotfiles status  # or just: dst"
