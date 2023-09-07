%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply local backlight to an image source
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% D: Original image.
% name: name of the new distorted image.
% data: groundtruth annotations (label, mask, bounding boxe).
% contrast: contrast factor that adjusts image intensity values.
% outputFolder: directory where are writted the new distorted image.

function [distortion, imG_out] = Local_Backlight(Name,D,data,contrast,outputFolder)

%Image name
Image_end=".jpg";
name_in = Name+ Image_end;

% Adjust contrast
imG_C =imadjust(D,contrast,[]);
imG_out = D;

% Apply changing contrast on objects
for k=1:size(data.label,1)
    for i=1:size(D,1)
        for j=1:size(D,2)
            if(data.masks(i,j,k)==1)
                imG_out(i,j,:)=imG_C(i,j,:);
            end
        end
    end
end

%writing image
outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname],"Quality",95);
distortion = "Local Backlight";
end