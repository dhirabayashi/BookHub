Encoding.default_external = 'utf-8'
require File.dirname( __FILE__ ) + '/app'
set :environment, :production

run Sinatra::Application