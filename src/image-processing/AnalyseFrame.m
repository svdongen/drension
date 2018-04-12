function [ B0, R0, Vd, error ] = AnalyseFrame( image, needleWidth, dropletLocation, numberOfSegments, edgesTolerance )
%ANALYSEFRAME Summary of this function goes here
%   Detailed explanation goes here

% Load picture
I = image; %imread(image);
I = imrotate(I, 90);
gray_image = rgb2gray(I);

% TODO: cropping of the image

% Transforming the image to find edges
edges_prewitt = edge(gray_image,'Prewitt',edgesTolerance,'both','nothinning');

% PICTURE
% figure('Name','Loaded Image');
% subplot(1,2,1);
% imshow(I);
% subplot(1,2,2);
% figure('Name','Edged Image');
% imshow(edges_prewitt);
% linkaxes;

myResult = ImageToPoints(edges_prewitt);

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

droplet = dropletLocation; % Found manually!

% Cropping the image
imageToBeCropped = edges_prewitt;
dimensions = size(imageToBeCropped);
ranges = [ (floor(droplet(2) - 1.75*droplet(1))) (dimensions(1) - floor(droplet(3) + 1.75*droplet(1))) (ceil(3.5*droplet(1))) (ceil(3.5*droplet(1))) ];
croppedImage = imcrop(imageToBeCropped, ranges);

% PICTURE
% figure('Name','Cropped Image');
% imshow(croppedImage);

% Determining the angle and needle width
[ theta, a, b1, b2, d, zMax ] = NeedleAnalysis( croppedImage, numberOfSegments );
rotatedImage = imrotate(croppedImage, -1*theta);

% PICTURE
figure('Name','Rotated Image');
imshow(rotatedImage);
% msg = 'Error occurred.';
% error(msg)

[ thetaR, aR, b1R, b2R, dR, zMaxR ] = NeedleAnalysis( rotatedImage, numberOfSegments );


% Extracting points from the droplet that are suitable to be fitted against
% the YL-equation
points = ImageToPoints(rotatedImage);
[ dropLeft, dropBottom, dropRight ] = FindDropletEdges(points, 25, numberOfSegments);

% x0 = (b1R+b2R)/2;
x0 = (dropLeft + dropRight)/2;
xmin = floor(x0*(1-0.001));
xmax = ceil(x0*(1+0.001));
min_y = dropBottom; %min(points(:,2));

points(:,1) = points(:,1) - x0;
points(:,2) = points(:,2) - min_y;
max_y = ceil((2/3)*(zMaxR - min_y));
cutOffPoints = points(( points(:,2) <= max_y ),:);
points = points(( points(:,2) <= (zMaxR - min_y)),:);

resizingFactor = 2/(abs(dropLeft - dropRight));

cutOffPoints(:,1) = cutOffPoints(:,1)*resizingFactor;
cutOffPoints(:,2) = cutOffPoints(:,2)*resizingFactor;

points(:,1) = points(:,1)*resizingFactor;
points(:,2) = points(:,2)*resizingFactor;

% PICTURE
figure('Name','Centered points');
hold on;
scatter(points(:,1),points(:,2),10,[0.5 0.5 0.5]);
scatter(cutOffPoints(:,1),cutOffPoints(:,2),10,[0 0 1]);

% Fitting and Plotting
iterations = 2;
BMin = 0.01;
BMax = 0.5;
BAccuracy = 0.01;

BSave = [];
ErrorsSave = [];
for step = 1:iterations
    [BRange, errors] = YLFitter( cutOffPoints, BMin, BMax, BAccuracy );
    MinError = min(errors);
    OptimalB = BRange(errors == MinError);
    BSave = [BSave BRange];
    ErrorsSave = [ErrorsSave errors]; 
    BMin = OptimalB - 2*BAccuracy;
    if BMin < 0
        BMin = BAccuracy;
    end
    BMax = OptimalB + 2*BAccuracy;
    if BMax < 0
        BMax = BAccuracy;
    end
    BAccuracy = BAccuracy/10;
end

error = MinError;
B0 = OptimalB;
[M, dropletFactor, Vd] = MakeDroplet(OptimalB);
needleConversionFactor = needleWidth/d; % [m/pixel]
Vd = Vd * (needleConversionFactor / resizingFactor)^3;
R0 = needleConversionFactor * dropletFactor/resizingFactor;

% PICTURE
plot(M(:,2),M(:,3),'--y',...
'LineWidth',2);
title(['Bo = ' num2str(OptimalB)])
daspect([1 1 1])
% 
% figure('Name','Optimization Results');
% EI = [BSave.' ErrorsSave.'];
% EI = sortrows(EI);
% plot(EI(:,1),EI(:,2),'-b',...
% 'LineWidth',2);
% xlabel('Bo')
% ylabel('Error')


end

