require 'rubygems'
require 'rmagick'
require 'thread'

puts "Cropping...."
start_time = Time.now

image = ARGV[0]

m_image = Magick::Image.read(image)[0]
filename =  m_image.filename
width =  m_image.columns
height = m_image.rows
pixels = m_image.export_pixels(0, 0, width, height, "RGB");
WHITE = 65535
top_found = bottom_found = false
image_top = image_bottom = 0

white_rows = []
threads = []

(0...height).each do |row|
  threads << Thread.new(row) { |trow|
    all_white = true

    row_start = (width*3) * trow
    row_end = row_start + (width*3)
    
    (row_start..row_end).each do |i|
      all_white = false if pixels[i].to_i != WHITE
    end
    white_rows << trow if all_white
  }
end
threads.each { |aThread|  aThread.join }

white_rows = white_rows.sort
i = 0
while !top_found && !bottom_found
  #keep going as long as we have consecutive white rows
  if white_rows[i+1] != white_rows[i] + 1
    top_found = true
    image_top = white_rows[i]
    image_bottom = white_rows[i+1]
  end
  i += 1
end

crop_height = image_bottom-image_top

if crop_height > 0
  sub_img_pixels = m_image.dispatch(0, image_top, width, crop_height, "RGB")
  new_img = Magick::Image.constitute(width, crop_height, "RGB", sub_img_pixels)
  new_img.write("thread-cropped-#{filename}")
else
  puts "Sorry, no white to crop"
end

new_img = nil
puts "Done in #{Time.now - start_time}"