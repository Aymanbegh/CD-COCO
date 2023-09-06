%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to compress an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image.
% name_in: name of the new distorted image.
% compression: compression value that indicates the compression rate (between 1 and 100).
% outputFolder: directory where are writted the new distorted image.

%% Function distortion_compression that performs an image compression  	

function [distortion, imgin] = distortion_compression(imgin,name_in,compression,outputFolder)

% outputFolder = [outputFolder,'/'];
%% Compression
outputname = sprintf('%s',name_in);
imwrite(imgin, [outputFolder outputname],'jpg','Quality',compression);
distortion = "compression";

end