%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to check
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function object_area = check_object_depth(index,object_depth, object_min, object_max)

object_area=zeros(size(object_depth,1),1);
threshold = object_min(index(1));
object_area(1)=1;
for i=2:size(object_depth,1)
    if((object_max(index(i))>= threshold) && (object_depth(index(i))>= threshold))
        object_area(i)=1;
    end
end



end