% Load Dependencies
[filepath,name] = fileparts(mfilename('fullpath'));
addpath(genpath(filepath));
close all;

workingDir = tempname;
mkdir(workingDir);
mkdir(workingDir,'images');

% Input parameters
NW = 1.82/1000; %needle width in [m]

deltaRho = 1000*0.997; % - 1.1839; % rho[water - air] in [kg/m3]
g = 9.81; % acceleration due to gravity in [m/s2]

% Import a movie
dropletVideo = VideoReader('VID_20180420_ovalubmin_2-5gL.mp4');
filename = 'results_VID_20180420_ovalubmin_2-5gL.mat';
disp('Video has been imported...');
dropletLocation = [100 600 900];
numberOfSegments = 20;
edgesTolerance = 0.16;
frameRate = 1; % dropletVideo.frameRate;

ii = 1;

% Define Time Range
timeRange = [0 2750]; % in seconds
timeSkip = 0.9; % in sesconds
frameSkip = floor(timeSkip * frameRate);
frameRange = (timeRange * frameRate) + 1;
numberOfFrames = ceil(dropletVideo.frameRate * dropletVideo.duration);

% Analysis
results = zeros(numberOfFrames,8); % Frame, Time, B0, R0, Vd, Error, Gamma, Wo
disp('Results have been initialized...');
lastRead = 0;
lastSaved = 0;

while hasFrame(dropletVideo)
   img = readFrame(dropletVideo);
   if (ii >= frameRange(1)) && (ii <= frameRange(2) && (ii >= lastRead + frameSkip))
   disp('Reading frame...');
   disp(round(1000*ii/numberOfFrames)/10);
   disp('Analyzing this frame...');
   lastRead = ii;
   results(ii,1) = ii;
   results(ii,2) = (ii-1)/frameRate;
   [results(ii,3), results(ii,4), results(ii,5), results(ii,6)] = AnalyseFrame(img, NW, dropletLocation, numberOfSegments, edgesTolerance);
   results(ii,7) = deltaRho * (results(ii,4))^2 * g / (results(ii,3)); % gamma = dRho R0^2 g / B0
   results(ii,8) = (results(ii,3) * results(ii,5)) / (pi * (results(ii,4))^2 * NW); % Wo = Bo * Vd / (R0^2 * NW * pi)
   if ii > (lastSaved + 10)
    save(filename)
    lastSaved = ii;
   end
   end
   ii = ii+1;
end

disp('Analysis of video completed!');

y = 72.1/1000; % gamma of literature in N/m
figure;
scatter(results(:,8),results(:,7))
hline = refline([0 y]);
hline.Color = 'r';

figure;
scatter(results(:,2),results(:,7))

figure;
subplot(3,1,1);
scatter(results(:,2),results(:,5))
box on;
subplot(3,1,2);
scatter(results(:,2),results(:,6))
box on;
subplot(3,1,3);
scatter(results(:,2),results(:,8))
box on;

save(filename)

[f,xi] = ksdensity(subSet(subSet(:,2)<55,7)); 
figure
plot(xi,f);

