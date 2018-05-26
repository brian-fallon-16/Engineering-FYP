% Clear the work space and close all open figure windows
clear; clear all; close all;

% Read in Front (MS) and Back (XY) audio files along with sampling rate and
% number of channels
filename_F = 'Z:\FYP\Audio\Recordings From Dome\Front (MS) cropped.wav';
filename_B = 'Z:\FYP\Audio\Recordings From Dome\Back (XY) cropped.wav';

[front,Fs] = audioread(filename_F);
[back,Fs] = audioread(filename_B);
[samples, channels] = size(front);
x = 1:samples;

% Separate Left and Right channels of both back and front (note the xY
% recording is back-to-front in 4-channel H2n recordings)
Lf = front(1:end,1);
Rf = front(1:end,2);
Lb = back(1:end,1);
Rb = back(1:end,2);

% Display Lf, Rf, Lb and Rb
figure('name', 'White noise dome recordings');
subplot(2,2,2)
plot(x/Fs,Lf,'m');
title('Lf','fontsize',14,'fontname','Helvetica');

subplot(2,2,4)
plot(x/Fs,Rf,'m');
title('Rf','fontsize',14,'fontname','Helvetica');

subplot(2,2,1)
plot(x/Fs,Lb,'b');
title('Lb','fontsize',14,'fontname','Helvetica');

subplot(2,2,3)
plot(x/Fs,Rb,'b');
title('Rb','fontsize',14,'fontname','Helvetica');
xlabel('Time','fontsize',14,'fontname','Helvetica');
ylabel('Amplitude','fontsize',14,'fontname','Helvetica');

% B-format encoding - W scaled by 1/sqrt(2) (i.e. attenuated by-3db)
W = (Lf+Rf+(sqrt(2).*(Lb+Rb)))/(2*(sqrt(2)+2));
X = (Lf+Rf-Lb-Rb)/(sqrt(2)+2);
Y_1 = (Lf-Rf)/2;                    % MS
Y_2 = (Lf-Rf+Lb-Rb)/(2+sqrt(2));    % Centre
Y_3 = (Lb-Rb)/sqrt(2);              % XY

% Display B-format encoding
figure('name', 'B-Format');
subplot(3,1,1)
plot(x/Fs,W,'b');
title('W');

subplot(3,1,2)
plot(x/Fs,X,'b');
title('X');

subplot(3,1,3)
plot(x/Fs,Y_2,'b');
title('Y');

% getting intensity vectors, comparing directionality results from using
% different Y-components

% this is effectively the number of samples over which the intensity vector
% is assumed steady-state
resolution = 1000;

[Iy_1, Ix] = get_intensity_vector(W, X, Y_1, resolution);
Y1_angle_of_incidence = atan2d(Iy_1, Ix);

[Iy_2, ~] = get_intensity_vector(W, X, Y_2, resolution);
Y2_angle_of_incidence = atan2d(Iy_2, Ix);

[Iy_3, ~] = get_intensity_vector(W, X, Y_3, resolution);
Y3_angle_of_incidence = atan2d(Iy_3, Ix);


figure(3);plot(Y1_angle_of_incidence, 'g', 'LineWidth', 1);
hold on
plot(Y2_angle_of_incidence, 'r', 'LineWidth', 1);
plot(Y3_angle_of_incidence, 'b', 'LineWidth', 1);
hold off
title('Angle of incidence of wideband noise on H2n');
legend('MS-Centred Figure-of-Eight', 'Centred Figure-of-Eight', 'XY-Centred Figure-of-Eight');
xlabel('Time (samples)');
ylabel('Angle of Incidence of Noise (degrees)');
grid on
grid minor

% Quick test to show that scaling W makes no difference in directionality
% estimates



% plotting the gradient and then sampling the angle of incidence results to
% plot a histogram to show distribution

Y1_bursts = extract_bursts(Y1_angle_of_incidence, resolution);
Y2_bursts = extract_bursts(Y2_angle_of_incidence, resolution);
Y3_bursts = extract_bursts(Y3_angle_of_incidence, resolution);

LUT = cell(8,1);

