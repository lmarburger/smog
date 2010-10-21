require 'main'

Main do
  version Smog::VERSION

  argument 'url' do
    description 'url to query'
  end

  keyword 'auth' do
    required
    description 'digest auth credentials'
  end

  def run
    2.times do
      command = build_curl

      @last_response = %x(#{ command })
      puts_response command, @last_response
    end
  end

  private

    # Basic curl command:
    # curl
    #   --digest -u "test@example.com:pass"
    #   -H "Accept: application/json"
    #   -H "If-None-Match: \"05122c59185e3bcf8b9a1976d46c2040\""
    #   -H "If-Modified-Since: Tue, 05 Oct 2010 13:44:39 GMT"
    #   "http://my.cloudapp.local/items?page=1&per_page=5"
    def build_curl
      [ 'curl -I -s',
        "--digest -u #{ params[:auth].value }",
        header('Accept', 'application/json')
      ].tap do |command|
        if etag
          command << header('If-None-Match', %{\\"#{ etag }\\"})
        end

        if last_modified
          command << header('If-Modified-Since', last_modified)
        end

        command << params[:url].value.inspect
      end.join ' '
    end

    def header(name, value)
      %{-H "#{ name }: #{ value }"}
    end

    def etag
      response_header /ETag: "(.*)"/
    end

    def last_modified
      response_header /Last-Modified: (.*)/
    end

    def response_header(match_header)
      return unless @last_response

      @last_response.match(match_header)[1].chomp
    end

    def puts_response(command, full_response)
      puts command

      full_response.split("\r\n\r\n").each do |response|
        status = response.split("\r\n").first
        puts "    #{ status }"
      end

      puts
    end

end
