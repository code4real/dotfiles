#! /usr/bin/env zsh

# bootstrap-setupuser — install essentials for user (not root)

GH_USER=$1  # not getting exported, unexpectedly

switch_to_luser() {
  if [[ $has_root == True ]]; then
    echo -e "\nSwitching you to act as normal user $user now"
    su $user
  fi
}

co_maybe() {
  url=$1 dpath=$2 desc=$3;
  if [[ ! -d $dpath ]]; then
    echo -e "\nInstalling $desc to $dpath\n"
    git clone $url $dpath
  else
    print "Already had clone at $dpath"
  fi
}

github_setup() {
  [[ -z $GH_USER ]] &&
    read -p 'GitHub username: ' GH_USER ||
    echo "Using $GH_USER as GitHub username"
  export GH_USER
  dummy=https://raw.github.com/$GH_USER/dotfiles/master/config/zsh/functions/foo
  echo "Checking for existence of your forked dotfiles repo on GitHub..."
  if wget -q $dummy; then
    rm foo 
    echo "Cool, looks like you've already forked your dotfiles repo."
  else
    err "Oops. You need to fork this dotfiles repo on github.com:\n" \
        " https://github.com/code4real/dotfiles\n" \
        " (and then re-run this)\n" \
        "\nInstructions: https://help.github.com/articles/fork-a-repo\n"
  fi
}

generate_keys() {
  keyfile=~/.ssh/id_rsa
  while [[ ! -f $keyfile ]]; do
    echo -e "\nGenerating new ssh key using user password"
    #ssh-keygen -N $passwd -f ~/.ssh/id_rsa
    ssh-keygen -f $keyfile
  done
  # FIXME: or maybe use github api to set this for user
  echo -e "\nNow add this machine to your github profile:"
  echo "  % \$BROWSER https://github.com/settings/ssh"
  echo -e "\nPaste the following text into the form as your key:\n"
  cat $keyfile.pub
  # FIXME: only if display:1 ?
  if [[ $DISPLAY == ':0' ]]; then
    print 'key is already paste-able from you clipboard'
    cat $keyfile.pub | xclip
  fi
  print
  read -q 'junk?Press ENTER when done'
}

install_zsh_syntax() {
  zhi=https://github.com/zsh-users/zsh-syntax-highlighting
  zhi_local=~/local/src/zsh-syntax-highlighting # ~ not working?!
  mkdir -p ~/local/src
  co_maybe $zhi $zhi_local 'zsh syntax highlighting'
  echo -e "\nHighlighting will be auto-enabled/configured by your dotfiles."
}

install_dotfiles() {
  # http://silas.sewell.org/blog/2009/03/08/profile-management-with-git-and-github/
  echo -e "\nInstalling dotfiles\n"
  cd ~
  # Check for existence of ~/dotfiles before proceeding
  if [[ -d .git ]]; then
    err "Whoa, you already have a git repo here."
  fi
  if [[ ! -d dotfiles ]]; then
    echo -e "\nCloning your git repo"
    #git clone git@github.com/$GH_USER/dotfiles.git
    git clone https://github.com/AllexElliott/dotfiles.git
    existing=()
    for resource in dotfiles/.* dotfiles/* ; do
      [[ -e $resource ]] && existing+=$resource
      if (( $resource > 0 )); then
        err "You seem to already have resources in your home. rm or mv these:" \
            "${resources[@]}"
      fi
    done
    mv dotfiles/.* dotfiles/* .
    mv .git .dotfiles.git/
  fi
}

install_vim_bundles() {
  vundle_path=~/.vim/bundle/vundle
  mkdir -p $vundle_path
  co_maybe https://github.com/gmarik/vundle.git $vundle_path 'vim bundles'
  vim +BundleInstall +qall
}

install_orp() {
  local repo=https://github.com/MicahElliott/Orp-Font dpath=~/local/src/Orp-Font
  co_maybe $repo $dpath 'fancy small bitmap fonts'
  cd $dpath
  for font in lib/*.bdf; do ./xfont-install.zsh $font; done
  cd ~
}

install_nvm() {
  co_maybe https://github.com/creationix/nvm.git ~/.nvm 'Node Version Manager (NVM)'
  print "Enabling NVM"
  . ~/.nvm/nvm.sh
  echo -e "Installing your first Node\n"
  nvm install 0.10
  nvm use     0.10
  npm install -g LiveScript
  echo -e "You can now fire up an interactive LiveScript REPL:"
  echo -e "  % ils\n"
}

install_chuck() {
  # Chuck is a standalone exec so can simply copy around
  cd ~/local/src
  wget http://chuck.cs.princeton.edu/release/files/chuck-1.3.3.0.tgz
  tar xzvf chuck-1.3.3.0.tgz
  cd chuck-1.3.3.0/src
  if [[ $osfam == linux ]]; then
    make linux-alsa
  else
    # FIXME: won't build on bsd
    # https://lists.cs.princeton.edu/pipermail/chuck-dev/2009-October/000382.html
    # Need to make into a port
    echo -e "Chuck not yet ported to BSD"
    ##gmake bsd-alsa CC=gcc49 CXX=g++49
  fi
  cp chuck ~/local/bin/
  chmod +x ~/local/bin/chuck
}

set_internals() {
# FIXME: set some things inside configs (envars.zsh, .Xdefaults) browser
}


#switch_to_luser
generate_keys
install_zsh_syntax
install_dotfiles
install_vim_bundles
install_orp
install_nvm
install_chuck
set_internals
