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
dropletLocation = [100 550 850];

ii = 1;

% Define Time Range
timeRange = [13 14];
frameRange = timeRange * dropletVideo.frameRate;
numberOfFrames = ceil(dropletVideo.frameRate * dropletVideo.duration);

% Analysis
results = zeros(numberOfFrames,8); % Frame, Time, B0, R0, Vd, Error, Gamma, Wo

while hasFrame(dropletVideo)
   img = readFrame(dropletVideo);
   if (ii >= frameRange(1)) && (ii <= frameRange(2))
   disp(round(1000*ii/numberOfFrames)/10);
   results(ii,1) = ii;
   results(ii,2) = (ii-1)/dropletVideo.frameRate;
   [results(ii,3), results(ii,4), results(ii,5), results(ii,6)] = AnalyseFrame(img, NW, dropletLocation);
   results(ii,7) = deltaRho * (results(ii,4))^2 * g / (results(ii,3)); % gamma = dRho R0^2 g / B0
   results(ii,8) = (results(ii,3) * results(ii,5)) / (pi * (results(ii,4))^2 * NW); % Wo = Bo * Vd / (R0^2 * NW * pi)
   end
   ii = ii+1;
end

