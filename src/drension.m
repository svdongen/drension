% Load Dependencies
[filepath,name] = fileparts(mfilename('fullpath'));
addpath(genpath(filepath));
close all;

% Load picture
I = imread('picture.jpg');
gray_image = rgb2gray(I);

% TODO: cropping of the image

% Transforming the image to find edges
figure('Name','Loaded Image');
subplot(2,1,1);
imshow(I);
subplot(2,1,2);
imshow(edges_prewitt);
myResult = ImageToPoints(edges_prewitt);
linkaxes;

% Droplet locating parameters (based on cropped image width)
droplet_minimum = 0.05;
droplet_maximum = 0.25;

% Locating the droplet
points = myResult;
dimensions = size(edges_prewitt);
minsize = ceil(max(dimensions)*droplet_minimum);
maxsize = ceil(max(dimensions)*droplet_maximum);
dimensions = [dimensions(2) dimensions(1)];
droplet = LocateDroplet( points, minsize, maxsize, dimensions );

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

% Generating initial guess for Laplace


% Making a droplet
B = 0.01;
M = MakeDroplet( B );
figure('Name','Theoretical Droplet');
plot(M(:,2),M(:,3))

% Optimizing against Laplace
