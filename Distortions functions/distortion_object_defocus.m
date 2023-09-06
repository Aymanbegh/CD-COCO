%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to add local defocus to an image source
%% Copyright (c) 2021, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: September 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% imgin: Original image.
% name_in: name of the new distorted image.
% mask: mask annotation of object from MS-COCO dataset
% gaussian_size: Size of the Gaussian filter, specified as a scalar or 2-element vector of positive, odd integers.
% gaussian_sigma: Standard deviation of the Gaussian distribution, specified as a positive number or a 2-element vector of positive numbers. 
% outputFolder: directory where are writted the new distorted image.

%% Function distortion_object_defocus that performs a local defocus blur on annoted objects  	

function imG_out = distortion_object_defocus(imgin,name_in,mask,gaussian_size,gaussian_sigma,outputFolder)

outputFolder = [outputFolder,'/'];
%%% LOCAL DEFOCUS APPLICATION %%%
%% Create image for use as mask for creating a local defocus blur %%
obj = imgin;
% Specified the Width and Height of the original image
% p: output image containing input image mixed with object blured
% p1: input image blured
WIDTH = size(obj,1);
HEIGHT = size(obj,2);
CHANEL=size(obj,3);
p = zeros(WIDTH,HEIGHT,CHANEL);
p1 = zeros(WIDTH,HEIGHT,CHANEL);
size_mask=size(mask,3);
% imG = uint8(obj(:,:,:));
p1(:,:,:) = imgaussfilt(obj(:,:,:),gaussian_sigma,'FilterSize',gaussian_size);
for k=1:size_mask
    for i=1:WIDTH
        for j=1:HEIGHT
            if mask(i,j,k)~=1
                if(k==1)
                    p(i,j,:) = obj(i,j,:);
                end
                    
            else
                p(i,j,:) = p1(i,j,:);
            end
            
        end
    end
    p(i,j,:)=p1(i,j,:);
end

imG_out = uint8(p);

outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname]);

end