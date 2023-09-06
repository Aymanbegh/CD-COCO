function [distortion, imG_out] = Local_Backlight(Name,D,data,contrast,outputFolder)

%Image name
Image_end=".jpg";
name_in = Name+ Image_end;

% Adjust contrast
imG_C =imadjust(D,contrast,[]);
imG_out = D;

% Apply changing contrast on objects
for k=1:size(data.label,1)
    for i=1:size(D,1)
        for j=1:size(D,2)
            if(data.masks(i,j,k)==1)
                imG_out(i,j,:)=imG_C(i,j,:);
            end
        end
    end
end

%writing image
outputname = sprintf('%s',name_in);
imwrite(imG_out, [outputFolder outputname]);
distortion = "Local Backlight";
end