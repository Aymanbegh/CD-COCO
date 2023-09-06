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

function imG_out = distortion_object_illumination(imgin,name_in,mask,attenuation,outputFolder, outputHead)

if ~exist(fullfile(outputFolder,outputHead), 'dir')
  mkdir(outputFolder,outputHead)
end
output= [outputFolder '/' outputHead];
outputFolder = [output,'/'];

outputnames = sprintf('/%f',attenuation);
if ~exist(fullfile(outputFolder,outputnames), 'dir')
  mkdir(outputFolder,outputnames)
end
output= [outputFolder outputnames];
outputFolder = [output,'/'];

%%% NON-UNIFROM ILLUMINATION %%%
%% Create image for use as mask for creating non-uniform illumination %%
obj = imgin;
% Specified the Width and Height of the original image
% p: attenuation mask 
% d: distance from the center point
WIDTH = size(obj,1);
HEIGHT = size(obj,2);
p = zeros(WIDTH,HEIGHT,3);
size_mask=size(mask,3);
imG = double(obj(:,:,:));
for k=1:size_mask
    for i=1:WIDTH
        for j=1:HEIGHT
            if mask(i,j,k)~=1
                p(i,j,:) = 1;
            else
                p(i,j,:) = attenuation + randi([1 5],1)*0.01;
            end
            
        end
    end
    imG = imG.* double(p);
end

% imG = double(obj(:,:,:)).* double(p);
if attenuation <1
    imG_out(:,:,:) = (imG - min(imG(:))) ./ max(imG(:));
else
    imG_out(:,:,:) = (abs(min(imG(:)) - imG )) ./ max(imG(:));
end

outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname]);
imshow(imG_out)
end