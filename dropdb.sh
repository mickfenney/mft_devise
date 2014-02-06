#!/bin/bash

echo "+ Removing log directory..."
rm -r log
echo "+ Removing tmp directory..."
rm -r tmp
echo "+ Removing public/uploads directory..."
rm -r public/uploads
echo "+ Removing public/assets directory..."
rm -r public/assets

echo "+ Dropping Database..."
rake db:drop
echo "+ Creating Database..."
rake db:create
echo "+ Migrating Database..."
rake db:migrate
echo "+ Seeding Database..."
rake db:seed
echo "+ Preparing test Database..."
rake db:test:prepare

echo "+ All tasks have now been completed"
