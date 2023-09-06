function len = Compute_len_motion(scene, scene_context, data,superclass,angle,object_depth, object_var)

person_in = 7;
person_out = 25;
airplane = [80 900];
train =[50 100];
car =[30 130];
motorcycle =[30 130];
truck = [30 90];
bus = [30 90];
bicycle =[10 50];
boat = [10 30];
horse = [20 90];
zebra = [20 65];
dog = [10 50];
girafe = [10 60];
bird = [10 100];
cat =[10 50];
bear =[10 50];
sheep =[10 24];
elephant = [10 40];
cow = [1 6];
ski= [30 60];
skateboard =[10 20];
surf =[10 30];

height=size(data.masks,1);
width=size(data.masks,2);

mu = 0; 
sd = 1; 
inverse = 1/(2*pi*sd);
coeff=0.304;
coeff_a=0.039;
% y = 1/(2*pi*sd)*exp(-(x-mu).^2/(2*sd^2));

len = zeros(size(data.bbox,1),1);

for i=1:size(data.bbox,1)
   
    ratio_h = data.bbox(i,4)/height;
    ratio_w = data.bbox(i,3)/width;
    
    if(data.label(i)=="person")
        if(abs(angle(i))>90)
            angle(i)=abs(180-abs(angle(i)));
        end

        abs_angle = abs(90 - abs(angle(i)));
        if(abs_angle<45)
            ratio_angle = abs_angle/45;
        else
            ratio_angle = 0;
        end

        if(scene_context=="sport")
            if(scene=="indoor")
                interval_speed = [5 (person_in - ((person_in-7)*(1-ratio_angle)))];
            end       
            if(scene=="outdoor")
                if(angle(i)<45 && angle(i)>-45)
                    ratio_angle = abs(45-angle(i))/45;
                end
                interval_speed = [5 (person_out - ((person_out-9)*(1-ratio_angle)))];
            end
        else    
            if(scene=="indoor")
                interval_speed = [2 (person_in - ((person_in-4)*(1-ratio_angle)))];
            end       
            if(scene=="outdoor")
                interval_speed = [2 (person_out - ((person_out-6)*(1-ratio_angle)))];
            end
        end

        

        speed = randi([int8(interval_speed(1)) int8(interval_speed(2))],1);

        value=(1/(2*pi*sd)*exp(-((1-ratio_h)).^2/(2*sd^2)))/inverse;
        motion = speed*coeff;
        len(i) = value *motion;   

    end
    if(data.label(i)=="bus" || data.label(i)=="truck")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([bus(1) bus(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="car" || data.label(i)=="motorcycle")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([car(1) car(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="train")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([train(1) train(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="boat" || data.label(i)=="surfboard")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([boat(1) boat(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="bicycle")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([bicycle(1) bicycle(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="horse")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([horse(1) horse(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="zebra")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([zebra(1) zebra(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="dog" || data.label(i)=="cat" || data.label(i)=="bear")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([dog(1) dog(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="girafe")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([girafe(1) girafe(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="bird")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([bird(1) bird(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="sheep")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([sheep(1) sheep(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="elephant")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([elephant(1) elephant(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="cow")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([cow(1) cow(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="skateboard")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([skateboard(1) skateboard(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end
    if(data.label(i)=="skis" || data.label(i)=="snowboard")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_w)).^2/(2*sd^2)))/inverse;
        speed = randi([ski(1) ski(2)],1);
        motion = speed *coeff;
        len(i) = value *motion;      
    end

    if(data.label(i)=="airplane")   
        value=(1/(2*pi*sd)*exp(-((1-ratio_h)).^2/(2*sd^2)))/inverse;
        speed = randi([airplane(1) airplane(2)],1);
        motion = (speed *coeff_a)+8;
        len(i) = value *motion;      
    end

  

end


end