function [len, angle, interaction,activation] = find_interaction1(scene,superclass,activation,labels,mask,bboxe,len,angle)
interaction = zeros(length(activation),2);
if(scene=="other")
    for i=1:size(angle,1)
        if(superclass(i).value=="accessory" || superclass(i).value=="tool" || superclass(i).value=="sport"  || superclass(i).value=="food" || superclass(i).value=="kitchen")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="person")
                    overlapRatio = bboxOverlapRatio(bboxe(i,:),bboxe(j,:));
                    if(overlapRatio>0.2)
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
            end 
        end
    end
end

if(scene=="skate")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="skateboard")
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

if(scene=="ski")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="skis" || labels(j)=="snowboard")
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


if(scene=="surf")
    for i=1:size(angle,1)
        if(labels(i)=="person")
            overlapRatio = 0;
            for j=1:size(angle,1)
                if(labels(j)=="surfboard")
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

if(scene=="riding")
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