function [y_avg, x_avg] = get_intensity_vector(W, X, Y, resolution)
    [samples, ~] = size(W);
    
    % Multiply W by root 2 to get back unity gain - assuming W has been
    % attenuated by -3db in encoding
    p = sqrt(2).*W;
    p_ = transpose([p,p]);
    u = transpose([X, Y]);
    I = p_.*u;
    Ix = I(1, 1:end);
    Iy = I(2, 1:end);

    % average the signal out in accordance with the specified resolution
    index=1;
    for i=1:resolution:samples-(resolution)
        xblock = Ix(i:i+(resolution)-1);
        xavg(index)  = (1/resolution)*sum(xblock);

        yblock = Iy(i:i+(resolution)-1);
        yavg(index)  = (1/resolution)*sum(yblock);

        index = index+1;
    end;
    
    y_avg = yavg;
    x_avg = xavg;
    
    
end