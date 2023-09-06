%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to sort the objects depth
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bboxes, labels, masks, angle, len, activation,object_depth,object_var,superclass_s] = sorting_depth(data, len, angle, activation,object_depth, object_var,I,superclass)

%[E,index_up] = sortrows(object_depth,'ascend');
[F,index_down] = sortrows(object_depth,'descend');

lens=len;
angles=angle;
activations = activation;
object_vars =object_var;

angle=zeros(size(data.bbox,1),1);
len=zeros(size(data.bbox,1),1);
activation=zeros(size(data.bbox,1),1);

bboxes=zeros(size(data.bbox,1),4);
masks=zeros(size(I,1),size(I,2),size(data.bbox,1));

object_var=zeros(size(data.bbox,1),1);

object_depth=[];
% superclass =[];


for i=1:size(data.bbox,1)
    bboxes(i,:)=data.bbox(index_down(i),:);
    labels(i)=data.label(index_down(i));
    masks(:,:,i)=data.masks(:,:,index_down(i));
    angle(i)= angles(index_down(i));
    len(i)= lens(index_down(i));
    object_var(i)= object_vars(index_down(i));
    activation(i) = activations(index_down(i));
    superclass_s(i).value = superclass(index_down(i)).value;
end

object_depth = F;


end