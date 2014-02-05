#!/bin/bash

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

echo "+ Git Clone the mft_divise repository..."
git clone https://github.com/mick-asoftware/mft_devise.git

echo "+ Copy the application.yml file in place..."
cp mft_devise/config/application.example.yml mft_devise/config/application.yml

echo "+ Installing ruby-1.9.3-p448..."
rvm install ruby-1.9.3-p448

echo "+ Removing ruby-2.0.0-p247..."
rvm remove ruby-2.0.0-p247

echo "+ cd into the $HOME/.rvm/gems directory..."
cd $HOME/.rvm/gems

echo "+ Remove the ruby-2.0.0-p247 directory..."
rm -rf ruby-2.0.0-p247

echo "+ Remove the ruby-2.0.0-p247\@global directory..."
rm -rf ruby-2.0.0-p247\@global

echo "+ cd into the $HOME/.rvm/archives directory..."
cd $HOME/.rvm/archives

echo "+ Removing any archive files"
rm *

echo "+ cd into the $HOME/workspace/mft_devise directory..."
cd $HOME/workspace/mft_devise

echo "+ Running gem install bundler..."
gem install bundler

echo "+ Running gem install rake..."
gem install rake

echo "+ Running bundle -j 4..."
bundle install -j 4

echo "+ Running parts install mysql..."
parts install mysql

echo "+ cd into the $HOME/.parts/archives directory..."
cd $HOME/.parts/archives

echo "+ Removing any archive files"
rm *

echo "+ cd into the $HOME/workspace/mft_devise/ directory..."
cd $HOME/workspace/mft_devise/

echo "+ Running parts start mysql..."
parts start mysql

echo "+ Running database creation and migration dropdb.sh file..."
./dropdb.sh

echo "+ Running rspec spec..."
rspec spec

