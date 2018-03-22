I = imread('realdroplet.jpg');
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
droplet_maximum = 0.2;

% Locating the droplet
points = myResult;
dimensions = size(edges_prewitt);
minsize = ceil(min(dimensions)*droplet_minimum);
maxsize = ceil(min(dimensions)*droplet_maximum);
dimensions = [dimensions(2) dimensions(1)];
droplet = LocateDroplet( points, minsize, maxsize, dimensions );