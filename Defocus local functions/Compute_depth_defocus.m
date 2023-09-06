%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to compute the object depth
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [object_depth, object_min , object_max] = Compute_depth_defocus(data,Depths)

object_depth=zeros(size(data.bbox,1),1);
object_min=zeros(size(data.bbox,1),1);

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
        maximum = max(elem);
        minimum = min(elem);
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
        ecart_up=maximum-averages;
        if(data.label(k)=="car" || data.label(k)=="bus" || data.label(k)=="boat" || data.label(k)=="truck" || data.label(k)=="train" || data.label(k)=="airplane")
            if(ecart_up>80)
                ecart_up = ecart_up/2;
            end
        end
%         figure(20)
%         set(fig,'visible','off');
%         h=histogram(elem,'Normalization','probability');
        [N,edges,bin]=histcounts(elem,'Normalization','probability');
        maxim=max(N);
        information = N./maxim;
        number_bin=size(information,2);
        begin = round(averages);
        
        value=0;
%         for i=1:size(h.BinCounts,2)
%             if(h.BinEdges(i)>=begin && value==0)
%                 value=i;
%                 break;
%             end
%         end
        for i=1:size(bin,2)
            if(information(i)== 1.0 && value==0)
                value=i;
                break;
            end
        end

        down=0;
        up=0;

        for i=1:size(bin,2)
            if((value - down)>0)
                if(information(value-down)==0 || information(value-down)>=0.01)
                    down=down+1;
                else
                    break
                end
            else
                break
            end
        end

        for i=1:size(bin,2)
            if((value+up)<number_bin)
                if(information(value+up)==0|| information(value+up)>=0.01)
                    up=up+1;
                else
                    break
                end
            else
                break
            end
        end
        
%         while((information(value-down)==0 && (value - down)>0)||(information(value-down)>=0.01 && (value - down)>0))
%             down=down+1;
%         end
%         while((information(value+up)==0 && (value+up)<number_bin)) || (information(value+up)>=0.01 && (value+up)<number_bin))
%             up=up+1;
%         end

        upper_bound = value + up;
        lower_bound = value - down;
        if(lower_bound>1)
            min_value = edges(lower_bound-1);
        else
            if(lower_bound==0)
                min_value = edges(1);
            else
                min_value = edges(lower_bound);
            end
        end

        if(upper_bound<size(bin,2))
            max_value = edges(upper_bound+1);
        else
            if(upper_bound==0)
                max_value = edges(1);
            else
                max_value = edges(upper_bound);
            end
            
        end
            
%             o=1;
%         if(k==6)
%             figure(20)
%             h=histogram(elem,'Normalization','probability');
%             o=1;
%         end
        object_min(k,1)=min_value;
        object_max(k,1)=max_value;

    end
end