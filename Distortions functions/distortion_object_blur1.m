function valid_object = distortion_object_blur1(imgin,name,mask,bboxe,len,angle,outputFolder,outputHead)

%% Uncomment Parameters for motion blur %%
nb_object=size(len);
blur_motion_filter = {};
for i=1:nb_object(1)
    blur_motion_filter{i} = fspecial('motion',len(i,1),angle(i,1));
end
blur_motion_filter_beta={};
for i=1:nb_object(1)
    for j=1:len(i,1)
    blur_motion_filter_beta{i,j} = fspecial('motion',(len(i,1) +1)-j,angle(i,1));
    end
end
% outputHead= sprintf('object_len_%1d_angle_%d',len,angle);
 
if ~exist(fullfile(outputFolder,outputHead), 'dir')
  mkdir(outputFolder,outputHead)
end
output= [outputFolder '/' outputHead];
outputFolder = [output,'/'];

% outputnames = sprintf('/%f',len(1,1));
outputnames = 'test';
if ~exist(fullfile(outputFolder,outputnames), 'dir')
  mkdir(outputFolder,outputnames)
end
output= [outputFolder outputnames];
outputFolder = [output,'/'];

%% Create image for use as mask for creating non-uniform illumination %%
%Number object

valid_object = ones(nb_object(1),1);

for nb=1:nb_object(1)
    len_size=len(nb);
    temp_mask=cell(nb_object(1),len_size);
    size_img=size(imgin);
    global_mask =zeros(size_img(1),size_img(2));
    if(bboxe(nb,3)<= 15 && bboxe(nb,4)<= 15 )
        valid_object(nb) = 0;
    else
        global_mask=uint8(global_mask);
    %     blur_motion_filter=fspecial('motion',len(i,1),angle(i,1));
        for j=1:len_size  
            if j==1
                current_mask= bwboundaries(mask(:,:,nb));
            else
                current_mask= bwboundaries(next_mask);
            end
            size_current=size(current_mask{1,1});
            size_mask=size(mask(:,:,nb));
            F3=zeros(size_mask(1),size_mask(2),1);

            for i=1:size_current(1)
                pos1=current_mask{1,1}(i,1);
                pos2=current_mask{1,1}(i,2);
                F3(pos1,pos2,1)=1;
                F3_logical=logical(F3); 
                next_mask = mask(:,:,nb) - F3_logical;
            end

            F3=uint8(F3);
            F3_p(:,:,1)=F3;
            F3_p(:,:,2)=F3;
            F3_p(:,:,3)=F3;

            temp_mask{nb,j}=F3_p;

        end

        final_mask=uint8(next_mask);

        mask_p(:,:,1)=final_mask;
        mask_p(:,:,2)=final_mask;
        mask_p(:,:,3)=final_mask;

        global_mask = global_mask+final_mask;

        obj_1 = imgin(:,:,:).*mask_p(:,:,:);
        obj_1(:,:,:)  = imfilter(obj_1(:,:,:),blur_motion_filter{nb},'replicate');   % Add motion blur
        size_image=size(obj_1);
        obj_4 = uint8(zeros(size_image(1),size_image(2),3));
        for l=1:len_size
            obj_3 = imgin(:,:,:).*temp_mask{nb,l};
            obj_3(:,:,:)  = imfilter(obj_3(:,:,:),blur_motion_filter_beta{nb,l},'replicate');   % Add motion blur  
            obj_4(:,:,:) = obj_4(:,:,:)+ obj_3(:,:,:);
            global_mask = global_mask + temp_mask{nb,l}(:,:,1);
        end

        inversion=logical(global_mask);
        imG = obj_1(:,:,:) + obj_4(:,:,:)/3;

        for i=1:size_img(1)
            for j=1:size_img(2)
                if(imG(i,j,:)==0)
                    imG(i,j,:)=imgin(i,j,:);
                end
                if(inversion(i,j)==0 )
                    imG(i,j,:)=imgin(i,j,:);
                end
            end   
        end
        imgin=imG;
    end
    imG_out = imG;
end
outputname = sprintf('%s',name);
imwrite(imG_out, [outputFolder outputname]);

end