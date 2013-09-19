# DatabaseUrl

Convert back and forth between Heroku-style `ENV['DATABASE_URL']` and Rails/ActiveRecord-style `config/database.yml` config hashes.

## Usage

### Get `DATABASE_URL` from config hash

You pass it a hash (string or symbol keys, doesn't matter) and it gives you a URL:

    >> c = YAML.load_file('/path/to/config/database.yml')
    => {"development"=>{"adapter"=>"mysql2", "database"=>"myapp_development", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}, "test"=>{"adapter"=>"mysql2", "database"=>"myapp_test", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}, "production"=>{"adapter"=>"mysql2", "database"=>"myapp", "username"=>"myapp", "password"=>"XXX", "encoding"=>"utf8"}, "cucumber"=>{"adapter"=>"mysql2", "database"=>"myapp_cucumber", "username"=>"root", "password"=>"password", "encoding"=>"utf8"}}
    >> DatabaseUrl.database_url c['development']
    => "mysql2://root:password@127.0.0.1/myapp_development?encoding=utf8"

### Get config hash from `DATABASE_URL`

Let's assume `DATABASE_URL` is set to `postgres://uuu:xxx@127.0.0.1:1234/abc`...

    >> DatabaseUrl.active_record_config
    => {:adapter=>"postgres", :host=>"127.0.0.1", :port=>1234, :database=>"abc", :user=>"uuu", :password=>"xxx"}

You can also pass a URL as the first argument to `DatabaseUrl.active_record_config`.

## Query parameters supported

* `encoding`
* `pool`

## Copyright

Copyright 2013 Seamus Abshere
