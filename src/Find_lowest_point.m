%function [x0 y0] = 
x0 = (b1R+b2R)/2;
xmin = floor(x0*(1-0.001));
xmax = ceil(x0*(1+0.001));

points = ImageToPoints(rotatedImage);
min_y = min(points(:,2));
min_index = find(points(:,2)==min_y);
min_x = ceil(mean(points(min_index,1)));
%min_point(1,1)= min_x;
%min_point(1,2)= min_y;
%min_point

size_points = size(points,1);

points(1:1:size_points,1) = points(1:1:size_points,1) - x0;
points(1:1:size_points,2) = points(1:1:size_points,2) - min_y;

figure;
plot(points(:,1),points(:,2),'o')

ymax = ceil((1/3)*(max(points(:,2)-zMaxR)));