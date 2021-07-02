#!/bin/bash

source /usr/local/lib/liara/util.sh

# Append our custom settings
if [ "$__DJANGO_MODIFY_SETTINGS" = "true" ]; then
  settings_file=$(/usr/local/lib/liara/find-settings.sh)

  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    err
    err "Error: We have found multiple settings files for your Django app:"
    err "$(echo "$settings_file" | awk '{print "  " NR  ") " $s}')"
    err
    err "Create a liara.json file in your project's root directory with the following content:"
    err
    err "{
  \"django\": {
    \"settingsFile\": \"my-project/settings.py\"
  }
}"
    err
    err "You should put your actual settings file path into the above file."
    err "> Read more: https://docs.liara.ir/errors/django-settings-file"
    err
    exit $exit_code
  fi

  cat /usr/local/lib/liara/settings-template.py >> "$settings_file"
fi

set -e

if [ "$__DJANGO_COLLECTSTATIC" = "true" ]; then
  echo '> Running collectstatic...'
  mkdir staticfiles
  python manage.py collectstatic --no-input
fi

if [ "$__DJANGO_COMPILEMESSAGES" = "true" ]; then
  echo '> Running compilemessages...'
  python manage.py compilemessages
fi

if [ -f $ROOT/supervisor.conf ]; then
  echo '> Applying supervisor.conf...'
  mkdir -p /etc/supervisord.d
  mv $ROOT/supervisor.conf /etc/supervisord.d
fi
