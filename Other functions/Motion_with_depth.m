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
name=data.imageName;

nb=1;
for i=1:size(data.label,1)
    if(activation(i)==1)
        lens(nb)=len(i);
        angles(nb)=angle(i)+180;
        bboxe(nb,:) = data.bbox(i,:);
        mask(:,:,nb) = data.masks(:,:,i);
        nb=nb+1;
    end
end

valid_object = distortion_object_blur2(D,name,mask,bboxe,lens,angles,outputFolder,outputHead);  


% name = data{1,i}.imageName;
%     bboxe = data{1,i}.bbox;
%     label = data{1,i}.label;
%     mask = data{1, i}.masks;
%     size_label=size(label,1);
%     len=zeros(size_label(1),1);
%     angle=zeros(size_label(1),1);
%     for j=1:size_label
%         if(label(j)=='motorcycle')
%             props1 = regionprops(data{1, i}.masks(:,:,j), 'Orientation');
%             angle(j,1)=props1.Orientation;
%             len(j,1)=5;
%       
%         else 
%             angle(j,1)=90;
%             len(j,1)=25;
%         end
%     end
%     myImages= imread(fullfile(Imgsrc{1,choice}, name));
% % Past here the desired distortion function as:
%     valid_object = distortion_object_blur1(myImages,name,mask,bboxe,len,angle,outputFolder,outputHead);  
%     objects{i,1} = valid_object;





