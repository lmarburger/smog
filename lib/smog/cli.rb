require 'thor'
require 'smog'

module Smog
  class CLI < Thor
    # Basic curl command:
    # curl
    #   --digest -u "test@example.com:pass"
    #   -H "Accept: application/json"
    #   -H "If-None-Match: \"05122c59185e3bcf8b9a1976d46c2040\""
    #   -H "If-Modified-Since: Tue, 05 Oct 2010 13:44:39 GMT"
    #   "http://my.cloudapp.local/items?page=1&per_page=5"

    desc 'curl', 'Prints the curl command to fetch items'
    method_option :user,          :aliases => '-u'
    method_option :etag,          :aliases => '-e'
    method_option :last_modified, :aliases => '-l'
    def curl
      print build_command(options)
    end

    private

      def build_command(options)
        [ 'curl -I' ].tap do |command|
          command << "--digest -u #{ options[:user] }" if options[:user]

          if options[:etag]
            command << header('If-None-Match', %{\\"#{ options[:etag] }\\"})
          end

          if options[:last_modified]
            command << header('If-Modified-Since', options[:last_modified])
          end

          command << header('Accept', 'application/json')
          command << "#{ url }\n"
        end.join ' '
      end

      def header(name, value)
        %{-H "#{ name }: #{ value }"}
      end

      def url
        '"http://my.cloudapp.local/items?page=1&per_page=5"'
      end

  end
end
