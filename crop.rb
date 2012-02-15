require 'rubygems'
require 'rmagick'

puts "Cropping...."
start_time = Time.now

image = ARGV[0]

m_image = Magick::Image.read(image)[0]
filename =  m_image.filename
width =  m_image.columns
height = m_image.rows
WHITE = 65535

white_rows = []
top_found = bottom_found = false
image_top = 0
image_bottom = height-1

(0...m_image.rows).each do |row|
  all_white = true
  m_image.export_pixels(0, row, width, 1, "RGB").each do |pixel|
    all_white = false unless pixel == WHITE
  end

  white_rows << row if all_white
end

num_white = white_rows.size
i = 0
while (!top_found || !bottom_found) && i < num_white
  
  #Is the next white row in the list an adjacent row to the current one
  if(!top_found && white_rows[i+1] != white_rows[i] + 1)
    image_top = white_rows[i]
    top_found = true
  end

  #Is the previous white row in the list an adjacent row to the current one
  if(!bottom_found && white_rows[(num_white-1)-i]-1  != white_rows[(num_white-1)-i-1])
    image_bottom = white_rows[num_white-1-i]
    bottom_found = true
  end

  i+=1
end
crop_height = image_bottom-image_top

if crop_height > 0
  sub_img_pixels = m_image.dispatch(0, image_top, width, crop_height, "RGB")
  new_img = Magick::Image.constitute(width, crop_height, "RGB", sub_img_pixels)
  new_img.write("cropped-#{filename}")
else
  puts "Sorry, no white to crop"
end

new_img = nil
puts "Done in #{Time.now - start_time}"
