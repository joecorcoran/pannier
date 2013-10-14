# Using Pannier with Sinatra

This directory contains a minimal example of integrating Pannier into a Sinatra
application.

## Development

Start the app. Assets are served from the `assets` directory.

```
rackup
```

## Production

Process the assets.
```
pannier process -E production
```

Start the app. Assets are served from the `public` directory.
```
rackup -E production
```
