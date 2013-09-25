gunzip < tmp/mft_schema.sql.gz | mysql -u root -ppassword mft-devise-dev
gunzip < tmp/mft_data.sql.gz | mysql -u root -ppassword mft-devise-dev
