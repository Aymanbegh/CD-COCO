%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main function to use distortion functions
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function main_distortion:
% Call the different functions to generate distortions on the train set of
% the MS-COCO 2017 dataset
% 
clear all;
clc;
addpath('./Distortions functions');
addpath('./Defocus local functions');
addpath('./Motion local functions');


%% Path declarations for COCO dataset
% Dataset image for the training
imgtrain_path='C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\val2017';
%Add path
addpath(imgtrain_path);

%% Path declaration for the output distortion directory
% Dataset of the distorted image for the training
outputFolder='C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\val2017_distorted/';
% Add path
addpath(outputFolder);

%% Create the distortion directories
% Specified the path to your annotations files from train, val, or test
% folders
path_annotation =('C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\annotations_unpacked_valfull2017\matFiles');
addpath(path_annotation);

%% Specific directories for haze and rain sources
hazeFolder=('C:\Users\aymanaymar.beghdadi\Desktop\Distortions\video extraction\fog1/');
addpath(hazeFolder);
rainFolder=('C:\Users\aymanaymar.beghdadi\Desktop\Distortions\video extraction\rain6/');
addpath(rainFolder);

%% Scene annoatations
load("scene_annotation_val.mat","Scene");
load("weather_val1.mat","Rain","Haze");

%% Image names
fullFileName = fullfile(pwd, 'ImageList_val.txt');
Image_name_list = readtable(fullFileName);

%% Additional path
Depth_location="C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\Depth_validation/";
Depth_end="-dpt_beit_large_512.png";
% Depth_end="-dpt_swin2_base_384.png";
Image_location="C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\val2017/";
Image_end=".jpg";

%% Define all parameters for the various distortion functions (excepted name
    % ,imgin and outputFolder)

contrast = [0.3 0.7;0.2 0.8;0.2 1.0;0.3 0.8;0.2 0.9; 0.3 0.9;...
        0.3 1.0;0.35 0.9;0.35 1.0;0.4 0.9];

Global_distortion_choice = Select_global_distortion(Scene);
save("Global_choice_val_test.mat","Global_distortion_choice");
% load("Global_choice.mat","Global_distortion_choice");

% Global_distortion_choice = Select_global_distortion(Scene,Global_distortion_choice);
% save("Global_choice.mat","Global_distortion_choice");
% Global_distortion_choice()
%% Loop distortion performing
% breaks down annotation extraction into 6 steps to not overload MATLAB capabilities
% for id=1:size(Scene,1)
tic
for id=3097:length(Scene)
    % Get the image name
    Image_name = char(table2cell(Image_name_list(id,:)));
    Name = Image_name(1:end-4);
    % Get the scene annotation
    Scene_annotation = Scene(id);
    % Path to the .mat data file
    Data_ = [path_annotation '/' Name '.mat'];

    Idepth = Depth_location+Name+Depth_end;
    Dimg=Image_location+Name+Image_end;
    distortion = "none";
    
%     Ex=exist(Idepth,);
%     Ex=isfile(Idepth);
    if (isfile(Data_))

        if((Rain(id,1)==0) && (Haze(id,1)==0) && (Scene_annotation.weather==1))
            Scene_annotation.global=1;
        end
        if((Scene_annotation.global==0) && (Scene_annotation.motion==0) && (Scene_annotation.weather==0) && (Scene_annotation.defocus==0) && (Scene_annotation.perturbation==0) && (Scene_annotation.back==0))
            Scene_annotation.global=1;
        end

        if((Rain(id,1)==0) && (Haze(id,1)==0) && (Scene_annotation.weather==1))
            Scene_annotation.global=1;
        end
        
        D=imread(Dimg);                
        if(Scene_annotation.global==1)
            if(Scene_annotation.motion==1 || Scene_annotation.defocus==1)
                choice = randi([3,5],1);
                
                % Check if noise distortion is selected and if so apply it
                if(choice==3)
                    means = 0;
                    variance = randi([1 20],1)*0.001;
                    [distortion, D] = distortion_noise(D,Image_name,means,variance,outputFolder); 
                end
        
                % Check if compression distortion is selected and if so apply it
                if(choice==4)
                    compression = randi([10 50],1);
                    [distortion, D] = distortion_compression(D,Image_name,compression,outputFolder);
