#!/bin/sh

if [ -d webshopbackend ]
then
    echo
    echo
    echo "$(realpath webshopbackend) already exists! ..."
    echo

    exit 1
fi

set -xe

curl --fail --show-error --silent https://start.spring.io/starter.zip \
  -d type=maven-project \
  -d language=java \
  -d bootVersion=4.1.1 \
  -d groupId=de.hsesslingen \
  -d artifactId=webshopbackend \
  -d name=webshopbackend \
  -d packageName=de.hsesslingen.webshopbackend \
  -d packaging=jar \
  -d configurationFileFormat=properties \
  -d javaVersion=21 \
  -d dependencies=web,data-jpa,h2 \
  -o webshopbackend.zip

unzip webshopbackend.zip -d ./webshopbackend

rm webshopbackend.zip

