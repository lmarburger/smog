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
      new_command = curl

      @last_response = %x[#{ new_command }]
      puts_response new_command, @last_response
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
    def curl
      [ 'curl -I -s' ].tap do |command|
        command << "--digest -u #{ params[:auth].value }"

        if etag
          command << header('If-None-Match', %{\\"#{ etag }\\"})
        end

        if last_modified
          command << header('If-Modified-Since', last_modified)
        end

        command << header('Accept', 'application/json')
        command << "#{ params[:url].value.inspect }\n"
      end.join ' '
    end

    def header(name, value)
      %{-H "#{ name }: #{ value }"}
    end

    def etag
      return unless @last_response

      etag = @last_response.match(/ETag: "(.*)"/)[1].chomp
    end

    def last_modified
      return unless @last_response

      last_modified = @last_response.match(/Last-Modified: (.*)/)[1].chomp
    end

    def puts_response(curl, full_response)
      puts curl

      full_response.split("\r\n\r\n").each do |response|
        status = response.split("\r\n").first
        puts "    #{ status }"
      end

      puts
    end

end
