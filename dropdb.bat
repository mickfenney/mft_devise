echo Y | mysqladmin -u root -ppassword drop mft-devise-test
echo Y | mysqladmin -u root -ppassword drop mft-devise-dev

mysqladmin -u root -ppassword create mft-devise-test
mysqladmin -u root -ppassword create mft-devise-dev

rake db:migrate
rake db:seed
rake db:test:prepare
