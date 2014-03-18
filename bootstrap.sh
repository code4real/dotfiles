#! /bin/sh

# bootstrap — provision a new system with essential packages

# Could be run from curl!
# Assume zsh not yet installed

#SKIP_I3=false
WM=i3

os=${1?Must provide os family (arch|debian|redhat|bsd|mac)}
ghuser=${2?Must provide github username}
#os=$(uname -o)
#linos=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

echo "You should fork this repo on github.com:"
echo "  https://github.com/code4real/dotfiles"
echo -e "\nAnd then clone yours:"
echo "  git clone git@github.com:$ghuser/dotfiles.git "

echo -e "\nI'm about to install some essential packages onto your system."
echo "Kill me (ctrl-C) within 5 seconds if you object."
sleep 5

echo -e "\nInstalling essential system packages.\n"
xtargets=( xclip arandr bdftopcf parcellite )
targets=( $WM )
targets+=( wget curl htop git zsh tmux vim tree )  # common across
if [[ $os == arch   ]]; then
  targets+=( zsh git rxvt-unicode urxvt-perls tmux vim )
  sudo pacman -S ${targets[@]}
elif [[ $os == redhat ]]; then
  targets+=( coreutils git zsh gawk vim rxvt-unicode-256color wget tmux )
  sudo yum install -y wget
  # Would have to install wget first, and fedora doesn't need epel
  wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  sudo rpm -Uvh epel-release-*.rpm
  sudo yum install -y ${targets[@]}
elif [[ $os == debian ]]; then
  targets+=( zsh git gawk vim rxvt-unicode-256color wget tmux bdftopcf )

  sudo apt-get -y install ${targets[@]}
elif [[ $os == bsd ]]; then
  targets+=( coreutils git zsh gawk rxvt-unicode tmux vim tree rubygem-coderay
  bdftopcf growl-for-linux gvolwheel )
  #echo "ENABLE: X11 setup by adding this line to ~/.pcdmsessionstart"
  echo -e "\n./.xinitrc" >> ~/.xprofile
  sudo pkg install ${targets[@]}
elif [[ $os == mac ]]; then
  targets+=( coreutils git zsh gawk vim rxvt-unicode-256color wget tmux )
  # Set up homebrew
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
else
  echo "Unsupported OS: $os"
fi

echo -e "\nInstalling dotfiles\n"
cd ~
if [[ -d .git ]]; then
  print "Whoa, you already have a git repo here."
  exit 1
fi
if [[ ! -d dotfiles ]]; then
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

echo "\nInstalling vim bundles\n"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall

echo "\nInstalling vim bundles\n"
git clone https://github.com/MicahElliott/Orp-Font ~/src/Orp-Font
cd ~/src/Orp-Font
for font in lib/*.bdf; do ./xfont-install.zsh $font; done

echo "\nInstalling zsh syntax highlighting\n"

echo
echo 'DONE!'
echo -e "\nTry out the git proxy now in your path:"
echo "  dotfiles status  # or just: dst"