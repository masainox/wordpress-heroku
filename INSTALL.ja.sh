#!/bin/sh

heroku create -b git://github.com/iphoting/heroku-buildpack-php-tyler.git

heroku addons:add heroku-postgresql:dev

heroku pg:promote `heroku config | grep 'HEROKU_POSTGRESQL_' | sed -e "s/\:.*//"`

# create a new branch
git checkout -b production

# make the wp-config.php and commit wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/  > salt.txt
cat wp-config-sample-first-part.txt  salt.txt  wp-config-sample-second-part.txt > wp-config.php
rm salt.txt

>.gitignore
git add wp-config.php
git commit -m "Initial WordPress commit"

# deploy to heroku
git push heroku production:master
