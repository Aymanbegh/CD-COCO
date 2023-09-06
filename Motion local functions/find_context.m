%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to find the scene context
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function scene = find_context(data)
    scene = 'other';
    for i=1:size(data.label,1)

        if(data.label(i)=="skis" || data.label(i)=="snowboard")
            scene = 'ski';  
            continue;
        end        
%         if(data.label(i)=="tennis racket")
%             scene = 'tennis';  
%             continue;
%         end
        if(data.label(i)=="horse" || data.label(i)=="elephant")
            scene = 'riding';  
            continue;
        end
        if(data.label(i)=="sports ball" || data.label(i)=="frisbee" || data.label(i)=="baseball bat" || data.label(i)=="baseball glove" || data.label(i)=="tennis racket")
            scene = 'sport';  
            continue;
        end
        if(data.label(i)=="skateboard")
            scene = 'skate';  
            continue;
        end
        if(data.label(i)=="surfboard")
            scene = 'surf';  
            continue;
        end       	    
    end

end