%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply haze phenomena to an image source
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% D: Original image.
% Name: name of the new distorted image.
% I: Depth image.
% Haze: fog mask image.
% alpha : mask application factor
% outputFolder: directory where are writted the new distorted image.
function [distortion, imG_out] = Global_haze(Name,D,I,Haze,alpha,outputFolder)
addpath('./Distortions functions');

% Image name
Image_end=".jpg";
name_in = Name + Image_end;

% RGB depth image conversion into grayscale image
depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));
maxi=max(max(depth));
depth1=(depth./maxi).*255;

%% Haze image application
width = size(I,2);
height = size(I,1);
Ifront = imresize(Haze,[height width]);

% Convert uint8 image into double matrix
D_=im2double(D);
Ifront_ = im2double(Ifront);

% Compute the value of alpha according to the depth
one=ones(size(D,1),size(D,2));
Depth_factor =one - depth1./255;
alpha_ratio = alpha.*(Depth_factor);

% Compute the distorted image
D = (1 - (1 - D_).*(1 - (alpha_ratio.*Ifront_))).*255;


imG_out= uint8(D);

outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname],"Quality",95);
distortion ="haze";
end