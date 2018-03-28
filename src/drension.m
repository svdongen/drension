I = imread('picture.jpg');
gray_image = rgb2gray(I);

% TODO: cropping of the image

% Finding the droplet edges
edges_prewitt = edge(gray_image,'Prewitt',0.05,'both','nothinning');
h = figure;
subplot('Position', [0.02 0.35 0.3 0.3]);
imshow(I);
subplot('Position', [0.35 0.35 0.3 0.3]);
imshow(edges_prewitt);
subplot('Position', [0.68 0.35 0.3 0.3]);
myResult = ImageToPoints(edges_prewitt);
scatter(myResult(:,1),myResult(:,2))
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
figure;
imageToBeCropped = edges_prewitt;
dimensions = size(imageToBeCropped);
ranges = [ (floor(droplet(2) - 1.75*droplet(1))) (dimensions(1) - floor(droplet(3) + 1.75*droplet(1))) (ceil(3.5*droplet(1))) (ceil(3.5*droplet(1))) ];
croppedImage = imcrop(imageToBeCropped, ranges);


% Determining the angle and needle width
[ theta, a, b1, b2, d, zMax ] = NeedleAnalysis( croppedImage );
rotatedImage = imrotate(croppedImage, -1*theta);
imshow(rotatedImage);
[ thetaR, aR, b1R, b2R, dR, zMaxR ] = NeedleAnalysis( rotatedImage );

% Generating initial guess for Laplace


% making a droplet
B = 0.01;
M = MakeDroplet( B );
plot(M(:,2),M(:,3))

% Optimizing against Laplace
