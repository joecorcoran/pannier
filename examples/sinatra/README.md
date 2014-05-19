# Using Pannier with Sinatra

This directory contains a minimal example of integrating Pannier into a Sinatra
application.

```bash
$ bundle install
```

To mount Pannier within a Rack application (to serve your assets, use
middleware, include asset tags etc.) you need to require the mounted version as
follows.

```ruby
require 'pannier/mounted'
```

Pannier is connected to your Sinatra app in **config.ru**, the rackup config
file.

Open **app.rb** to see how you can include assets in the page using Pannier.

## Development

```bash
$ pannier process
$ rackup
```

## Other environments

```bash
$ pannier process -E production
$ rackup -E production
```
