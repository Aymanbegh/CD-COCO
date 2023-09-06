%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to add motion blur to an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image
% name: name of the new distorted image
% len: Linear motion of camera, specified as a numeric scalar, measured in pixels
% angle: Angle of camera motion in degrees, specified as a numeric scalar.
% outputFolder: directory where are writted the new distorted image

%% Function distortion_motion_blur that performs a distortion representing an approximation of the linear motion of a camera 	

function [distortion, imG_out] = distortion_motion_blur(imgin,name,len,angle,outputFolder)

% Create predefined 2-D filter named blur_motion_filter
blur_motion_filter = fspecial('motion',len,angle);
 

%% Create image to perform the blur motion distortion %%
obj = imgin;
obj(:,:,:)  = imfilter(obj(:,:,:),blur_motion_filter,'replicate');   % Add motion blur

imG = double(obj(:,:,:));
imG_out(:,:,:) = (imG - min(imG(:))) ./ max(imG(:));

outputname = sprintf('%s',name);
% 
% outputdir = [outputFolder outputnames];
imwrite(imG_out, [outputFolder outputname],"Quality",95);
distortion = "Global motion blur";
end