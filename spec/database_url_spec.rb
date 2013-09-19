require 'spec_helper'

describe DatabaseUrl do
  before do
    ENV.delete 'DATABASE_URL'
  end

  it "should build Rails/ActiveRecord-style config hashes using ENV['DATABASE_URL']" do
    ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc?encoding=latin1&pool=9"
    DatabaseUrl.active_record_config.should == {
      adapter: 'postgres',
      host: '127.0.0.1',
      port: 1234,
      database: 'abc',
      user: 'uuu',
      password: 'xxx',
      encoding: 'latin1',
      pool: 9,
    }
  end

  it "should build DATABASE_URL-style URL from Rails/ActiveRecord-style config hash" do
    DatabaseUrl.database_url({
      adapter: 'postgreq',
      host: '127.0.0.2',
      port: 1235,
      database: 'abd',
      user: 'uu1',
      password: 'xx1',
      encoding: 'utf8',
      pool: 15,
    }).should == "postgreq://uu1:xx1@127.0.0.2:1235/abd?encoding=utf8&pool=15"
  end

  it "should build Rails/ActiveRecord-style config hashes given a URL" do
    ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc" # should be ignored!
    DatabaseUrl.active_record_config("postgres://uu2:xxx@127.0.0.3:1236/abc?encoding=latin1").should == {
      adapter: 'postgres',
      host: '127.0.0.3',
      port: 1236,
      database: 'abc',
      user: 'uu2',
      password: 'xxx',
      encoding: 'latin1',
    }
  end
end
