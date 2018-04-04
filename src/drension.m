% Load Dependencies
[filepath,name] = fileparts(mfilename('fullpath'));
addpath(genpath(filepath));
close all;

% Load picture
I = imread('20180328_165355.jpg');
I = imrotate(I, 90);
gray_image = rgb2gray(I);

% TODO: cropping of the image

% Transforming the image to find edges
edges_prewitt = edge(gray_image,'Prewitt',0.05,'both','nothinning');
figure('Name','Loaded Image');
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(edges_prewitt);
myResult = ImageToPoints(edges_prewitt);
linkaxes;

% Droplet locating parameters (based on cropped image width)
droplet_minimum = 0.05;
droplet_maximum = 0.25;

% Locating the droplet
points = myResult;
% figure
% scatter(points(:,1),points(:,2));
% dimensions = size(edges_prewitt);
% minsize = ceil(dimensions(2)*droplet_minimum);
% maxsize = ceil(dimensions(2)*droplet_maximum);
% dimensions = [dimensions(2) dimensions(1)];
% droplet = LocateDroplet( points, minsize, maxsize, dimensions );

droplet = [350 1650 2500]; % Found manually!

% Cropping the image
imageToBeCropped = edges_prewitt;
dimensions = size(imageToBeCropped);
ranges = [ (floor(droplet(2) - 1.75*droplet(1))) (dimensions(1) - floor(droplet(3) + 1.75*droplet(1))) (ceil(3.5*droplet(1))) (ceil(3.5*droplet(1))) ];
croppedImage = imcrop(imageToBeCropped, ranges);

% Determining the angle and needle width
[ theta, a, b1, b2, d, zMax ] = NeedleAnalysis( croppedImage );
rotatedImage = imrotate(croppedImage, -1*theta);
figure('Name','Cropped and Rotated Image');
imshow(rotatedImage);
[ thetaR, aR, b1R, b2R, dR, zMaxR ] = NeedleAnalysis( rotatedImage );

% Extracting points from the droplet that are suitable to be fitted against
% the YL-equation
points = ImageToPoints(rotatedImage);
[ dropLeft, dropBottom, dropRight ] = FindDropletEdges(points, 25);

% x0 = (b1R+b2R)/2;
x0 = (dropLeft + dropRight)/2;
xmin = floor(x0*(1-0.001));
xmax = ceil(x0*(1+0.001));
min_y = dropBottom; %min(points(:,2));

points(:,1) = points(:,1) - x0;
points(:,2) = points(:,2) - min_y;
max_y = ceil((1/2)*(zMaxR - min_y));
points = points(( points(:,2) <= max_y ),:);

resizingFactor = 2/(abs(dropLeft - dropRight));

points(:,1) = points(:,1)*resizingFactor;
points(:,2) = points(:,2)*resizingFactor;

figure('Name','Centered points');
scatter(points(:,1),points(:,2));
hold on;

% Generating initial guess for Laplace

% Making a droplet
B = 0.01;
M = MakeDroplet( B );
%figure('Name','Theoretical Droplet');
% Resizing the droplet
plot(M(:,2),M(:,3))

% Optimizing against Laplace
