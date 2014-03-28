#!/bin/bash

###########################################################
# Nitrous Setup Script
# You may need to modify these variables
# APPNAME APPPATH GIT_REPO RUBY_V1 RUBY_V2
###########################################################

APPNAME="mft_devise"
APPPATH="$HOME/workspace/$APPNAME"
GIT_REPO="https://github.com/mick-asoftware/$APPNAME.git"
RUBY_V1="ruby-1.9.3-p448"
RUBY_V2="ruby-2.0.0-p247"

echo "+ Starting the Nitrous Setup for $APPNAME"

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
  echo "+ Sourcing the user RVM installation..."
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
  echo "+ Sourcing the root RVM installation..."
else
  echo "- ERROR: An RVM installation was not found."
fi

echo "+ Setup git globals"
git config --global user.email "mick@asoftware.net.au"
git config --global user.name "mick-asoftware"
git config --global push.default simple

echo "+ Git Clone the $APPNAME repository..."
git clone $GIT_REPO

if [ -f $APPPATH/config/application.yml ]; then
  echo "+ The $APPPATH/config/application.yml already exists."
else
  echo "+ Copying the application.yml file in place..."
  cp $APPPATH/config/application.example.yml $APPPATH/config/application.yml  
fi

echo "+ Upgrading the rvm..."
rvm get stable

echo "+ Installing $RUBY_V1..."
rvm install $RUBY_V1

echo "+ Removing $RUBY_V2..."
rvm remove $RUBY_V2

echo "+ cd into the $HOME/.rvm/gems directory..."
cd $HOME/.rvm/gems

echo "+ Remove the $RUBY_V2 directory..."
rm -rf $RUBY_V2

echo "+ Remove the $RUBY_V2\@global directory..."
rm -rf $RUBY_V2\@global

echo "+ cd into the $HOME/.rvm/archives directory..."
cd $HOME/.rvm/archives

echo "+ Removing any archive files"
rm *

echo "+ cd into the $APPPATH directory..."
cd $APPPATH

echo "+ Running gem install bundler..."
gem install bundler

echo "+ Running gem install rake..."
gem install rake

echo "+ Running bundle -j 4..."
bundle install -j 4

echo "+ Running parts install postgresql..."
parts install postgresql

echo "+ cd into the $HOME/.parts/archives directory..."
cd $HOME/.parts/archives

echo "+ Removing any archive files..."
rm *

echo "+ cd into the $APPPATH/ directory..."
cd $APPPATH

echo "+ Running parts start postgresql..."
parts start postgresql

echo "+ Creating Database..."
rake db:create

echo "+ Migrating Database..."
rake db:migrate

echo "+ Seeding Database..."
rake db:seed

echo "+ Preparing test Database..."
rake db:test:prepare

echo "+ Running rspec spec..."
rspec spec

echo "+ $APPNAME application configuration"
cat $APPPATH/config/application.yml

echo "+ Completed the Nitrous Setup for $APPNAME"
