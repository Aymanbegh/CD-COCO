%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply local blur motion
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [distortion, imG_out] = Local_blur_motion(Name,I,D,data,outputFolder,scene)
    addpath('./Distortions functions');
    addpath('./Motion local functions');

    %Image_end=".jpg";       
    Dout=zeros(size(I,1),size(I,2),size(I,3));
    
    if(ismissing(data.label))
        len =randi([5 400],1);
        angle =randi([1 360],1);
        blur_motion_filter = fspecial('motion',len*0.1,angle);
        imG_out = imfilter(D,blur_motion_filter,'replicate');   % Add motion blur 
        name = Name;
        outputname = sprintf('%s',name);
        imwrite(imG_out, [outputFolder outputname],"Quality",95);
        distortion = "Global motion blur";

    else
        % Convert depth image into grayscale image
        depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));    
        maxi=max(max(depth));   
        depth1=(depth./maxi).*255;
        mini=min(min(depth1));   
        Depths=uint8(depth1);

        % Determin scene context, constant value and objects activated
%         scene = "outdoor";
        scene_context=find_context(data);
        superclass = classification(data);
        [object_depth, object_var] = Compute_depth(data,Depths);
        [len, angle,activation] = Compute_motion_depth(data,scene,scene_context,superclass,object_depth, object_var);
        [len, angle,interaction, activation] = find_interaction_depth(scene,scene_context,superclass,activation,data.label,data.masks,data.bbox,len,angle,object_depth, object_var);
        
        name = Name;
        
        % Sort and check consistency of objects depth
        [bboxes, labels, masks, angle, len, activation,object_depth, object_var,superclass] = sorting_depth(data, len, angle, activation,object_depth, object_var,I,superclass);
        [mask_outs,consistence] = depth_consistency(masks,Depths,object_depth, object_var);
    
        lens=[];
        angles=[];
        bboxe = [];
        mask =[];
        mask_out =[];
        Label_out=[];
        
        % Keep only objects considered activated on which we will affect the local distortion 
        nb=1;
        for i=1:size(data.label,1)
            if(activation(i)==1)
                lens(nb)=len(i);
                angles(nb)=angle(i);
                bboxe(nb,:) = bboxes(i,:);
                Label_out(nb) = labels(i);
                mask(:,:,nb) = masks(:,:,i);
                mask_out(:,:,nb)=mask_outs(:,:,i);
                nb=nb+1;
            end
        end
    
        mask_old = mask;
        
        % Compute the blur trail from the object motion
        dilatedBW=[];
        img=zeros(size(D,1),size(D,2),length(lens));
        imgd=zeros(size(D,1),size(D,2),length(lens));
        for i=1:length(lens)
             if((sqrt(bboxe(i,3)^2+bboxe(i,4)^2))>90)
                img(:,:,i) = 255.*mask(:,:,i);
                le=round(lens(i)/2);
                if(angles(i)<0)
                    angles(i)=angles(i)+180;
                end
                a=le*cos(pi*angles(i)/180);
                b=le*sin(pi*angles(i)/180);
                se = translate(strel(1), [-round(b) -round(a)]);
                dilatedBW(:,:,i) = imdilate(img(:,:,i),se);
            else
                dilatedBW(:,:,i) = double(imgd(:,:,i));
            end
        end
        
        for k=1:length(lens)
            for i=1:size(D,1)
                for j=1:size(D,2)
                    if(mask(i,j,k)==0)
                        if(dilatedBW(i,j,k)==255)
                            mask(i,j,k)=1;
                        end
                    end
                end
            end
        end
        
        if(max(activation)==0)
            len =randi([5 400],1);
            angle =randi([1 360],1);
            blur_motion_filter = fspecial('motion',len*0.1,angle);
            imG_out = imfilter(D,blur_motion_filter,'replicate');   % Add motion blur 
            name = Name;
            outputname = sprintf('%s',name);
            imwrite(imG_out, [outputFolder outputname],"Quality",95);
            distortion = "Global motion blur";
        else
            % Apply the local distortion
            [valid_object, imG_out] = distortion_object_blur_depth(D,name,mask,lens,angles,outputFolder,mask_out); 
            distortion = "Local motion blur";
        end
    end
end






