#!/bin/bash
if [ -f ".env.local" ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
    echo "The environment variables are loaded from .env.local"
else
    echo "File .env.local was not found!"
    exit 1
fi

echo "DB_URL: $DB_URL"
echo "DB_USERNAME: $DB_USERNAME"
echo "DB_PASSWORD: $DB_PASSWORD"

cd src/main/resources

liquibase \
  --url="$DB_URL" \
  --username="$DB_USERNAME" \
  --password="$DB_PASSWORD" \
  --driver=org.postgresql.Driver \
  --changeLogFile=db/migrations/master.yaml \
  update

echo "Liquibase migration executed!"