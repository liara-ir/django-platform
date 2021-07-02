#/bin/bash

if [ "$__DJANGO_MIRROR" = "true" ]; then
  echo '> Using mirror: ' $__DJANGO_MIRRORURL
  export PIP_INDEX=$__DJANGO_MIRRORURL/pypi
  export PIP_INDEX_URL=$__DJANGO_MIRRORURL/simple
  export __DJANGO_MIRRORHOST=$(echo $__DJANGO_MIRRORURL | awk -F/ '{print $3}')
  pip install --trusted-host $__DJANGO_MIRRORHOST --disable-pip-version-check --no-cache-dir -r requirements.txt
  pip install --trusted-host $__DJANGO_MIRRORHOST --disable-pip-version-check --no-cache-dir dj-database-url 'gunicorn==20.1.0'
fi