function Global_distortion_choice = Select_global_distortion(Scene,Global_distortion_choice)

% Global_distortion_choice = zeros(size(Scene,2),1);

cpt_g=0;
for id=1:size(Scene,2)
    % Get the scene annotation
    if(Scene(id).global==1)
        cpt_g=cpt_g+1;
    end   
end

choice_distortion=randi([1,5],cpt_g,1);

cpt=1;
for id=1:size(Scene,2)
    % Get the scene annotation
    if(Scene(id).global==1)
        if(Scene(id).defocus==1 || Scene(id).motion==1)
            add_choice=randi([3,5],1);
            Global_distortion_choice(id,1)=add_choice;
        else
            Global_distortion_choice(id,1)=choice_distortion(cpt,1);
        end
        cpt=cpt+1;
    else
        Global_distortion_choice(id,1)=0;
    end
end



end