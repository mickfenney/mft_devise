echo Y | mysqladmin -u root -ppassword drop mft-devise-test
echo Y | mysqladmin -u root -ppassword drop mft-devise-dev

mysqladmin -u root -ppassword create mft-devise-test
mysqladmin -u root -ppassword create mft-devise-dev

bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake db:test:prepare
