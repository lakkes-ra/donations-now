#!/bin/bash

echo 'Composer install'
echo '-----------------'
composer install
echo 'npm ci'
echo '-----------------'
npm ci
echo 'Build assets'
echo '-----------------'
npm run dev
