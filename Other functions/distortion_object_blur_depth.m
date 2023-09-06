function valid_object = distortion_object_blur_depth(imgin,name,mask,len,angle,outputFolder,mask_out)

%% Uncomment Parameters for motion blur %%
nb_object=length(len);

%% Create image for use as mask for creating non-uniform illumination %%
%Number object

valid_object = ones(nb_object,1);

for nb=1:nb_object    
    blur_motion_filter = fspecial('motion',len(nb),angle(nb));
    obj_1(:,:,:,nb)  = imfilter(imgin(:,:,:),blur_motion_filter,'replicate');   % Add motion blur    
end
imG_out=imgin;
for i=1:size(imgin,1)
    for j=1:size(imgin,2)
        for k=1:nb_object
            if(mask(i,j,k)==1 && mask_out(i,j,k)>=0)
               imG_out(i,j,:)= obj_1(i,j,:,k);
            end
        end
    end
end
outputname = sprintf('%s',name);
imwrite(imG_out, [outputFolder outputname]);

end