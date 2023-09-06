function valid_object = distortion_object_blur2(imgin,name,mask,bboxe,len,angle,outputFolder,outputHead)

%% Uncomment Parameters for motion blur %%
nb_object=length(len);


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

valid_object = ones(nb_object,1);

for nb=1:nb_object    
    blur_motion_filter = fspecial('motion',len(nb),angle(nb));
    obj_1(:,:,:,nb)  = imfilter(imgin(:,:,:),blur_motion_filter,'replicate');   % Add motion blur        
end
imG_out=imgin;
for i=1:size(imgin,1)
    for j=1:size(imgin,2)
        for k=1:nb_object
            if(mask(i,j,k)==1)
               imG_out(i,j,:)= obj_1(i,j,:,k);
            end
        end
    end
end
outputname = sprintf('%s',name);
imwrite(imG_out, [outputFolder outputname]);

end