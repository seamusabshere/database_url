require "database_url/version"

require 'uri'
require 'cgi'

module DatabaseUrl
  class << self
    def active_record_config(url = nil)
      if url.nil?
        url = ENV.fetch 'DATABASE_URL'
      end
      uri = URI.parse url
      retval = {
        adapter: uri.scheme,
        host: uri.host,
        database: File.basename(uri.path),
      }
      if uri.port
        retval[:port] = uri.port
      end
      if uri.user
        retval[:user] = uri.user
      end
      if uri.password
        retval[:password] = uri.password
      end
      query = CGI.parse uri.query
      if query.has_key?('encoding')
        retval[:encoding] = query['encoding'][0]
      end
      if query.has_key?('pool')
        retval[:pool] = query['pool'][0].to_i
      end
      retval
    end

    def database_url(active_record_config)
      # stringify keys
      c = active_record_config.inject({}) { |memo, (k, v)| memo[k.to_s] = v; memo }
      userinfo = if c.has_key?('user') or c.has_key?('username') or c.has_key?('password')
        username = c.values_at('user', 'username').compact.first
        [ username, c['password'] ].join ':'
      end
      query = {}
      if c.has_key?('encoding')
        query['encoding'] = c['encoding']
      end
      if c.has_key?('pool')
        query['pool'] = c['pool'].to_i
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
end
