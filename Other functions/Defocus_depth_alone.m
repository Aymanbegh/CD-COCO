clear all;clc
addpath('./Distortions functions');
addpath('./Defocus local functions');

Image.ID={'000000000724','000000004134','000000006471','000000007088','000000007281','000000010363','000000011699','000000013659','000000014038',...
    '000000015440','000000023034','000000032334','000000032901','000000033221','000000035963','000000037777','000000044279','000000045550','000000054605',...
    '000000054628','000000059598','000000074256','000000078266',...
    '000000074256','000000025593','000000078266','000000015746','000000018737','000000029187','000000030504','000000032941'};

for id=6:size(Image.ID,2)
%     Name ="000000018737";
    Name =Image.ID{1,id};
    Depth_location="C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\Depth_validation/";
    Depth_end="-dpt_beit_large_512.png";
    Image_location="C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\val2017/";
    Image_end=".jpg";
    Label_location="C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\annotations_unpacked_minival\matFiles/label_";
    Label_end=".mat";
    
    Idepth = Depth_location+Name+Depth_end;
    Dimg=Image_location+Name+Image_end;
    N=extractAfter(Name,2);
    
    Data_=Label_location+N+Label_end;
    I=imread(Idepth);
    D=imread(Dimg);
    
    data=load(Data_);

    if(ismissing(data.label))
        
        sigma = randi([5,40],1);
        Dout = imgaussfilt(D,sigma*0.1,'FilterSize',11);
        Destination=".\ImageDefocus1\";
        Name_img = Destination+Name + Image_end;
        imwrite(uint8(Dout),Name_img)

    else

        Dout=zeros(size(I,1),size(I,2),size(I,3));
        depth=zeros(size(I,1),size(I,2));
        front=zeros(size(I,1),size(I,2));
        middle=zeros(size(I,1),size(I,2));
        %back=zeros(size(I,1),size(I,2));
        back_s=zeros(size(I,1),size(I,2));
        normal=zeros(size(I,1),size(I,2));
        
        
        % Convert Depth image into grayscale image
        depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));        
        maxi=max(max(depth));        
        depth1=(depth./maxi).*255;        
        mini=min(min(depth1));
        Depths=uint8(depth1);    

        disp(id)
        
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
        
        % Apply gaussian filter
        Dfront = imgaussfilt(D,sigma,'FilterSize',11);
        Dmiddle = imgaussfilt(D,sigma_m,'FilterSize',11);
        Dback = imgaussfilt(D,sigma_b,'FilterSize',15);
        

        % Manage pixels value acoording to areas and depth
        if(threshold>100 || object_depth(index(1))>100)
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
        
        if(id==7)
            p=1;
        end
    %     figure(12)
    %     imshow(uint8(Dout))
        % Write image
        Destination=".\ImageDefocus1\";
        Name_img = Destination+Name + Image_end;
        imwrite(uint8(Dout),Name_img)
    end

end

