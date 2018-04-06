% Load Dependencies
[filepath,name] = fileparts(mfilename('fullpath'));
addpath(genpath(filepath));
close all;

workingDir = tempname;
mkdir(workingDir);
mkdir(workingDir,'images');

% Input parameters
NW = 1.8/1000; %needle width in [m]
deltaRho = 1000*0.997 - 1.1839; % rho[water - air] in [kg/m3]
g = 9.81; % acceleration due to gravity in [m/s2]

% Import a movie
dropletVideo = VideoReader('20180329_133019.mp4');
disp('Video has been imported...');
dropletLocation = [100 550 850];
numberOfSegments = 20;
edgesTolerance = 0.125;

ii = 1;

% Define Time Range
timeRange = [7.1 7.5]; % in seconds
timeSkip = 0.1; % in sesconds
frameSkip = floor(timeSkip * dropletVideo.frameRate);
frameRange = timeRange * dropletVideo.frameRate;
numberOfFrames = ceil(dropletVideo.frameRate * dropletVideo.duration);

% Analysis
results = zeros(numberOfFrames,8); % Frame, Time, B0, R0, Vd, Error, Gamma, Wo
disp('Results have been initialized...');
lastRead = 0;

while hasFrame(dropletVideo)
   disp('Reading next frame...');
   disp(round(1000*ii/numberOfFrames)/10);
   img = readFrame(dropletVideo);
   if (ii >= frameRange(1)) && (ii <= frameRange(2) && (ii >= lastRead + frameSkip))
   disp('Analyzing this frame...');
   lastRead = ii;
   results(ii,1) = ii;
   results(ii,2) = (ii-1)/dropletVideo.frameRate;
   [results(ii,3), results(ii,4), results(ii,5), results(ii,6)] = AnalyseFrame(img, NW, dropletLocation, numberOfSegments, edgesTolerance);
   results(ii,7) = deltaRho * (results(ii,4))^2 * g / (results(ii,3)); % gamma = dRho R0^2 g / B0
   results(ii,8) = (results(ii,3) * results(ii,5)) / (pi * (results(ii,4))^2 * NW); % Wo = Bo * Vd / (R0^2 * NW * pi)
   end
   ii = ii+1;
end

disp('Analysis of video completed!');
