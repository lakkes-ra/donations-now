<?php

use Illuminate\Support\Facades\Route;

// The Sitemap route to the sitemap.xml
Route::statamic('/sitemap.xml', 'sitemap/sitemap', [
    'layout' => null,
]);
