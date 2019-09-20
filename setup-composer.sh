#!/bin/sh
# =============================================================================
#  Installs PHP Composer and tests work
# =============================================================================

echo '=============================='
echo ' Installing PHP Composer'
echo '=============================='

set -eu

NAME_FILE_COMPOSER='composer'
EXTENSION_COMPOSER='.phar'
PATH_DIR_BIN=$(dirname $(which php))
PATH_FILE_BIN_COMPOSER="${PATH_DIR_BIN}/${NAME_FILE_COMPOSER}"
PATH_FILE_SETUP_COMPOSER='/composer-setup.php'
PATH_DIR_CURRENT=$(pwd)

# Verify hash value of the signature file
echo -n '- Verifing installer signature: '
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', '${PATH_FILE_SETUP_COMPOSER}');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', '${PATH_FILE_SETUP_COMPOSER}');")"
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    >&2 echo 'ERROR: Invalid installer signature'
    exit 1
fi
echo 'OK'

echo '- Setup composer:'
php $PATH_FILE_SETUP_COMPOSER
if [ $? -ne 0 ]; then
    echo 'ERROR: Can not install composer.'
    exit 1
fi

echo -n '- Moving composer bin to env path: '
mv "${NAME_FILE_COMPOSER}${EXTENSION_COMPOSER}" "${PATH_FILE_BIN_COMPOSER}" && \
which composer > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'ERROR: Can not find composer in env paths.'
    exit 1
fi
echo 'OK'

echo "- Removing file: ${PATH_FILE_SETUP_COMPOSER}"
rm -f ${PATH_FILE_SETUP_COMPOSER} > /dev/null

exit 0
