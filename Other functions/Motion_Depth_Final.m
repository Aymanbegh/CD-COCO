clear all;clc
addpath('./Distortions functions');
addpath('./Motion local functions');


Image.ID={'000000338325','000000338625','000000340272','000000341196','000000341681','000000342397','000000343561','000000344029','000000347456',...
    '000000349860','000000350405','000000350679','000000351823','000000355817','000000355905','000000356968','000000360661','000000361142','000000362682',...
    '000000363875','000000365655','000000369541','000000369812','000000375015','000000378673','000000379453','000000402118','000000404479','000000423617',...
    '000000421757','000000424776','000000427160','000000429109','000000435299','000000441442','000000447917','000000452122','000000455624','000000457559',...
    '000000461751','000000463647','000000468632','000000476119','000000480944','000000481390','000000481480','000000481159','000000491130','000000507975',...
    '000000513580','000000515025','000000516143','000000517523','000000520009','000000520832','000000534827','000000538364','000000545407','000000547886',...
    '000000559842','000000567640','000000578792'};

for id=1:size(Image.ID,2)
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
    
    % data=load("C:\Users\beghd\OneDrive\Bureau\Dataset\COCO\annotations_unpacked_minival\matFiles/label_0000042563.mat");
    
    data=load(Data_);
    
    
    outputFolder=('./ImageMotion2/');
    addpath(outputFolder);
    
    outputHead = 'object_blur';
    
    
    Dout=zeros(size(I,1),size(I,2),size(I,3));
    
    disp(id)
    % figure(1)
    % imshow(I)
    % 
    % figure(2)
    % imshow(D)
    if(ismissing(data.label))
        len =randi([5 400],1);
        angle =randi([1 360],1);
        blur_motion_filter = fspecial('motion',len*0.1,angle);
        imG_out = imfilter(D,blur_motion_filter,'replicate');   % Add motion blur 
        name = Name + Image_end;
        outputname = sprintf('%s',name);
        imwrite(imG_out, [outputFolder outputname]);

    else
        % Convert depth image into grayscale image
        depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));    
        maxi=max(max(depth));   
        depth1=(depth./maxi).*255;
        mini=min(min(depth1));   
        Depths=uint8(depth1);

        % Determin scene context, constant value and objects activated
        scene = "outdoor";
        scene_context=find_context(data);
        superclass = classification(data);
        [object_depth, object_var] = Compute_depth(data,Depths);
        [len, angle,activation] = Compute_motion_depth(data,scene,scene_context,superclass,object_depth, object_var);
        [len, angle,interaction, activation] = find_interaction_depth(scene,scene_context,superclass,activation,data.label,data.masks,data.bbox,len,angle,object_depth, object_var);
        
        name = Name + Image_end;
        
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
        %         se = strel("line",le,angles(i));
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
        
        img_out = 255.*mask(:,:,:);
        
        if(id==8)
            p=1;
        end
        
        % Apply the local distortion
        valid_object = distortion_object_blur_depth(D,name,mask,lens,angles,outputFolder,mask_out);
        
%         saving(id).Name=name;
%         saving(id).lens=lens;
%         saving(id).angles=angles;
%         saving(id).activ=activation;
%         saving(id).Label=Label_out;
%         saving(id).consist=consistence;
    end
end





