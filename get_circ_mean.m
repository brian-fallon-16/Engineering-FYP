function circ_mean = get_circ_mean(data)
[~,n] = size(data);
tmp = angle(sum((1/n).*exp(1i.*degtorad(data))));
circ_mean = radtodeg(tmp);
%circ_mean = atan2d(sum(sind(data)),sum(cosd(data)));
end