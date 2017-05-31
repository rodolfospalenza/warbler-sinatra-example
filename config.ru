$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'java'
require 'lib/verify.jar'

class App < Sinatra::Base
  java_import 'main.Verify'

  get '/' do
    response.headers["Transfer-Encoding"] = "chunked"
    async = env['java.servlet_request'].start_async

    a = Verify.new

    Thread.new do
      sleep 1#0 # something that takes a long time
      async.response.output_stream.println("<p>Asynchronous thing!</p>")
      async.complete
    end

    a.helloWorld
    # "<p>Synchronous part!</p>"
  end
end

run App
