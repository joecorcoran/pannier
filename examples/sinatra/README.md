# Using Pannier with Sinatra

This directory contains a minimal example of integrating Pannier into a Sinatra
application.

To mount Pannier within a Rack application (to serve your assets, use
middleware, include asset tags etc.) you need to require the mounted version as
follows.

```ruby
require 'pannier/mounted'
```

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
