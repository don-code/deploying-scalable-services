#!/bin/bash

docker run -d --restart=always -e WORDPRESS_DB_HOST=${wordpress_db_host} -e WORDPRESS_DB_USER=${wordpress_db_user} -e WORDPRESS_DB_PASSWORD=${wordpress_db_password} -e WORDPRESS_DB_NAME=${wordpress_db_name} -p 80:80 wordpress:php7.3-apache
