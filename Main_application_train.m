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
addpath('./Other functions');

%% Path declarations for COCO dataset
% Dataset image for the training
imgtrain_path='./train2017';
%Add path
addpath(imgtrain_path);

%% Path declaration for the output distortion directory
% Dataset of the distorted image for the training
outputFolder='./train2017_distorted/';
% Add path
addpath(outputFolder);

%% Create the distortion directories
% Specified the path to your annotations files from train, val, or test
% folders
path_annotation =('./annotations_unpacked\annotations_unpacked\matFiles');
addpath(path_annotation);

%% Specific directories for haze and rain sources
hazeFolder=('./weather_image\haze/');
addpath(hazeFolder);
rainFolder=('./weather_image\rain/');
addpath(rainFolder);
haze_img = "./weather_image\haze\fog_";
rain_img = "rain_";
rain_img2 = "rain2_";

%% Scene annoatations
load("scene_annotation_full.mat","Scene");
load("weather_.mat","Rain","Haze");

%% Image names
fullFileName = fullfile(pwd, 'ImageList.txt');
Image_name_list = readtable(fullFileName);

%% Additional path
Depth_location="./Depth_train\output/";
Depth_end="-dpt_beit_large_512.png";
Depth_endss="-dpt_swin2_base_384.png";
Depth_ends="-dpt_swin2_large_384.png";
Image_location="./train2017/";
Image_end=".jpg";

%% Define all parameters for the various distortion functions (excepted name
    % ,imgin and outputFolder)

contrast = [0.3 0.7;0.2 0.8;0.2 1.0;0.3 0.8;0.2 0.9; 0.3 0.9;...
        0.3 1.0;0.35 0.9;0.35 1.0;0.4 0.9];

Global_distortion_choice = Select_global_distortion(Scene);
save("Global_choice.mat","Global_distortion_choice");
% load("Global_choice.mat","Global_distortion_choice");

% Global_distortion_choice = Select_global_distortion(Scene,Global_distortion_choice);
% save("Global_choice.mat","Global_distortion_choice");
% Global_distortion_choice()
%% Loop distortion performing
% breaks down annotation extraction into 6 steps to not overload MATLAB capabilities
% for id=1:size(Scene,1)
tic
for id=1:length(Scene)
    % Get the image name
    Image_name = char(table2cell(Image_name_list(id,:)));
    Name = Image_name(1:end-4);
    % Get the scene annotation
    Scene_annotation = Scene(id);
    % Path to the .mat data file
    Data_ = [path_annotation '/' Name '.mat'];
    % Give the image and depth complet name
    Idepth = Depth_location+Name+Depth_end;
    Dimg=Image_location+Name+Image_end;
    distortion = "none";

    %Check if the depth image exists
    if (isfile(Idepth)==0)
        Idepth = Depth_location+Name+Depth_ends;
        if (isfile(Idepth)==0)
            Idepth = Depth_location+Name+Depth_endss;
        end
    end
    

    if(isfile(Data_))

        if((Rain(id,1)==0) && (Haze(id,1)==0) && (Scene_annotation.weather==1))
            Scene_annotation.global=1;
        end
        if((Scene_annotation.global==0) && (Scene_annotation.motion==0) && (Scene_annotation.weather==0) && (Scene_annotation.defocus==0) && (Scene_annotation.perturbation==0) && (Scene_annotation.back==0))
            Scene_annotation.global=1;
        end

        if((Rain(id,1)==0) && (Haze(id,1)==0) && (Scene_annotation.weather==1))
            Scene_annotation.global=1;
        end

        % Read original image
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
            if(Scene_annotation.weather==1)
                    data=load(Data_);
    %                 I=imread(Idepth);
                    if(((Rain(id,1)==0) && (Haze(id,1)==0) && (Scene_annotation.weather==1)) ||(isfile(Idepth)==0))
    %                     I=imread(Idepth);
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
                    end
                    
                    if(Haze(id,1)==1  && isfile(Idepth))
                        I=imread(Idepth);
                        if(Haze(id,2)==1 ||Haze(id,2)==2)
                            alpha = 0.01 * randi([65,95],1);
                            img = randi([477,547],1);
                            file = haze_img + num2str(img) +Image_end;
                            Haze_= imread(file);
                            [distortion, D] = Global_haze(Name,D,I,Haze_,alpha,outputFolder);
                        end
                        if(Haze(id,2)==3)
                            alpha = 0.01 * randi([65,95],1);
                            img = randi([2216,2276],1);
                            file = haze_img + num2str(img) +Image_end;
                            Haze_= imread(file);
                            [distortion, D] = Global_haze(Name,D,I,Haze_,alpha,outputFolder);
                        end
                    end
    
                    if(Rain(id,1)==1  && isfile(Idepth))
                        I=imread(Idepth);
                        if(Rain(id,2)==1)
                            r = randi([1,55],1);
                            img_rain="./weather_image\rain\left\rain\rain_";
                            file = img_rain + num2str(r) +Image_end;
                            Rain_= imread(file);
                        end
                        if(Rain(id,2)==2)
                            r = randi([1,55],1);
                            img_rain = "./weather_image\rain\middle\rain2\rain2_";
                            file = img_rain + num2str(r) +Image_end;
                            Rain_= imread(file);
                        end
                        if(Rain(id,2)==3)
                            r = randi([1,55],1);
                            img_rain="./weather_image\rain\right\rain\rain_";
                            file = img_rain + num2str(r) +Image_end;
                            Rain_= imread(file);
                        end
    
                        if(Rain(id,3)==1)    
                            alpha= randi([15, 25],1);
                            [distortion, D] = Global_rain(Name,D,I,Rain_,data,alpha*0.1,outputFolder);
                        end
                        if(Rain(id,3)==2)    
                            alpha= randi([25, 40],1);
                            [distortion, D] = Global_rain(Name,D,I,Rain_,data,alpha*0.1,outputFolder);
                        end
                        if(Rain(id,3)==3)    
                            alpha= randi([40, 55],1);
                            [distortion, D] = Global_rain(Name,D,I,Rain_,data,alpha*0.1,outputFolder);
                        end
        
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
% end
time=toc
save('dist_data.mat','saving','Global_distortion_choice');
% Analyze distortion distribution



