%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to add uneven illumination to an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image.
% name_in: name of the new distorted image.
% area_factor: Radius of the unaffected area of ​​the image, specified as a numeric scalar.
% attenuation: Attenuation factor of the uneven illumination.
% outputFolder: directory where are writted the new distorted image.

%% Function distortion_illumination that performs a local drop in brightness  	

function imG_out = distortion_rain(imgin,name_in,imrain,alpha,outputFolder, outputHead)

if ~exist(fullfile(outputFolder,outputHead), 'dir')
  mkdir(outputFolder,outputHead)
end
output= [outputFolder '/' outputHead];
outputFolder = [output,'/'];

outputnames = sprintf('/%f',alpha);
if ~exist(fullfile(outputFolder,outputnames), 'dir')
  mkdir(outputFolder,outputnames)
end
output= [outputFolder outputnames];
outputFolder = [output,'/'];

%%% NON-UNIFROM ILLUMINATION %%%
%% Create image for use as mask for creating non-uniform illumination %%

% Specified the Width and Height of the original image
% p: attenuation mask 
% d: distance from the center point
width = size(imgin,2);
height = size(imgin,1);
imrain1 = imresize(imrain,[height width]);

I = 1 - (1 - im2double(imgin)).*(1 - alpha*im2double(imrain1));
imG_out= im2uint8(I);


outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname]);

end