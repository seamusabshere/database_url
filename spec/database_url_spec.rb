require 'spec_helper'

describe DatabaseUrl do
  before do
    ENV.delete 'DATABASE_URL'
  end

  describe 'ActiveRecord' do
    it "builds config hashes using ENV['DATABASE_URL']" do
      ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc?encoding=latin1&pool=9"
      DatabaseUrl.to_active_record_hash.should == {
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

    it "builds URL from config hash" do
      DatabaseUrl.to_active_record_url({
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

    it "builds config hashes given a URL" do
      ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc" # should be ignored!
      DatabaseUrl.to_active_record_hash("postgres://uu2:xxx@127.0.0.3:1236/abc?encoding=latin1").should == {
        adapter: 'postgres',
        host: '127.0.0.3',
        port: 1236,
        database: 'abc',
        user: 'uu2',
        password: 'xxx',
        encoding: 'latin1',
      }
    end

    it "builds config hashes for mysql2 without warnings" do
      ENV['DATABASE_URL'] = "mysql2://user:xxx@127.0.0.1/dbname?encoding=utf8" # should be ignored!
      DatabaseUrl.to_active_record_hash(ENV['DATABASE_URL']).should == {
        adapter: 'mysql2',
        host: '127.0.0.1',
        database: 'dbname',
        username: 'user',
        password: 'xxx',
        encoding: 'utf8',
      }
    end
  end

  describe 'Sequel' do
    it "builds config hashes using ENV['DATABASE_URL']" do
      ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc?encoding=latin1&pool=9"
      DatabaseUrl.to_sequel_hash.should == {
        adapter: 'postgres',
        host: '127.0.0.1',
        port: 1234,
        database: 'abc',
        user: 'uuu',
        password: 'xxx',
        encoding: 'latin1',
        max_connections: 9,
      }
    end

    it "builds URL from config hash" do
      DatabaseUrl.to_sequel_url({
        adapter: 'postgreq',
        host: '127.0.0.2',
        port: 1235,
        database: 'abd',
        user: 'uu1',
        password: 'xx1',
        encoding: 'utf8',
        pool: 15,
      }).should == "postgreq://uu1:xx1@127.0.0.2:1235/abd?encoding=utf8&max_connections=15"
    end

    it "builds config hashes given a URL" do
      ENV['DATABASE_URL'] = "postgres://uuu:xxx@127.0.0.1:1234/abc" # should be ignored!
      DatabaseUrl.to_sequel_hash("postgres://uu2:xxx@127.0.0.3:1236/abc?encoding=latin1").should == {
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
end
