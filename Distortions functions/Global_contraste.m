function [distortion, imG_out] = Global_contraste(Name, D,contrast,outputFolder)
    addpath('./Distortions functions');  
    Image_end=".jpg";
    name_in = Name+Image_end;
    
    G = rgb2gray(D);
    Mean_img = mean(mean(double(G)));

    if(Mean_img<80)
        choice = randi([1,2],1);
        if(choice ==1)
            means = 0;
            variance = randi([1 20],1)*0.001;            
            [distortion, imG_out] = distortion_noise(D,name_in,means,variance,outputFolder); 
        else
            compression = randi([10 50],1);
            [distortion, imG_out] = distortion_compression(D,name_in,compression,outputFolder);
        end
        
    else
        [distortion, imG_out] = distortion_contrast(D,name_in,contrast,outputFolder);
    end
 
    
end








