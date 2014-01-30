#!/bin/bash

rm -r log
rm -r tmp
rm -r public/uploads

rake db:drop
rake db:create
rake db:migrate
rake db:seed
rake db:test:prepare
