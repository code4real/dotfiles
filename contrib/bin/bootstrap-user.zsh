#! /usr/bin/env zsh

# bootstrap-user — install essentials for user (not root)

switch_to_luser() {
  if [[ $has_root == True ]]; then
    echo -e "\nSwitching you to act as normal user $user now"
    su $user
  fi
}

generate_keys() {
  if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
    echo -e "\nGenerating new ssh key using user password"
    ssh-keygen -N $passwd -f ~/.ssh/id_rsa
  fi
  # FIXME: or maybe use github api to set this for user
  echo -e "\nFollow these instructions to add this machine to your github profile:"
  echo "  % \$BROWSER http://... "
  echo -e "\nPaste the following text as your key (already on your clipboard):"
  cat ~/.ssh/id_rsa.pub
  cat ~/.ssh/id_rsa.pub | xclip 
}

install_zsh_syntax() {
  zhi=git://github.com/zsh-users/zsh-syntax-highlighting.git
  zhi_local=$HOME/local/src/zsh-syntax-highlighting # ~ not working?!
  mkdir -p $HOME/local/src
  echo -e "\nInstalling zsh syntax highlighting to $zhi_local\n"
  git clone $zhi $zhi_local
  echo -e "\nHighlighting will be auto-enabled/configured by your dotfiles.\n"
}

install_dotfiles() {
  # http://silas.sewell.org/blog/2009/03/08/profile-management-with-git-and-github/
  echo -e "\nInstalling dotfiles\n"
  cd $HOME
  # Check for existence of ~/dotfiles before proceeding
  if [[ -d .git ]]; then
    err "Whoa, you already have a git repo here."
  fi
  if [[ ! -d dotfiles ]]; then
    echo -e "\nCloning your git repo"
    git clone git@github.com:$ghuser/dotfiles.git
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
  echo -e "\nInstalling vim bundles\n"
  git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
  vim +BundleInstall +qall
}

install_orp() {
  echo -e "\nInstalling fancy small bitmap font\n"
  git clone https://github.com/MicahElliott/Orp-Font $HOME/local/src/Orp-Font
  cd $HOME/local/src/Orp-Font
  for font in lib/*.bdf; do ./xfont-install.zsh $font; done
}

install_nvm() {
  # FIXME: $HOME / ~ missing; account/su problem???
  #   Need su - -i (interactive)?
  echo -e "\nInstalling Node Version Manager (NVM) to $HOME/.nvm\n"
  git clone https://github.com/creationix/nvm.git $HOME/.nvm
  echo -e "Installing your first Node\n"
  en-nvm
  node install 0.10
  npm install -g LiveScript
  echo -e "You can now fire up an interactive LiveScript REPL:"
  echo -e "  % ils\n"
}

# Luser
switch_to_luser
generate_keys
install_zsh_syntax
install_dotfiles
install_vim_bundles
install_orp
install_nvm