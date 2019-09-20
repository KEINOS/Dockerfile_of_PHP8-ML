[![](https://images.microbadger.com/badges/image/keinos/php8-ml.svg)](https://microbadger.com/images/keinos/php8-ml "View image info on microbadger.com")
[![](https://img.shields.io/docker/cloud/automated/keinos/php8-ml)](https://hub.docker.com/r/keinos/php8-ml "Docker Cloud Automated build")
[![](https://img.shields.io/docker/cloud/build/keinos/php8-ml)](https://hub.docker.com/r/keinos/php8-ml/builds "Docker Cloud Build Status")

# Dockerfile of PHP8-ML

Dockerfile of [PHP-ML](https://php-ml.org/), the Machine Learning library for PHP. (PHP8-ish + JIT on Alpine Linux)

```bash
docker pull keinos/php8-ml:latest
```

## Basic Image Info

- PHP: Closest version to PHP8 and JIT enabled.
- Source: https://github.com/KEINOS/Dockerfile_of_php8-ML @ GitHub
- Image: https://hub.docker.com/r/keinos/php8-ml @ Docker Hub
  - Target architecture: x86_64 (Intel. Maybe AMD too but ARM)
- Base Image: [keinos/php8-jit](https://hub.docker.com/r/keinos/php8-jit)
- User: `www-data`
- Entry Point: not set
- Composer: Installed under `/usr/local/bin/composer`
- Working Directory: `/app` (alias of `/home/www-data`)
- PHP-ML: Install via composer (`composer require php-ai/php-ml`)
  - Ref: [Repo](https://github.com/php-ai/php-ml) @ GitHub
  - Ref: [Docs](https://php-ml.readthedocs.io/en/latest/) @ ReadTheDocs
  - Sample `/app/composer.json` :

    ```json
    {
        "require": {
            "php-ai/php-ml": "^0.4.1"
        }
    }
    ```

## Sample Usage

Mount the script on `/app` and run.

```shellsession
$ docker run --rm -it -v $(pwd)/sample.php:/app/sample.php keinos/php8-ml:latest /bin/sh
/ $ cd /app
/ $ ls
sample.php
/ $ composer require php-ai/php-ml
...
/ $ php ./sample.php
b
```

- Sample script:

    ```php
    <?php
    /* sample.php */

    require_once __DIR__ . '/vendor/autoload.php';

    use Phpml\Classification\KNearestNeighbors;

    $samples = [[1, 3], [1, 4], [2, 4], [3, 1], [4, 1], [4, 2]];
    $labels  = ['a', 'a', 'a', 'b', 'b', 'b'];

    $classifier = new KNearestNeighbors();
    $classifier->train($samples, $labels);

    echo $classifier->predict([3, 2]), PHP_EOL;
    // expect return: 'b'
    ```