LUT{1,1} = 'Theta = 0';
LUT{2,1} = 'Theta = 45';
LUT{3,1} = 'Theta = 90';
LUT{4,1} = 'Theta = 135';
LUT{5,1} = 'Theta = 180';
LUT{6,1} = 'Theta = -135';
LUT{7,1} = 'Theta = -90';
LUT{8,1} = 'Theta = -45';

angles = [0 45 90 135 180 -135 -90 -45];

nbins = 40;

Y1_means = [];
Y1_stddevs = [];
Y1_bias = [];
Y2_means = [];
Y2_stddevs = [];
Y2_bias = [];
Y3_means = [];
Y3_stddevs = [];
Y3_bias = [];

% display histograms for each pink noise burst
for i=1:8
    
    Y1_means = [Y1_means, get_circ_mean(Y1_bursts{i,1})];
    Y1_stddevs = [Y1_stddevs, get_circ_stdev(Y1_bursts{i,1},angles(1,i))];
    Y1_bias = [Y1_bias, get_circ_bias(Y1_bursts{i,1},angles(1,i))];
    
    figure('name',LUT{i,1});
    subplot(2,2,1);
    hist(Y1_bursts{i,1},nbins);
    hold on
    plot([Y1_means(1,i),Y1_means(1,i)],ylim,'r--','LineWidth',2);
    plot([angles(1,i),angles(1,i)],ylim,'g--','LineWidth',2);
    hold off
    title('MS');
    xlabel('Angle (degrees)');
    
    Y2_means = [Y2_means, get_circ_mean(Y2_bursts{i,1})];
    Y2_stddevs = [Y2_stddevs, get_circ_stdev(Y2_bursts{i,1},angles(1,i))];
    Y2_bias = [Y2_bias, get_circ_bias(Y2_bursts{i,1},angles(1,i))];

    subplot(2,2,2);
    hist(Y2_bursts{i,1},nbins);
    hold on
    plot([Y2_means(1,i),Y2_means(1,i)],ylim,'r--','LineWidth',2);
    plot([angles(1,i),angles(1,i)],ylim,'g--','LineWidth',2);
    hold off
    title('Centred');
    xlabel('Angle (degrees)');
    
    Y3_means = [Y3_means, get_circ_mean(Y3_bursts{i,1})];
    Y3_stddevs = [Y3_stddevs, get_circ_stdev(Y3_bursts{i,1},angles(1,i))];
    Y3_bias = [Y3_bias, get_circ_bias(Y3_bursts{i,1},angles(1,i))];
    
    subplot(2,2,3);
    hist(Y3_bursts{i,1},nbins);
    hold on
    h1 = plot([Y3_means(1,i),Y3_means(1,i)],ylim,'r--','LineWidth',2);
    h2 = plot([angles(1,i),angles(1,i)],ylim,'g--','LineWidth',2);
    hold off
    title('XY');
    xlabel('Angle (degrees)');
    legend([h1,h2],{'Recorded Mean Angle of Incidence', 'True Angle of Incidence'});
    
    %subplot(2,2,4);

end

mean(Y1_stddevs);
mean(Y2_stddevs);
mean(Y3_stddevs);

% measure accuracy (distance between means and actual angles of incidence)
% and precision (standard deviation)

% Graph the Bias
tmp = vertcat(Y1_bias,Y2_bias);
bias = vertcat(tmp, Y3_bias);
figure(13);
subplot(2,1,1);
bar(transpose(bias));
legend('MS-Centred Figure-of-Eight', 'Centred Figure-of-Eight', 'XY-Centred Figure-of-Eight');
xlabel('Angle of Incidence (degrees)');
ylabel('Bias (degrees)');
set(gca,'xticklabel',angles);
grid on
grid minor

% Graph the standard deviation
subplot(2,1,2);
tmp = vertcat(Y1_stddevs,Y2_stddevs);
sdev = vertcat(tmp, Y3_stddevs);
figure(13); bar(transpose(sdev));
legend('MS-Centred Figure-of-Eight', 'Centred Figure-of-Eight', 'XY-Centred Figure-of-Eight');
xlabel('Angle of Incidence (degrees)');
ylabel('Standard Deviation (degrees)');
set(gca,'xticklabel',angles);
grid on
grid minor

% overall deviations of the microphones
Y1_deviation = sum(abs(Y1_bias))/8
Y2_deviation = sum(abs(Y2_bias))/8
Y3_deviation = sum(abs(Y3_bias))/8


