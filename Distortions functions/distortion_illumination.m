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

function imG_out = distortion_illumination(imgin,name_in,area_factor,attenuation,outputFolder, outputHead)

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
minx=round(WIDTH/6);
maxx=round((WIDTH/6)*5);
miny=round(HEIGHT/6);
maxy=round((HEIGHT/6)*5);
posx=randi([minx maxx],1);
posy=randi([miny maxy],1);
p = zeros(WIDTH,HEIGHT,3);
for i=1:WIDTH
    for j=1:HEIGHT
 
        d = sqrt((i-350)^2+(j-350)^2); %%% for sideways illumination change center point as here
        %d = sqrt((i-550)^2+(j-275)^2); %%% for sideways illumination change center point as here
        %d = sqrt((i-550)^2+(j-625)^2); %%% for sideways illumination change center point as here
        if d < HEIGHT/area_factor
            p(i,j,:) = 1;
        elseif d > 2*HEIGHT/area_factor
            p(i,j,:) = attenuation;
        else
            p(i,j,:) = 1-( (1-attenuation)*(d-HEIGHT/area_factor )/(HEIGHT/area_factor )) ;
        end
    end
end


imG = double(obj(:,:,:)).* double(p);
imG_out(:,:,:) = (imG - min(imG(:))) ./ max(imG(:));

outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname]);

end