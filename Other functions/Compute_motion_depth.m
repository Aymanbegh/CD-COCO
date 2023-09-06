function [len, angle,activation] = Compute_motion_depth(data,scene,scene_context,superclass,object_depth, object_var)
    activation = zeros(size(data.label,1),1);
    len = zeros(size(data.label,1),1);
    angle = zeros(size(data.label,1),1);
    for i=1:size(data.label,1)
        %% Scene other
        if(scene_context =="other" || scene_context =="sport")
            if(data.label(i)~="person")
                if(superclass(i).value=="animal")
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
%                     len(i) = Compute_len_motion(scene, scene_context, data.label(i), data.bboxe(i,:),superclass(i),angle(i),object_depth(i), object_var(i));
                    len(i)=15;
                    activation(i)=1;
                end
                if(superclass(i).value=="vehicle")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=40;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<1.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

                if(superclass(i).value=="vehicle_h")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<0.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

            else
                props1 = regionprops(data.masks(:,:,i), 'Orientation');
                ang=props1.Orientation;
                if((ang>15 && ang<90) || (ang<-15 && ang>-90))
                    if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
    %                     props1 = regionprops(data.masks(:,:,i), 'Orientation');
    %                     if(props1<90)
                        if((ang>15 && ang<90))
                            angle(i)=randi([-15 15],1);
                        end
                        if((ang<-15 && ang>-90))
                            angle(i)=randi([165 195],1);
                        end
                        len(i)=15;
                        activation(i)=1;
                    else
                        activation(i)=0;
                    end
                else
                    if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
    %                     props1 = regionprops(data.masks(:,:,i), 'Orientation');
    %                     if(props1<90)
                        if((ang<15 && ang>-15))
                            angle(i)=randi([80 100],1);
                        end
%                         if((ang>-15 && ang>-90))
%                             angle(i)=randi([80 100],1);
%                         end
                        len(i)=15;
                        activation(i)=1;
                    else
                        activation(i)=0;
                    end

                end
                
            end
         
        end

        %% Scene skate
        if(scene_context =="skate") 
                if(superclass(i).value=="animal")
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=15;
                    activation(i)=1;
                end
                if(superclass(i).value=="vehicle")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)>1.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

                if(superclass(i).value=="vehicle_h")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<0.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

            if(data.label(i)=="person" || data.label(i)=="skateboard")
                if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
%                     if(props1<90)
                    angle(i)=props1.Orientation;
                    len(i)=15;
                    activation(i)=1;
                else
                    activation(i)=0;
                end               
            end         
        end


        %% Scene ski
        if(scene_context =="ski") 
                if(superclass(i).value=="animal")
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=5;
                    activation(i)=1;
                end
                if(superclass(i).value=="vehicle")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)>1.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

                if(superclass(i).value=="vehicle_h")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<0.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

            if(data.label(i)=="person" || data.label(i)=="snowboard" || data.label(i)=="skis")
                if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
%                     if(props1<90)
                    angle(i)=props1.Orientation;
                    len(i)=10;
                    activation(i)=1;
                else
                    activation(i)=0;
                end               
            end         
        end

        %% Scene skate
        if(scene_context =="surf") 
                if(superclass(i).value=="animal")
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=5;
                    activation(i)=1;
                end
                if(superclass(i).value=="vehicle")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)>1.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

                if(superclass(i).value=="vehicle_h")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<0.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

            if(data.label(i)=="person" || data.label(i)=="surfboard")
                if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
%                     if(props1<90)
                    angle(i)=props1.Orientation;
                    len(i)=10;
                    activation(i)=1;
                else
                    activation(i)=0;
                end               
            end         
        end


        %% Scene riding
        if(scene_context =="riding") 
                if(superclass(i).value=="animal")
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=15;
                    activation(i)=1;
                end
                if(superclass(i).value=="vehicle")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)>1.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

                if(superclass(i).value=="vehicle_h")       
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
                    angle(i)=props1.Orientation;
                    len(i)=25;
                    activation(i)=1;
                    if(data.label(i)~="airplane")
                        if(data.bbox(i,3)<0.5*data.bbox(i,4))
                            activation(i)=0;
                        end
                        if((angle(i)>60)&&(angle(i)<120))
                            activation(i)=0;
                        end
                        if((angle(i)>240)&&(angle(i)<300))
                            activation(i)=0;
                        end
                        if((angle(i)<-60)&&(angle(i)>-120))
                            activation(i)=0;
                        end

                    end
                end

            if(data.label(i)=="person")
                if((sqrt(data.bbox(i,3)^2+data.bbox(i,4)^2))>50)
                    props1 = regionprops(data.masks(:,:,i), 'Orientation');
%                     if(props1<90)
                    angle(i)=props1.Orientation;
                    len(i)=10;
                    activation(i)=1;
                else
                    activation(i)=0;
                end               
            end         
        end




%% End
    end

    len = Compute_len_motion(scene, scene_context, data, superclass,angle,object_depth, object_var);


end