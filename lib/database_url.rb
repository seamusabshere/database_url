require "database_url/version"

require 'uri'
require 'cgi'

module DatabaseUrl
  class << self
    def to_active_record_hash(url = nil)
      result_hash = to_hash ACTIVE_RECORD_FIELD_MAP, url

      if result_hash[:adapter] == 'mysql2'
        result_hash[:username] = result_hash.delete(:user)
      end

      result_hash
    end

    def to_active_record_url(hash)
      to_url ACTIVE_RECORD_FIELD_MAP, hash
    end

    def to_sequel_hash(url = nil)
      to_hash SEQUEL_FIELD_MAP, url
    end

    def to_sequel_url(hash)
      to_url SEQUEL_FIELD_MAP, hash
    end

    private

    def to_hash(field_map, url = nil)
      if url.nil?
        url = ENV.fetch 'DATABASE_URL'
      end
      uri = URI.parse url
      memo = {
        adapter: uri.scheme,
        host: uri.host,
        database: File.basename(uri.path),
      }
      if uri.port
        memo[:port] = uri.port
      end
      if uri.user
        memo[:user] = uri.user
      end
      if uri.password
        memo[:password] = uri.password
      end
      query = CGI.parse uri.query.to_s
      if query.has_key?('encoding')
        memo[:encoding] = query['encoding'][0]
      end
      if (pool = query['pool'] || query['max_connections']) and pool.length > 0 # CGI.parse creates a Hash that defaults to []
        memo[field_map.fetch('pool').to_sym] = pool[0].to_i
      end
      memo
    end

    def to_url(field_map, hash)
      # stringify keys
      c = hash.inject({}) { |memo, (k, v)| memo[k.to_s] = v; memo }
      userinfo = if c.has_key?('user') or c.has_key?('username') or c.has_key?('password')
        username = c.values_at('user', 'username').compact.first
        [ username, c['password'] ].join ':'
      end
      query = {}
      if c.has_key?('encoding')
        query['encoding'] = c['encoding']
      end
      if pool = c['pool'] || c['max_connections']
        query[field_map.fetch('pool')] = pool.to_i
      end
      query = if query.length > 0
        URI.encode_www_form query
      end

      # URI.new(scheme, userinfo, host, port, registry, path, opaque, query, fragment, parser = DEFAULT_PARSER, arg_check = false)
      uri = URI::Generic.new(
        c.fetch('adapter'),
        userinfo,
        c.fetch('host', DEFAULT_HOST),
        c['port'],
        nil, # registry
        "/#{c.fetch('database')}", # path
        nil, # opaque
        query, # query
        nil, # fragment
      )
      uri.to_s
    end
  end

  DEFAULT_HOST = '127.0.0.1'

  SEQUEL_FIELD_MAP = {
    'pool' => 'max_connections',
  }
  ACTIVE_RECORD_FIELD_MAP = {
    'pool' => 'pool',
  }
end
