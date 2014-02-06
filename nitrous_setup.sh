#!/bin/bash

###########################################################
# Nitrous Setup Script
# You may need to modify these variables
# GIT_REPO APPNAME RUBY_V1 RUBY_V2
###########################################################

GIT_REPO="https://github.com/mick-asoftware/mft_devise.git"
APPNAME="mft_devise"
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

echo "+ Git Clone the $APPNAME repository..."
git clone $GIT_REPO

if [ -f $HOME/workspace/$APPNAME/config/application.yml ]; then
  echo "+ The $HOME/workspace/$APPNAME/config/application.yml already exists."
else
  echo "+ Copying the application.yml file in place..."
  cp $HOME/workspace/$APPNAME/config/application.example.yml $HOME/workspace/$APPNAME/config/application.yml  
fi

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

echo "+ cd into the $HOME/workspace/$APPNAME directory..."
cd $HOME/workspace/$APPNAME

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

echo "+ Removing any archive files..."
rm *

echo "+ cd into the $HOME/workspace/$APPNAME/ directory..."
cd $HOME/workspace/$APPNAME/

echo "+ Running parts start mysql..."
parts start mysql

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
cat $HOME/workspace/$APPNAME/config/application.yml

echo "+ Completed the Nitrous Setup for $APPNAME"
