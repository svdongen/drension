function [ points ] = ImageToPoints( binary_image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rotated_image = imrotate(binary_image,270);
[x y] = find(rotated_image);
points = [x y];

end

