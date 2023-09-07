%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply contrast changing to an image source
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function parameters:
% D: Original image.
% name: name of the new distorted image.
% contrast: contrast factor that adjusts image intensity values.
% outputFolder: directory where are writted the new distorted image.
function [distortion, imG_out] = Global_contraste(Name, D,contrast,outputFolder)
    addpath('./Distortions functions');  
    Image_end=".jpg";
    name_in = Name+Image_end;
    
    if(size(D,3)==3)
        G = rgb2gray(D);
    else 
        G=D; 
    end
    
    Mean_img = mean(mean(double(G)));

    if(Mean_img<80)
        choice = randi([1,2],1);
        if(choice ==1)
            means = 0;
            variance = randi([1 20],1)*0.001;            
            [distortion, imG_out] = distortion_noise(D,name_in,means,variance,outputFolder); 
        else
            compression = randi([10 50],1);
            [distortion, imG_out] = distortion_compression(D,name_in,compression,outputFolder);
        end
        
    else
        [distortion, imG_out] = distortion_contrast(D,name_in,contrast,outputFolder);
    end
 
    
end








