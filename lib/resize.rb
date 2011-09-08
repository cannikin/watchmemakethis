# testing memory usage when resizing an image

require 'image_science'
require 'logger'
require 'tempfile'

def memory_usage
  `ps -o rss= -p #{Process.pid}`.to_i
end

log = Logger.new(STDOUT)

files = [ '/Users/rob/Desktop/sample images/dresser1.jpg', 
          '/Users/rob/Desktop/sample images/dresser2.jpg', 
          '/Users/rob/Desktop/sample images/dresser3.jpg',
          '/Users/rob/Desktop/sample images/dresser4.jpg',
          '/Users/rob/Desktop/sample images/cloudy.png',
          '/Users/rob/Desktop/sample images/maui1.jpg',
          '/Users/rob/Desktop/sample images/maui2.jpg',
          '/Users/rob/Desktop/sample images/maui3.jpg',
          '/Users/rob/Desktop/sample images/maui4.jpg',
          '/Users/rob/Desktop/sample images/maui5.jpg',
          '/Users/rob/Desktop/sample images/maui6.jpg',
          '/Users/rob/Desktop/sample images/maui7.jpg',
          '/Users/rob/Desktop/sample images/maui8.jpg',
          '/Users/rob/Desktop/sample images/maui9.jpg']

log.debug "START #{memory_usage}"

files.each do |f|
  Tempfile.open(['resize','.jpg']) do
    log.debug "  Before resize #{memory_usage}"
    ImageScience.with_image(f) { |i| i.thumbnail(640) { |t| t.save "/Users/rob/Desktop/sample images/#{rand(10000000)}.jpg" }}
    log.debug "  After resize #{memory_usage}"
  end
end

log.debug "END #{memory_usage}"
