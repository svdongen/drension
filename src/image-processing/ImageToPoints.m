function [ points ] = ImageToPoints( binary_image )
%ImageToPoints converts an image to a set of points [x y]
%   binary_image is an image matrix consisting of [1 0] elements.

rotated_image = imrotate(binary_image,270);
[x y] = find(rotated_image);
points = [x y];

end

