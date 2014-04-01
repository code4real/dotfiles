#! /bin/sh

# bootstrap — provision a new system with essential packages

# Pre-run instructions:
# - create a github account
# - fork https://github.com/code4real/dotfiles

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
err() { echo -e "\nERROR: $@" 2>&1 ; exit 1; }

get_bootstraps() {
  urlbase=https://raw.github.com/code4real/dotfiles/master/contrib/bootstrap/
  uamac=$urlbase/useradd-mac.sh
  pkgmatrix=$urlbase/pkgmatrix.tsv
  bsinstall=$urlbase/bootstrap-installpkgs.zsh
  bscreate=$urlbase/bootstrap-createuser.zsh
  bsuser=$urlbase/bootstrap-setupuser.zsh
}

set_targets() {
  # FIXME: instead read pkgs/cmds from config/misc/pkgmatrix.tsv
  common=( zsh gawk rxvt-unicode tmux tree )
  #common=( zsh:zsh gawk:gawk rxvt-unicode:urxvt tmux:tmux tree:tree )
  xpkgs=(  # hopefully these are common across systems
    xclip arandr bdftopcf growl-for-linux gvolwheel parcellite )
  #yums=(    ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  #apts=(    ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  #pacmans=( ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  #zyppers=( ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  #pkgngs=(  ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  #brews=(   ${common[@]} git:git vim:vim tree:tree rubygem-coderay:coderay )
  yums=(    ${common[@]} git vim tree rubygem-coderay )
  apts=(    ${common[@]} git vim rlwrap tree rubygem-coderay )
  pacmans=( ${common[@]} git vim rlwrap tree rubygem-coderay )
  zyppers=( ${common[@]} git vim rlwrap tree rubygem-coderay )
  pkgngs=(  ${common[@]} git vim rlwrap tree rubygem-coderay )
  brews=(   ${common[@]} git vim rlwrap tree rubygem-coderay )
  # Need to check cmds (pkgs impossible) since we don't want reinstalls
  cmds=( git vim tree coderay rlwrap )
  xcmds=( xclip arandr bdftopcf gol gvolwheel parcellite )
}

# Check for sudo privileges or existence of required packages.
check_privs() {
  touch /tmp/foo
  cmd="chown root.root /tmp/foo > /dev/null"
  has_sudo=False has_root=False
  #if ! sudo ls >/dev/null; then
  #if ! chown root.root /tmp/foo >/dev/null; then
  if eval $cmd; then
    echo -e "\nOh wow, you're root. Proceeding..."
    has_root=True
    rm /tmp/foo
    sudo() { eval $@; }
  elif sudo eval $cmd; then
    # Or just whoami??
    echo -e "\nGood, you're using sudo."
    has_sudo=True
  else
    echo -e "\nLooks like you don't have super powers."
    echo -e "Set up sudo if you wish to remedy this."
    has_sudo=False
  fi
}

find_pkg_mgr() {
  echo -e "\nDetermining your package manager"
  for pm_maybe in yum apt-get pacman zypper pkg brew; do
    # Ugh, which isn't even installed on some systems.
    #if which $pm_maybe 2>/dev/null; then
    if [[ -n $(whereis $pm_maybe |sed 's/.*://') ]]; then
      pm=$pm_maybe
      echo "  $pm"
      break
    fi
  done
  if [[ -z $pm ]]; then
    err "could not determine package manager"
  fi
}

grok_system() {
  pkgs=()
  case $pm in
    yum)      pmi="$pm install -y";     osfam=redhat; pkgs=(${yums[@]})    ;;
    apt-get)  pmi="$pm install -y";     osfam=debian; pkgs=(${apts[@]})    ;;
    pacman)   pmi="$pm -S --noconfirm"; osfam=arch;   pkgs=(${pacmans[@]}) ;;
    zypper)   pmi="$pm install -n";     osfam=suse;   pkgs=(${zyppers[@]}) ;;
    pkg)      pmi="$pm install";        osfam=bsd;    pkgs=(${pkgngs[@]})  ;;
    brew)     pmi="$pm install";        osfam=mac;    pkgs=(${brews[@]})   ;;
  esac
  echo -e "\nOS Fam : $osfam\nPkg Mgr: $pm\n"
  [[ $has_sudo == True ]] && pmi="sudo $pmi"
}

