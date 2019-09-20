#!/bin/sh
# Note: Mount this file and "run-sample-ml.sh" on /app directory, and run "run-sample-ml.sh".

set -eu

echo '=============================='
echo ' Running Composer diagnose'
echo '=============================='
composer diagnose

echo '=============================='
echo ' Running Hello-World for test'
echo '=============================='

PATH_DIR_SCRIPT=$(cd ~/; pwd)
NAME_FILE_SAMPLE='sample.php'
PATH_DIR_SAMPLE="${PATH_DIR_SCRIPT}/sample"
PATH_FILE_SAMPLE="${PATH_DIR_SAMPLE}/${NAME_FILE_SAMPLE}"

mkdir $PATH_DIR_SAMPLE && \
cd $PATH_DIR_SAMPLE && \
composer init --quiet --name sample/hello-world --require rivsen/hello-world:dev-master && \
composer install

cat << 'SCRIPTSOURCE' > $PATH_FILE_SAMPLE
<?php
require_once "vendor/autoload.php";

$hello = new Rivsen\Demo\Hello();
echo $hello->hello(), PHP_EOL;
exit(0);

SCRIPTSOURCE

php $PATH_FILE_SAMPLE && \
rm -rf $PATH_DIR_SAMPLE
