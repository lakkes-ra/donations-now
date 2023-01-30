#!/bin/bash

echo 'Composer install'
echo '-----------------'
composer install
echo 'npm ci'
echo '-----------------'
npm ci
echo 'Generate .env'
echo '-----------------'
cp .env.example .env
php artisan key:generate
echo 'Build assets'
echo '-----------------'
npm run dev
