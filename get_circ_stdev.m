function circ_stdev = get_circ_stdev(data, ground_truth)
[~,n] = size(data);
tmp = (2*(1-((1/n)*abs(sum(exp(1i.*degtorad(data-ground_truth)))))))^0.5;
circ_stdev = radtodeg(tmp);

end