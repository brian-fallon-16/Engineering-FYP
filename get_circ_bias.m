function circ_bias = get_circ_bias(data, ground_truth)
[~,n] = size(data);
tmp = abs(angle(sum(exp(1i.*degtorad(data-ground_truth)))));
circ_bias = radtodeg(tmp);
%circ_mean = atan2d(sum(sind(data)),sum(cosd(data)));
end