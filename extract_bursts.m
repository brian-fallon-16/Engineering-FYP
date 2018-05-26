function bursts = extract_bursts(angle_of_incidence, resolution)
    Q_step = 120; %at 120, change back to 30
    f = gradient(angle_of_incidence);
    f = Q_step*round(f/Q_step);
    figure(5);plot(f);
    
    %threshold = 40000/resolution; %change back to this!!
    threshold = 12*5;
    index = 1;
    run_length = 0;
    bursts = cell(8,1);
    tmp = [];

    [~,length] = size(angle_of_incidence);

    for i=1: length

        curr = f(i);
        if(curr ~= 0 || i == length-1)
            if(run_length>threshold)
                bursts{index,1} = tmp;
                index = index+1;
            end
            tmp = [];
            run_length = 0;
        end

        if(curr==0)
            run_length = run_length+1;
            tmp = [tmp, angle_of_incidence(i)];
        end
    end
end