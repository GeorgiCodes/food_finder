APP_ROOT = File.dirname(__FILE__)

$:.unshift(File.join(APP_ROOT, 'lib'))
require 'guide'

if __FILE__ == $0
  guide = Guide.new('restaurants.txt')
  guide.launch!
end