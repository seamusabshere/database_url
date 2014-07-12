# DatabaseUrl

Convert back and forth between Heroku-style `ENV['DATABASE_URL']` and Rails/ActiveRecord-style `config/database.yml` config hashes.

## Usage

### Methods

    DatabaseUrl.to_active_record_hash(url = nil)
    DatabaseUrl.to_active_record_url(hash)
    DatabaseUrl.to_sequel_hash(url = nil)
    DatabaseUrl.to_sequel_url(hash)

### Get `DATABASE_URL` from config hash

You pass it a hash (string or symbol keys, doesn't matter) and it gives you a URL:

    >> c = YAML.load_file('/path/to/config/database.yml')
    => {"development"=>{"adapter"=>"mysql2", "database"=>"myapp_development", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}, "test"=>{"adapter"=>"mysql2", "database"=>"myapp_test", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}, "production"=>{"adapter"=>"mysql2", "database"=>"myapp", "username"=>"myapp", "password"=>"XXX", "encoding"=>"utf8"}, "cucumber"=>{"adapter"=>"mysql2", "database"=>"myapp_cucumber", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}}
    >> DatabaseUrl.to_active_record_url c['development']
    => "mysql2://root:password@127.0.0.1/myapp_development?encoding=utf8"

### Get config hash from `DATABASE_URL`

    >> DatabaseUrl.to_active_record_hash('postgres://uuu:xxx@127.0.0.1:1234/abc')
    => {:adapter=>"postgres", :host=>"127.0.0.1", :port=>1234, :database=>"abc", :user=>"uuu", :password=>"xxx"}

If you omit the argument, it will try `ENV['DATABASE_URL']`

## Query parameters supported

* `encoding`
* `pool`

## TODO

* all query params
* automatically pull from config/database.yml
* automatically pull from ActiveRecord::Base.connection_config

## Copyright

Copyright 2014 Seamus Abshere
