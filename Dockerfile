ARG NAME_TAG_IMAGE=latest

FROM keinos/php8-jit:$NAME_TAG_IMAGE

# Add Composer's global bin path
ENV PATH="~/.composer/vendor/bin:$PATH"

USER root
COPY setup-composer.sh /setup-composer.sh
RUN apk --no-cache add \
        git \
# Ensure www-data user exists
	&& ( getent group www-data || addgroup -g 82 -S www-data ) \
	&& ( id -u www-data &>/dev/null || adduser -u 82 -D -S -G www-data www-data ) \
    && ln -s /home/www-data /app \
# Set up composer and run test
    && /setup-composer.sh \
# Copy pubkey for composer verification
    && mkdir -m 0777 /home/www-data/.composer \
    && cp -R ~/.composer/*.pub /home/www-data/.composer \
    && ls -la / | grep app \
    && rm -f /setup-composer.sh

USER www-data
WORKDIR /app
