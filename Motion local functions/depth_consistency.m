%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to check the depth consistency between objects
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask_out,consistence] = depth_consistency(masks,Depth,object_depth, object_var)

mask_out=zeros(size(Depth,1),size(Depth,2),size(masks,3));
consistence= 0;

for k=2:size(masks,3)
    BW = 255.*masks(:,:,k);
    CC = bwconncomp(BW);
    if(CC.NumObjects > 1)
        CH = bwconvhull(BW,'union',4);
        mask_out(:,:,k)= BW - CH;
        consistence= 1;
    end
end

end