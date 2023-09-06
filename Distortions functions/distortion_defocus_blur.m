%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to add defocus blur to an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image.
% name: name of the new distorted image.
% gaussian_size: Size of the Gaussian filter, specified as a scalar or 2-element vector of positive, odd integers.
% gaussian_sigma: Standard deviation of the Gaussian distribution, specified as a positive number or a 2-element vector of positive numbers. 
% outputFolder: directory where are writted the new distorted image.

%% Function distortion_defocus_blur that performs a Gaussian lowpass filter that smooths image.  

function [distortion, imG_out] =distortion_defocus_blur(imgin,name,gaussian_size,gaussian_sigma,outputFolder)


%%% DEFOCUS BLUR %%%
%% Performs the blur_defocus_filter 2-D filter to the original image %%
obj = imgin;
obj(:,:,:) = imgaussfilt(obj(:,:,:),gaussian_sigma,'FilterSize',gaussian_size); % Add defocus blur
% obj(:,:,:)  = imfilter(obj(:,:,:),blur_defocus_filter,'replicate');  % Add defocus blur

imG = double(obj(:,:,:));
imG_out(:,:,:) = (imG - min(imG(:))) ./ max(imG(:));

outputname = sprintf('%s',name);
imwrite(imG_out, [outputFolder outputname],"Quality",95);
distortion ="Global defocus blur";

end