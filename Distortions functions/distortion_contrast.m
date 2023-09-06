%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to increaste the contrast of an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image.
% name_in: name of the new distorted image.
% contraste: contrast factor that adjusts image intensity values.
% outputFolder: directory where are writted the new distorted image.

%% Function distortion_contrast that performs a global adjustment of the image intensity values. 	

function [distortion, imG_out] = distortion_contrast(imgin,name_in,contraste,outputFolder)

% outputFolder = [outputFolder,'/'];
imG_out =imadjust(imgin,contraste,[]);

%% Contrast
outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname],"Quality",95);
distortion="contrast";

end