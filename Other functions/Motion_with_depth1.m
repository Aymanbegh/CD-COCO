clear all;clc
addpath('./Distortions functions');

Name ="000000006040";
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


outputFolder=('./Image23/');
addpath(outputFolder);

outputHead = 'object_blur';


Dout=zeros(size(I,1),size(I,2),size(I,3));


figure(1)
imshow(I)

figure(2)
imshow(D)



depth=double(I(:,:,1))+2.*double(I(:,:,2))+0.1.*double(I(:,:,3));

maxi=max(max(depth))

depth1=(depth./maxi).*255;

mini=min(min(depth1));

Depths=uint8(depth1);

figure(3)
imshow(Depths)

scene=find_context(data);
superclass = classification(data);
[len, angle,activation] = Compute_motion(data,scene,superclass);
[len, angle,interaction, activation] = find_interaction(scene,superclass,activation,data.label,data.masks,data.bbox,len,angle);
name=data.imageName;

nb=1;
for i=1:size(data.label,1)
    if(activation(i)==1)
        lens(nb)=len(i);
        angles(nb)=angle(i);
        bboxe(nb,:) = data.bbox(i,:);
        mask(:,:,nb) = data.masks(:,:,i);
        nb=nb+1;
    end
end

img=zeros(size(D,1),size(D,2),length(lens));
imgd=zeros(size(D,1),size(D,2),length(lens));
for i=1:length(lens)
     if((sqrt(bboxe(i,3)^2+bboxe(i,4)^2))>90)
        img(:,:,i) = 255.*mask(:,:,i);
        le=20;
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

figure(4)
imshow(uint8(dilatedBW(:,:,1)-img(:,:,1)))


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

figure(5)
imshow(uint8(img_out(:,:,1)))

valid_object = distortion_object_blur2(D,name,mask,bboxe,lens,angles,outputFolder,outputHead);






