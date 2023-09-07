%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to apply local defocus blur
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [distortion, Dout] = Local_defocus_blur(Name,I,D,data,outputFolder)
    addpath('./Distortions functions');
    addpath('./Defocus local functions');

    Image_end=".jpg";

    if(ismissing(data.label))
        
        sigma = randi([5,40],1);
        Dout = imgaussfilt(D,sigma*0.1,'FilterSize',11);
        name=Name;
        outputname = sprintf('%s',name);
        imwrite(uint8(Dout), [outputFolder outputname],"Quality",95);
        distortion = "Global defocus blur";

    else

        Dout=zeros(size(I,1),size(I,2),size(I,3));
        depth=zeros(size(I,1),size(I,2));
        front=zeros(size(I,1),size(I,2));
        middle=zeros(size(I,1),size(I,2));
        back_s=zeros(size(I,1),size(I,2));
        normal=zeros(size(I,1),size(I,2));
        
        
        % Convert Depth image into grayscale image
        depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));        
        maxi=max(max(depth));        
        depth1=(depth./maxi).*255;        
        mini=min(min(depth1));
        Depths=uint8(depth1);    

        % Compute and sort objects depth
        [object_depth, object_min, object_max] = Compute_depth_defocus(data,Depths);
        [E,index] = sortrows(object_depth,'descend');

        if(size(data.label,1)>1)
            object_area = check_object_depth(index,object_depth, object_min, object_max);
        end

        % Compute thresholds
        threshold = object_min(index(1));
        th_f = 1 - (1./(1+exp(-(15*(0.4-0.5)))));
        th_m = 1 - (1./(1+exp(-(15*(0.5-0.5)))));
        th_b = 1 - (1./(1+exp(-(15*(0.6-0.5)))));
        
        for i=1:size(I,1)
            for j=1:size(I,2)
                if(Depths(i,j)>threshold)
                    normal(i,j)=255;
                end
                if(Depths(i,j)<=threshold && Depths(i,j)>threshold *th_f)
                    front(i,j)=255;
                end
                if(Depths(i,j)<=threshold *th_f && Depths(i,j)>threshold *th_b)
                    middle(i,j)=255;
                end
                if(Depths(i,j)<=threshold *th_b)
                    back_s(i,j)=255;
                end
            end
        end     
                
        
        nb=1;
        
        labels=zeros(size(data.bbox,1),1);
        for k=1:size(data.bbox,1)
            Area=0;
            AreaU=0;
            M=255.*double(data.masks(:,:,k));
            for i=1:size(I,1)
                for j=1:size(I,2)
                    if(M(i,j)==255)
                        Area=Area+1;
                        if(normal(i,j)==255)
                            AreaU=AreaU+1;
                        end
                    end
                end
            end
            if((AreaU/Area)>0.8)
                labels(k)=1;
            end
        end
        
        for k=1:size(labels,1)
            for i=1:size(I,1)
                for j=1:size(I,2)         
                    if(labels(k)==1)
                        if(data.masks(i,j,k)==1)
                            normal(i,j)=255;
                            front(i,j)=0;
                            middle(i,j)=0;
                            back_s(i,j)=0;
                        end 
                    end
                end
            end
        end
             
        % Compute average depth of each area
        depth_=0;
        depth_f=0;
        depth_m=0;
        depth_b=0;
        cpt_=0;
        cpt_f=0;
        cpt_m=0;
        cpt_b=0;
    
        for i=1:size(I,1)
            for j=1:size(I,2)
                if(normal(i,j)==255)
                    depth_=depth_+double(Depths(i,j));
                    cpt_=cpt_+1;
                end
                if(front(i,j)==255)
                    depth_f=depth_f+double(Depths(i,j));
                    cpt_f=cpt_f+1;
                end
                if(middle(i,j)==255)
                    depth_m=depth_m+double(Depths(i,j));
                    cpt_m=cpt_m+1;
                end
                if(back_s(i,j)==255)
                    depth_b=depth_b+double(Depths(i,j));
                    cpt_b=cpt_b+1;
                end
    
    
            end
        end
    
        depth_=depth_/cpt_;
        depth_f=depth_f/cpt_f;
        depth_m=depth_m/cpt_m;
        depth_b=depth_b/cpt_b;
    
        % Determin simgas according to average depth of each area
        sigma = 0.5 + ((abs(depth_f-threshold)/threshold))*1.5;
        sigma_m = sigma + ((abs(depth_m-threshold)/threshold))*1.2;
        sigma_b = sigma_m + ((abs(depth_m-threshold)/threshold))*1.2;

        if(isfinite(sigma))       
            % Apply gaussian filter
            Dfront = imgaussfilt(D,sigma,'FilterSize',11);
            Dmiddle = imgaussfilt(D,sigma_m,'FilterSize',11);
            Dback = imgaussfilt(D,sigma_b,'FilterSize',15);
            
    
            % Manage pixels value acoording to areas and depth
            if(threshold>95 || object_depth(index(1))>95)
                for i=1:size(I,1)
                    for j=1:size(I,2)
                        if(normal(i,j)==255)
                            Dout(i,j,:)=D(i,j,:);
                        end
                        if(front(i,j)==255)
                            Dout(i,j,:)=Dfront(i,j,:);
                        end
                        if(middle(i,j)==255)
                            Dout(i,j,:)=Dmiddle(i,j,:);
                        end
                        if(back_s(i,j)==255)
                            Dout(i,j,:)=Dback(i,j,:);
                        end
                    end
                end
            else
                for i=1:size(I,1)
                    for j=1:size(I,2)
                        if(normal(i,j)==255)
                            Dout(i,j,:)=Dback(i,j,:);
                        end
                        if(front(i,j)==255)
                            Dout(i,j,:)=Dmiddle(i,j,:);
                        end
                        if(middle(i,j)==255)
                            Dout(i,j,:)=Dfront(i,j,:);
                        end
                        if(back_s(i,j)==255)
                            Dout(i,j,:)=D(i,j,:);
                        end
                    end
                end
            end
            
            % Write image
            name=Name;
            outputname = sprintf('%s',name);
            imwrite(uint8(Dout), [outputFolder outputname],"Quality",95);
            distortion = "Local defocus blur";
        else
            % Apply a global defocus blur is sigma is infinite
            sigma = randi([5,40],1);
            Dout = imgaussfilt(D,sigma*0.1,'FilterSize',11);
            name=Name;
            outputname = sprintf('%s',name);
            imwrite(uint8(Dout), [outputFolder outputname],"Quality",95);
            distortion = "Global defocus blur";

        end
    end

end

