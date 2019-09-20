#!/bin/sh
# Note: Mount this file on /app directory.

# ============================
#  Running composer diagnoses
# ============================
set -eu
./test-composer.sh

cat <<TITLE
=============================================================================
 Running Sample Machine Learning Script
 - Testing the Classification of Nearest Neighbors' method.
=============================================================================
TITLE

PATH_DIR_SCRIPT=$(cd $(dirname $0); pwd)
PATH_FILE_SAMPLE="${PATH_DIR_SCRIPT}/sample.php"

cd $PATH_DIR_SCRIPT

echo '- COMPOSER: Installing php-ml package'
composer require php-ai/php-ml

# Create source code
cat <<'SOURCECODE' > $PATH_FILE_SAMPLE
<?php

require_once __DIR__ . '/vendor/autoload.php';

use Phpml\Classification\KNearestNeighbors;

$samples = [[1, 3], [1, 4], [2, 4], [3, 1], [4, 1], [4, 2]];
$labels  = ['a', 'a', 'a', 'b', 'b', 'b'];

$classifier = new KNearestNeighbors();
$classifier->train($samples, $labels);

echo $classifier->predict([3, 2]);
// return 'b'

SOURCECODE

# Run test
expect='b'; echo 'Expect:' $expect
result=$(php $PATH_FILE_SAMPLE); echo 'Result:' $result

if [ ${expect} = ${result} ]; then
   echo 'OK: Test passed'
   exit 0
fi

echo 'NG: Test failed'
exit 1
