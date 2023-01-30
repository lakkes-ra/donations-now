const mix = require('laravel-mix');

// Compile javascript files
mix.js('resources/js/*', 'public/js/site.js')

// Compile css files with tailwindcss
mix.postCss('resources/css/tailwind.css', 'public/css/site.css', [
    require('postcss-import'),
    require('tailwindcss'),
    require('postcss-nested'),
    require('autoprefixer'),
])

// Versioning if compiling for production
mix.version();

// Can be removed, if you do want to get notified
mix.disableNotifications();

/*
 |--------------------------------------------------------------------------
 | Statamic Control Panel
 |--------------------------------------------------------------------------
 |
 | Feel free to add your own JS or CSS to the Statamic Control Panel.
 | https://statamic.dev/extending/control-panel#adding-css-and-js-assets
 |
 */

 mix.postCss(
  'resources/css/cp-dev.css',
  'public/vendor/statamic/cp/css/cp-dev.css'
);
