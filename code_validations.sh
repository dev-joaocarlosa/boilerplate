#!/usr/bin/env sh
echo "############ Laravel Pint ##############"
./vendor/bin/pint

echo "################ PHPMD ################"
./vendor/bin/phpmd app/ text phpmd-ruleset.xml && ./vendor/bin/phpmd config/ text phpmd-ruleset.xml

echo "########### PHP CODESNIFFER ###########"
./vendor/bin/phpcbf app/ --extensions=php  --standard=PSR12
./vendor/bin/phpcs app/ --extensions=php  --standard=PSR12

echo "############### PHPSTAN ###############"
./vendor/bin/phpstan analyse -l 5 -c phpstan.neon app/ config/

echo "############### GRUMPHP ###############"
./vendor/bin/grumphp run

#echo "############### PHPUNIT ###############"
#./vendor/bin/phpunit --bootstrap vendor/autoload.php tests/
