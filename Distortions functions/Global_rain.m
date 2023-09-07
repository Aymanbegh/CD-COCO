%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply rain phenomena to an image source
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
% Rain: fog mask image.
% data : groundtruth annotations (label, mask, bounding boxe)
% alpha : mask application factor
% outputFolder: directory where are writted the new distorted image.
function [distortion, imG_back] = Global_rain(Name,D,I,Rain,data,alpha,outputFolder)
addpath('./Distortions functions');
addpath('./Defocus local functions');

%Image name
Image_end=".jpg";
name_in = Name + Image_end;

normal_s=zeros(size(I,1),size(I,2));
front_s=zeros(size(I,1),size(I,2));
middle_s=zeros(size(I,1),size(I,2));
back_s=zeros(size(I,1),size(I,2));

%% Depth image
% RGB depth image conversion into grayscale image
depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));    
maxi=max(max(depth));    
depth1=(depth./maxi).*255;

Depths=uint8(depth1);

% Compute and sort objects depth
[object_depth, object_min, object_max] = Compute_depth_defocus(data,Depths);
[E,index] = sortrows(object_depth,'descend');  

% Compute thresholds
%     threshold = object_min(index(1));
threshold = E(1);
th_f = 1 - (1./(1+exp(-(15*(0.4-0.5)))));
th_m = 1 - (1./(1+exp(-(15*(0.5-0.5)))));
th_b = 1 - (1./(1+exp(-(15*(0.6-0.5)))));

for i=1:size(I,1)
    for j=1:size(I,2)
        if(Depths(i,j)>threshold)
            normal_s(i,j)=255;
        end
        if(Depths(i,j)<=threshold && Depths(i,j)>threshold *th_f)
            front_s(i,j)=255;
        end
        if(Depths(i,j)<=threshold *th_f && Depths(i,j)>threshold *th_b)
            middle_s(i,j)=255;
        end
        if(Depths(i,j)<=threshold *th_b)
            back_s(i,j)=255;
        end
    end
end    

labels=zeros(size(data.bbox,1),1);
for i=1:size(I,1)
    for j=1:size(I,2)
        if(front_s(i,j)==255)
            for k=1:size(data.bbox,1)
                if(data.masks(i,j,k)==1)
                    labels(k)=1;
                end
            end
        end
        if(middle_s(i,j)==255)
            for k=1:size(data.bbox,1)
                if(data.masks(i,j,k)==1)
                    labels(k)=2;
                end
            end
        end
        if(back_s(i,j)==255)
            for k=1:size(data.bbox,1)
                if(data.masks(i,j,k)==1)
                    labels(k)=3;
                end
            end
        end
    end
end


%% Rain image

%Extract rain components in different masks
se = strel('line',6,5);
erodedBW = imerode(Rain,se);

BW2 = imdilate(erodedBW,se);
Mid_Rain=Rain-BW2;

se1 = strel('line',4,3);
se2 = strel('line',2,1);

erodedBW1 = imerode(Mid_Rain,se1);
BW3 = imdilate(erodedBW1,se1);

GG=Mid_Rain-BW3;
G1 = imdilate(GG,se2);
IF= BW2 + BW3 +GG;
% IF= BW2 + BW3 +Drizzle;


% Create objects masks according to rain masks
front=zeros(size(I,1),size(I,2));
middle=zeros(size(I,1),size(I,2));
back=zeros(size(I,1),size(I,2));

for i=1:size(labels,1)
    if(labels(i)==1)
        front = data.masks(:,:,i) +front;
    end
    if(labels(i)==2)
        middle = data.masks(:,:,i) +middle;
    end
    if(labels(i)==3)
        back = data.masks(:,:,i) +back;
    end

end


% alpha = 5.5;

%% Apply the rain masks according to alpha value
width = size(D,2);
height = size(D,1);
Ifront = imresize(BW2,[height width]);
Imiddle = imresize(BW3,[height width]);
Iback = imresize(GG,[height width]);
IF1 = imresize(IF,[height width]);
% IF1 = imresize(IF,[height width]);

% Applying on the forground
R = 1 - (1 - im2double(D)).*(1 - alpha*im2double(Ifront));
imG_front= im2uint8(R);

% Applying on the front objects
Imd = 1 - (1 - im2double(imG_front)).*(1 - alpha*im2double(Imiddle));
imG_mid= im2uint8(Imd);
for i=1:size(I,1)
    for j=1:size(I,2)
        if(front(i,j)==1)
            imG_mid(i,j,1)=imG_front(i,j,1);
            if(size(I,3)>1)
                imG_mid(i,j,2)=imG_front(i,j,2);            
                imG_mid(i,j,3)=imG_front(i,j,3);
            end

        end
    end
end


% Applying on the front objects
Imb = 1 - (1 - Imd).*(1 - alpha*im2double(Iback));
imG_back= im2uint8(Imb);
for i=1:size(I,1)
    for j=1:size(I,2)
        if((middle(i,j)==1)||(front(i,j)==1))
            imG_back(i,j,1)=imG_mid(i,j,1);
            if(size(I,3)>1)
                imG_back(i,j,2)=imG_mid(i,j,2);
                imG_back(i,j,3)=imG_mid(i,j,3);
            end
        end
    end
end



outputname = sprintf('%s',name_in);
imwrite(imG_back, [outputFolder outputname],"Quality",95);
distortion ="rain";
end