#!/bin/sh

sudo apt update

sudo apt install -y openjdk-21-jdk maven

echo
echo "----------------------------------------"
echo

java --version


echo
echo "----------------------------------------"
echo

mvn --version

