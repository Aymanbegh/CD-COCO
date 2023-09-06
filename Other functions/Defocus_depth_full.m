clear all;clc


Image.ID={'000000000724','000000004134','000000006471','000000007088','000000007281','000000010363','000000011699','000000013659','000000014038',...
    '000000015440','000000023034','000000032334','000000032901','000000033221','000000035963','000000037777','000000044279','000000045550','000000054605',...
    '000000054628','000000059598','000000074256','000000078266'};

for id=1:size(Image.ID,2)
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
    % data=load("C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\annotations_unpacked_minival\matFiles/label_0000007386.mat");
    
    Dout=zeros(size(I,1),size(I,2),size(I,3));
    depth=zeros(size(I,1),size(I,2));
    front=zeros(size(I,1),size(I,2));
    middle=zeros(size(I,1),size(I,2));
    %back=zeros(size(I,1),size(I,2));
    back_s=zeros(size(I,1),size(I,2));
    normal=zeros(size(I,1),size(I,2));
    
%     figure(1)
%     imshow(I)
%     
%     figure(2)
%     imshow(D)
    
    depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));
    
    maxi=max(max(depth));
    
    depth1=(depth./maxi).*255;
    
    mini=min(min(depth1));
    
    Depths=uint8(depth1);

    disp(id)
    
%     figure(3)
%     imshow(Depths)

    [object_depth, object_min, object_max] = Compute_depth_defocus(data,Depths);
    [E,index] = sortrows(object_depth,'descend');
%     max_depth = max(object_depth);
%     object_rank = Compute_rank(object_depth,max_depth);
%     threshold = (E(1)-object_var(index(1)));
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
%     
%     
%     figure(4)
%     imshow(uint8(normal))
%     figure(5)
%     imshow(uint8(front))
%     figure(6)
%     imshow(uint8(middle))
%     figure(7)
%     imshow(uint8(back_s))
    
    
    
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
    % for i=1:size(I,1)
    %     for j=1:size(I,2)
    %         if(normal(i,j)==255)
    %             for k=1:size(data.bbox,1)
    %                 Area255 = sum((data.masks(:,:,k)==255)&&normal(:,:)==255);
    %                 if(data.masks(i,j,k)==1)
    %                     labels(k)=1;
    % %                     nb=nb+1;
    %                 end
    %             end
    %         end
    %     end
    % end
    
    for k=1:size(labels,1)
        for i=1:size(I,1)
            for j=1:size(I,2)         
    %             if(data.masks(i,j,k)==1)
    %                 normal(i,j)=255;
    %                 front(i,j)=0;
    %                 middle(i,j)=0;
    %                 back_s(i,j)=0;
    %             end 
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
    
    figure(8)
    imshow(uint8(normal))
    figure(9)
    imshow(uint8(front))
    figure(10)
    imshow(uint8(middle))
    figure(11)
    imshow(uint8(back_s))
    
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

    sigma = 0.5 + ((abs(depth_f-threshold)/threshold))*1.5;
    sigma_m = sigma + ((abs(depth_m-threshold)/threshold))*1.2;
    sigma_b = sigma_m + ((abs(depth_m-threshold)/threshold))*1.2;
    

    Dfront = imgaussfilt(D,sigma,'FilterSize',11);
    Dmiddle = imgaussfilt(D,sigma_m,'FilterSize',11);
    Dback = imgaussfilt(D,sigma_b,'FilterSize',15);
    
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
    
    if(id==7)
        p=1;
    end
%     figure(12)
%     imshow(uint8(Dout))
    
    Destination=".\ImageDefocus3\";
    Name_img = Destination+Name + Image_end;
    imwrite(uint8(Dout),Name_img)

end

