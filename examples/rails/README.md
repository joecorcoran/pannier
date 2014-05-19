# Using Pannier with Rails

This directory contains a minimal example of integrating Pannier into a Rails
application.

```bash
$ cd example-app
$ bundle install
```

To mount Pannier within a Rails application (to serve your assets, use
middleware, include asset tags etc.) you need to require the mounted version.
See **Gemfile**.

Pannier is connected to Rails in **config.ru**, the rackup config file that
is generated at the root of all new Rails apps.

Open **app/helpers/application_helper.rb** to see how you can include assets
in the page using Pannier.

## Development

```bash
$ pannier process
$ ./bin/rails server
```

## Other environments

```bash
$ pannier process -E production
$ RAILS_ENV=production ./bin/rails server
```
