#!/bin/bash

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

# Ubuntu 22+ will prompt to restart services without these set
export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

set -e
log_info() {
  printf "\n\e[0;35m $1\e[0m\n\n"
}

if [ ! -f "$HOME/.bashrc" ]; then
  touch $HOME/.bashrc
fi

log_info "Updating Packages..."
  sudo -E apt-get update

log_info "Install fail2ban..."
  sudo -E apt-get -y install fail2ban

log_info "Installing Git..."
  sudo -E apt-get -y install git

log_info "Installing build essentials..."
  sudo -E apt-get -y install build-essential

log_info "Installing libraries for common gem dependencies..."
  sudo -E apt-get -y install libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libreadline-dev libssl-dev zlib1g-dev libsnappy-dev libyaml-dev libffi-dev

log_info "Installing curl..."
  sudo -E apt-get -y install curl

  # if rbenv is already installed we rm it and install it again
  rm -rf $HOME/.rbenv
  log_info "Installing rbenv ..."
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv

    if ! grep -qs "rbenv init" ~/.bashrc; then
      printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
      printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
  log_info "Installing ruby-build, to install Rubies..."
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

ruby_version="3.2.2"

log_info "Installing Ruby $ruby_version..."
  rbenv install "$ruby_version"

log_info "Setting $ruby_version as global default Ruby..."
  rbenv global $ruby_version
  rbenv rehash

log_info "Updating to latest Rubygems version..."
  gem update --system

log_info "Installing Bundler..."
  gem install bundler

echo "Done."