set_up_os_specials() {  # aka homebrew
  if [[ $osfam == mac ]]; then
    # FIXME: Ugh, will need 2GB of xcode
    echo -e "\nEnabling Homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    # FIXME: more to do here, I'm sure
  elif [[ $osfam == bsd ]]; then
    # FIXME: should be part of user setup
    #echo "ENABLE: X11 setup by adding this line to ~/.pcdmsessionstart"
    echo -e "\nEnabling use of .xinitrc"
    echo -e "\n./.xinitrc" >> $HOME/.xprofile
    # Set up pkgng?
  elif [[ $osfam == redhat ]]; then
    # consider that fedora probably doesn't need extra repos
    if grep -qiv fedora /etc/*release*; then
      echo -e "Enabling EPEL repository"
      wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
      sudo rpm -Uvh epel-release-*.rpm
    fi
  elif [[ $osfam == arch ]]; then
    echo -e "\nEnabling yaourt/AUR"
    # FIXME
  fi
}

check_for_installed_pkgs() {
  missings=()
  #for p in ${pkgs[@]}; do
  for c in ${cmds[@]}; do
    #which $c >/dev/null 2>&1 || missings+=" $c"
    #whereis $c |cut -f2 -d' ' >/dev/null 2>&1
    which $c >/dev/null 2>&1 || missings=( ${missings[@]} $c )
  done
  if [[ ${#missings} != 0 ]]; then
    echo -e "\nMissing the following essential commands:"
    for m in ${missings[@]}; do echo "  $m"; done
    echo -e "\nI'll try installing them for you shortly.\n"
  fi
}

install_prelims() {
  # Should be the same basic packages on every system
  prelims=(zsh wget curl which passwd)
  if ! eval $pmi ${prelims[@]}; then
    err "unable to install preliminary packages (${prelims[@]}) so cannot proceed."
  fi
}

install_sys_pkgs() {
  echo -e "\nAbout to install the following essential system packages:"
  for p in ${pkgs[@]}; do echo "  $p"; done
  echo
  eval $pmi ${pkgs[@]}
  echo
  read -p "Do you want to install the recommended X11 packages? [Y/n]: " -n1 x11s
  echo
  [[ $x11s != 'n' ]] && eval $pmi ${xpkgs[@]}
}

#---------------------------------------------------------------------
# USERADD
# Section so small that won't bother putting into separate script, for now.
# Will eventually want to enable bulk creation of users via tsv.

# Could be running as sysadmin, existing user with sudo, or luser
# Several types of use cases:
# - sysadmin (root) setting up for brand-new student(s)
# - sysadmin (root) for new self
# - existing (luser) for existing
# - existing (luser) for new self
get_user_info() {
  echo
  if [[ -z $C4R_USER ]]; then
    [[ $has_root == False ]] && append=" (leave blank to skip creation)"
    read -p "New local system username$append: " user
  fi
  if [[ -n $user ]]; then
    newuser='NEW'
  else
    user=$USER
    newuser='EXISTING'
  fi
  echo -e "Setting up for $newuser user: $user\n"
}

set_passwd() {
  echo
  # CentOS has no passwd (but can install)!
  passwd $user
  #read -p 'New user passwd: ' passwd  # Should ask twice
  #echo $user:$passwd |chpasswd $user
}

create_user() {
  # FIXME: should work off list of new users for bulk creation
  wzsh=$(whereis zsh |cut -f2 -d' ')
  if [[ $newuser == NEW ]] && grep -vq "\b$user\b" /etc/passwd; then
    case $pm in
      pacman|yum|apt-get|zypper)
        useradd    -m -s $wzsh $user && set_passwd ;;
      pkg)
        pw useradd -m -s $wzsh $user && set_passwd ;;
      brew)
        #wget https://raw.github.com/code4real/dotfiles/master/contrib/bin/useradd-mac.sh
        wget $uamac
        bash ./useradd-mac.sh $user $user  # full name bogus
        ;;
    esac
  else
    chsh -s $wzsh $user
  fi
}

#---------------------------------------------------------------------

# FIXME: might not work since want new user env
export -f err

bootstrap_installpkgs() {
  :
}

bootstrap_createuser() {
  bscu=bootstrap-createuser.zsh
  wget $bscreate -O /tmp/bootstrap-createuser.zsh
  bscreate=$urlbase/bootstrap-createuser.zsh
  chmod +x /tmp/bootstrap-createuser.zsh
  su -c "zsh /tmp/bootstrap-createuser.zsh" -l $user
}

bootstrap_setupuser() {
  wget $bsuser -O /tmp/bootstrap-setupuser.zsh
  chmod +x /tmp/bootstrap-setupuser.zsh
  su -c "zsh /tmp/bootstrap-setupuser.zsh" -l $user
}

rm_bootstraps() {
  echo -e "\nRemoving bootstrap helper scripts"
  rm bootstrap-*
}

#---------------------------------------------------------------------

get_bootstraps
set_targets
check_privs
find_pkg_mgr
grok_system
set_up_os_specials
check_for_installed_pkgs
install_prelims
install_sys_pkgs

# FIXME: put into separate user-creation bootstrap; will enable multi-user
#        bulk creation
get_user_info
create_user

#bootstrap_installpkgs
#bootstrap_createuser
bootstrap_setupuser

rm_bootstraps

echo -e "\nDONE!"
echo -e "\nTry out the git proxy now in your path:"
echo "  % dotfiles status  # or just: dst"

echo -e "\nTry committing a change to your dotfiles and push it."
echo "  % dotfiles push  # or just: dpu"
