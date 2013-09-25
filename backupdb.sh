#!/bin/bash

mysqldump --host localhost -u root --password=password --opt --no-data --add-drop-table --quote-names mft-devise-dev | gzip > tmp/mft_schema.sql.gz
mysqldump --host localhost -u root --password=password --skip-extended-insert --quote-names --no-create-info -c mft-devise-dev | gzip > tmp/mft_data.sql.gz
