%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to compute the average depth of each object
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [object_depth, object_var] = Compute_depth(data,Depths)

object_depth=zeros(size(data.bbox,1),1);
object_var=zeros(size(data.bbox,1),1);

    for k=1:size(data.bbox,1)
        cpt=1;
        elem=[];
        Elems=[];
        for i=1:size(Depths,1)
            for j=1:size(Depths,2)
                if(data.masks(i,j,k)==1)
                    elem(cpt)=double(Depths(i,j));
                    cpt=cpt+1;                    
                end
            end
        end
%         maximum = max(elem);
%         minimum = min(elem);
        average = mean(elem);
        medians = median(elem);
        variance = var(elem);
        Variances = variance/average;
        if(Variances<2)
            Variances=2;
        end
        cpt=1;
%         cpt1=1;
        for l=1:size(elem,2)
            if((elem(l)>=(average - Variances)) && (elem(l)<=(average + Variances)))
                Elems(cpt)=elem(l);
                cpt=cpt+1;
            end

%             if((elem(l)>=70) && (elem(l)<=230))
%                 Elems1(cpt1)=elem(l);
%                 cpt1=cpt1+1;
%             end
        end
        averages = mean(Elems);
        Vars = var(Elems)/averages;
%         averages1 = mean(Elems1);
        object_depth(k,1)=averages;
        object_var(k,1)=Vars;
    end
end