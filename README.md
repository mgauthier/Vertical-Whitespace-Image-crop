A ruby script that can crop empty vertical space of an image by using a Sobel Edge detection technique to find an object in the image.

## Usage
ruby crop image-filename.jpg

## Examples
Original             |  Cropped
:-------------------------:|:-------------------------:
![Original](https://raw.githubusercontent.com/mgauthier/Vertical-Whitespace-Image-crop/master/shoe2.jpg)  |  ![Cropped](https://raw.githubusercontent.com/mgauthier/Vertical-Whitespace-Image-crop/master/cropped-shoe2.jpg)
![Original](https://raw.githubusercontent.com/mgauthier/Vertical-Whitespace-Image-crop/master/shoe1.jpg) | ![Cropped](https://raw.githubusercontent.com/mgauthier/Vertical-Whitespace-Image-crop/master/cropped-shoe1.jpg)


Results may vary depending on the image background.  Adjust the variable 'threshold' for more or less aggressive edge detection.
