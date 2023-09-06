%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to classify the objects class through some superclasses
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function superclass = classification(data)
% superclass.value;

for i=1:size(data.label,1)
    superclass(i).value="other";
    if(data.label(i)=="car" || data.label(i)=="truck" || data.label(i)=="train" || data.label(i)=="boat" || data.label(i)=="bus" || data.label(i)=="airplane")
        superclass(i).value="vehicle";
    end
    if(data.label(i)=="bicycle" || data.label(i)=="motorcycle" )
        superclass(i).value="vehicle_h";
    end
    if(data.label(i)=="bird" || data.label(i)=="cat" || data.label(i)=="dog" || data.label(i)=="horse" || data.label(i)=="sheep" || data.label(i)=="cow" || data.label(i)=="elephant" || data.label(i)=="bear" || data.label(i)=="zebra" || data.label(i)=="giraffe")
        superclass(i).value="animal";
    end
    if(data.label(i)=="backpack" || data.label(i)=="tie" || data.label(i)=="suitcase" || data.label(i)=="handbag" || data.label(i)=="umbrella")
        superclass(i).value="accessory";
    end
    if(data.label(i)=="wine glass" || data.label(i)=="cup" || data.label(i)=="fork" || data.label(i)=="knife" || data.label(i)=="spoon" || data.label(i)=="bowl")
        superclass(i).value="kitchen";
    end
    if(data.label(i)=="frisbee" || data.label(i)=="sports ball" || data.label(i)=="kite" || data.label(i)=="baseball bat" || data.label(i)=="baseball glove" || data.label(i)=="tennis racket")
        superclass(i).value="sport";
    end
    if(data.label(i)=="banana" || data.label(i)=="apple" || data.label(i)=="sandwich" || data.label(i)=="orange" || data.label(i)=="hot dog" || data.label(i)=="pizza" || data.label(i)=="donut" || data.label(i)=="cake")
        superclass(i).value="food";
    end
    if(data.label(i)=="cell phone" || data.label(i)=="mouse" || data.label(i)=="remote" || data.label(i)=="book" || data.label(i)=="scissors" || data.label(i)=="teddy bear" || data.label(i)=="hair drier" || data.label(i)=="toothbrush")
        superclass(i).value="tool";
    end
end

end