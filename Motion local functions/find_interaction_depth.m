%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to find the intecation between objects according to their depth
%% Copyright (c) 2023, AYMAN BEGHDADI
%% All rights reserved.
%% Author: Ayman Beghdadi
%% Email: aymanaymar.beghdadi@univ-evry.fr
%% Date: January 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [len, angle, interaction,activation] = find_interaction_depth(scene,scene_context,superclass,activation,labels,mask,bboxe,len,angle,object_depth, object_var)
interaction = zeros(length(activation),2);
if(scene_context=="other" || scene_context=="sport")
    for i=1:size(angle,1)
        if(superclass(i).value=="accessory" || superclass(i).value=="tool" || superclass(i).value=="sport"  || superclass(i).value=="food" || superclass(i).value=="kitchen")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="person")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.2 || ((abs(object_depth(j)-object_depth(i))<0.1*object_depth(i))&& overlapRatio>0.01) )
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
                if(labels(j)=="dog")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.2 || ((abs(object_depth(j)-object_depth(i))<0.1*object_depth(i))&& overlapRatio>0.01) )
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end

        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(superclass(j).value=="vehicle_h")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.2)
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
                if(labels(j)=="bus" || labels(j)=="boat" || labels(j)=="car" || labels(j)=="train" || labels(j)=="truck")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:),'Min');
                    if(overlapRatio>0.7 && ((object_depth(i)<(object_depth(j)+0.1*object_depth(i)))&&(object_depth(i)>(object_depth(j)-0.1*object_depth(i)))))
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end
    end
end

if(scene_context=="skate")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="skateboard")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:),'Min');
                    if(overlapRatio>0.2 && ((object_depth(i)<(object_depth(j)+0.2*object_depth(i)))&&(object_depth(i)>(object_depth(j)-0.2*object_depth(i)))))
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end
    end
end

if(scene_context=="ski")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="skis" || labels(j)=="snowboard")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.01 || ((object_depth(i)<(object_depth(j)+0.1*object_depth(i)))&&(object_depth(i)>(object_depth(j)-0.1*object_depth(i)))))
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end
    end
end


if(scene_context=="surf")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="surfboard")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.05 || ((object_depth(i)<(object_depth(j)+0.1*object_depth(i)))&&(object_depth(i)>(object_depth(j)-0.1*object_depth(i)))))
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end
    end
end

if(scene_context=="riding")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="horse" || labels(j)=="elephant")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.1)
                        interaction(i,1)=i;
                        interaction(i,2)=j;
                    end
                end
            end 
        end
    end
end


for i=1:length(activation)
    for j=1:length(activation)
        if(interaction(i,1)==interaction(j,2))
            interaction(j,2)=interaction(i,2);
        end
    end
end

for i=1:length(activation)
    if(interaction(i,1)~=0)
        if(activation(interaction(i,2))==0)
            len(i)=0;
            angle(i)=0;
            activation(i)=0;
        else
            len(i)=len(interaction(i,2));
            angle(i)=angle(interaction(i,2));
            activation(i)=1;
        end
%             len(i)=len(interaction(i,2));
%             angle(i)=angle(interaction(i,2));
    end
end

% for i=1:length(activation)
%     if(superclass(i).value=="vehicle_h")
%         if(interaction(interaction(i,2),1)==0)
%             activation(i)=0;
%         end
%     end
% end
% && activation(interaction(j,2))==1

% for i=1:length(activation)
%     goal=0;
%     j=1;
%     if(superclass(i).value=="vehicle_h")
%         while(j<=length(activation) && goal==0)
%             if(interaction(j,2)==i )
%                 activation(i)=1;
%                 goal=1;
%                 continue;
%             else
%                 activation(i)=0;
%             end
%             j=j+1;
%         end
%     end
% end



end