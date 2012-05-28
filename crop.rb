require 'rubygems'
require 'rmagick'

puts "Cropping...."

threshold = 70000000
pixel_size = 3

start_time = Time.now

image = ARGV[0]

m_image = Magick::Image.read(image)[0]
filename =  m_image.filename
width =  m_image.columns
height = m_image.rows

#process top to bottom
row = 0
croppable = true
while row < m_image.rows && croppable
  row_pixels = m_image.export_pixels(0, row, width, 1, "RGB")

  col = pixel_size
  while col < row_pixels.size-(2*pixel_size) && croppable

    #left side of pixel
    r1 = row_pixels[col-3] << 16 #8 bit color channels
    g1 = row_pixels[col-2] << 8
    b1 = row_pixels[col-1]
    px1 = r1 | g1 | b1

    #right side of pixel
    r2 = row_pixels[col+4] << 16
    g2 = row_pixels[col+5] << 8
    b2 = row_pixels[col+6]
    px2 = r2 | g2 | b2

    diff = (px1 - px2).abs

    if diff > threshold
      croppable = false
    else
      col += pixel_size
    end
  end

  row += 1 if croppable
end
image_top = [0,row].max

#process bottom to top
row = height-1
croppable = true
while row >= image_top && croppable
  row_pixels = m_image.export_pixels(0, row, width, 1, "RGB")

  col = pixel_size
  while col < row_pixels.size-(2*pixel_size) && croppable

    r1 = row_pixels[col-3] << 16
    g1 = row_pixels[col-2] << 8
    b1 = row_pixels[col-1]
    px1 = r1 | g1 | b1

    r2 = row_pixels[col+4] << 16
    g2 = row_pixels[col+5] << 8
    b2 = row_pixels[col+6]
    px2 = r2 | g2 | b2

    diff = (px1 - px2).abs

    if diff > threshold
      croppable = false
    else
      col += pixel_size
    end
  end

  row -= 1 if croppable
end
image_bottom = [row,height-1].min

crop_height = image_bottom-image_top

if crop_height > 0
  sub_img_pixels = m_image.dispatch(0, image_top, width, crop_height, "RGB")
  new_img = Magick::Image.constitute(width, crop_height, "RGB", sub_img_pixels)
  new_img.format = 'jpg'
  new_img.write("cropped-#{filename}")
end

new_img = nil