%                     distortion=distortion;
                end
        
                % Check if contrast distortion is selected and if so apply it
                if(choice==5)
                    cn = randi([1 10],1);
                    [distortion, D] = Global_contraste(Image_name, D,contrast(cn,:),outputFolder);
                end
            else
                % Check if global motion distortion is selected and if so apply it
                if(Global_distortion_choice(id,1)==1)
                    angle = randi([1 360],1);
                    len = randi([1 15],1);
                    [distortion, D] = distortion_motion_blur(D,Image_name,len,angle,outputFolder);
                end
    
                % Check if global defocus distortion is selected and if so apply it
                if(Global_distortion_choice(id,1)==2)
                    gaussian_size = 9;
                    gaussian_sigma = randi([1 20],1)*0.1;
                    [distortion, D] = distortion_defocus_blur(D,Image_name,gaussian_size,gaussian_sigma,outputFolder);
                end
    
                % Check if noise distortion is selected and if so apply it
                if(Global_distortion_choice(id,1)==3)
                    means = 0;
                    variance = randi([1 20],1)*0.001;
                    [distortion, D] = distortion_noise(D,Image_name,means,variance,outputFolder); 
                end
    
                % Check if compression distortion is selected and if so apply it
                if(Global_distortion_choice(id,1)==4)
                    compression = randi([10 50],1);
                    [distortion, D] = distortion_compression(D,Image_name,compression,outputFolder);
                end
    
                % Check if contrast distortion is selected and if so apply it
                if(Global_distortion_choice(id,1)==5)
                    cn = randi([1 10],1);
                    [distortion, D] = Global_contraste(Name, D,contrast(cn,:),outputFolder);           
                end
            end

        else
            if(Scene_annotation.perturbation==1)
                outputname = sprintf('%s',Image_name);
                imwrite(D, [outputFolder outputname],'Quality',95);
                distortion= "none";
            end
            if(Scene_annotation.back==1)
                data=load(Data_);
                cn=randi([1,10],1);
                [distortion, D] = Local_Backlight(Name,D,data,contrast(cn,:),outputFolder);    
            end
            if(Scene_annotation.motion==1)
                if(isfile(Idepth))
                    data=load(Data_);
                    I=imread(Idepth);
                    if(Scene_annotation.type==1)
                        scene="outdoor";
                    else
                        scene="indoor";
                    end
                    [distortion, D] = Local_blur_motion(Image_name,I,D,data,outputFolder,scene);
                else
                    angle = randi([1 360],1);
                    len = randi([1 15],1);
                    [distortion, D] = distortion_motion_blur(D,Image_name,len,angle,outputFolder);
                end
            end
%             if(Scene_annotation.weather==1)
%                 data=load(Data_);
%                 I=imread(Idepth);
%                 if(Haze(k,1)==1)
%                 [distortion, D] = Global_haze(Name,D,I,Haze,alpha,outputFolder);
%                 end
%                 if(Rain(k,1)==1)
%                     if(Rain(k,2)==1)
%                         
%                         Rain=
%                     [distortion, D] = Global_rain(Name,Drizzle_up,I,Rain,data,alpha,outputFolder);
%                 end
%     
%             end
            if(Scene_annotation.defocus==1)
                if(isfile(Idepth))
                    data=load(Data_);
                    I=imread(Idepth);
                    [distortion, D] = Local_defocus_blur(Image_name,I,D,data,outputFolder);
                else
                    gaussian_size = 9;
                    gaussian_sigma = randi([1 20],1)*0.1;
                    [distortion, D] = distortion_defocus_blur(D,Image_name,gaussian_size,gaussian_sigma,outputFolder);
                end
            end
            
        end
        
    else
        D=imread(Dimg); 
        choice = randi([1,5],1);
        if(choice==1)
                angle = randi([1 360],1);
                len = randi([1 15],1);
                [distortion, D] = distortion_motion_blur(D,Image_name,len,angle,outputFolder);
        end

        % Check if global defocus distortion is selected and if so apply it
        if(choice==2)
            gaussian_size = 9;
            gaussian_sigma = randi([1 20],1)*0.1;
            [distortion, D] = distortion_defocus_blur(D,Image_name,gaussian_size,gaussian_sigma,outputFolder);
        end

        % Check if noise distortion is selected and if so apply it
        if(choice==3)
            means = 0;
            variance = randi([1 20],1)*0.001;
            [distortion, D] = distortion_noise(D,Image_name,means,variance,outputFolder); 
        end

        % Check if compression distortion is selected and if so apply it
        if(choice==4)
            compression = randi([10 50],1);
            [distortion, D] = distortion_compression(D,Image_name,compression,outputFolder);
        end

        % Check if contrast distortion is selected and if so apply it
        if(choice==5)
            cn = randi([1 10],1);
            [distortion, D] = Global_contraste(Name, D,contrast(cn,:),outputFolder);
        end
         LK = [Image_name,' -- image number: '];
        LK1 = [num2str(id),' -- distortion: '];
        LK2 = [ distortion,' '];
        displays= [ LK LK1 LK2];
        disp(displays)
        saving(id).Name=Name;
        saving(id).Distortion=distortion;
    end

%     LK = [Image_name,' -- image number: '];
%     LK1 = [num2str(id),' -- distortion: '];
%     LK2 = [ distortion,' '];
%     displays= [ LK LK1 LK2];
%     disp(displays)
%     saving(id).Name=Name;
%     saving(id).Distortion=distortion;
    
end
time=toc
save('dist_data_val_test.mat','Global_distortion_choice');
% Analyze distortion distribution



