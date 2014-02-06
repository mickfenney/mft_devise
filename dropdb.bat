rm -r log
rm -r tmp
rm -r public/uploads
rm -r public/assets

rake db:drop && rake db:create && rake db:migrate && rake db:seed && rake db:test:prepare
