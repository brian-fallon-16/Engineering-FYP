% Clear the work space and close all open figure windows
clear; clear all; close all;

%----------------------------------------------------------------------------------%
%-------------------------------------PINK NOISE-----------------------------------%
%----------------------------------------------------------------------------------%

% Read in Front (MS) and Back (XY) audio files along with sampling rate and
% number of channels for 5.1 SURROUND SYSTEM
filename_F = 'Z:\FYP\Audio\Pink Noise\51-PN-MS.wav';
filename_B = 'Z:\FYP\Audio\Pink Noise\51-PN-XY.wav';

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

[W_51,X_51,Y_51] = A2Bformat(Lf,Rf,Lb,Rb);


% FOR SOUNDBAR
filename_F = 'Z:\FYP\Audio\Pink Noise\SB-PN-MS.wav';
filename_B = 'Z:\FYP\Audio\Pink Noise\SB-PN-XY.wav';

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

[W_SB,X_SB,Y_SB] = A2Bformat(Lf,Rf,Lb,Rb);

% getting intensity vectors, comparing directionality results from using
% different Y-components

% this is effectively the number of samples over which the signal is
% assumed steady-state
resolution = Fs/30;

[Iy_51, Ix_51] = get_intensity_vector(W_51, X_51, Y_51, resolution);
angle_of_incidence_51 = atan2d(Iy_51, Ix_51);

[Iy_SB, Ix_SB] = get_intensity_vector(W_SB, X_SB, Y_SB, resolution);
angle_of_incidence_SB = atan2d(Iy_SB, Ix_SB);

figure(4);plot(angle_of_incidence_51, 'b', 'LineWidth', 2);
hold on
plot(angle_of_incidence_SB, 'r', 'LineWidth', 2);
hold off
title('Pink Noise');
legend('5.1 Surround', 'Soundbar');
xlabel('time (samples)')
ylabel('Angle of Incidence (degrees)');

bursts_51 = extract_bursts(angle_of_incidence_51, resolution);
bursts_SB = extract_bursts(angle_of_incidence_SB, resolution);

bursts_51{5,1} = bursts_51{5,1}(15:end);
angles = [0 64 -66 135 -138];

nbins = 40;

LUT = cell(5,1);

LUT{1,1} = 'Theta = 0 (C)';
LUT{2,1} = 'Theta = 64 (LF)';
LUT{3,1} = 'Theta = -66 (RF)';
LUT{4,1} = 'Theta = 135 (LS)';
LUT{5,1} = 'Theta = -138 (RS)';

means_51 = [];
stddevs_51 = [];
bias_51 = [];
means_SB = [];
stddevs_SB = [];
bias_SB = [];

% display histograms for each pink noise burst
for i=1:5
    
    means_51 = [means_51, get_circ_mean(bursts_51{i,1})];
    stddevs_51 = [stddevs_51, get_circ_stdev(bursts_51{i,1},angles(1,i))];
    bias_51 = [bias_51, get_circ_bias(bursts_51{i,1},angles(1,i))];
    
    figure('name',LUT{i,1});
    subplot(2,1,1);
    hist(bursts_51{i,1},nbins);
    hold on
    plot([means_51(1,i),means_51(1,i)],ylim,'r--','LineWidth',2);
    plot([angles(1,i),angles(1,i)],ylim,'g--','LineWidth',2);
    hold off
    title('5.1 Surround Sound');
    xlabel('Angle (degrees)');
    
    means_SB = [means_SB, get_circ_mean(bursts_SB{i,1})];
    stddevs_SB = [stddevs_SB, get_circ_stdev(bursts_SB{i,1},angles(1,i))];
    bias_SB = [bias_SB, get_circ_bias(bursts_SB{i,1},angles(1,i))];

    subplot(2,1,2);
    hist(bursts_SB{i,1},nbins);
    hold on
    plot([means_SB(1,i),means_SB(1,i)],ylim,'r--','LineWidth',2);
    plot([angles(1,i),angles(1,i)],ylim,'g--','LineWidth',2);
    hold off
    title('Yamaha YSP-2500');
    xlabel('Angle (degrees)');

end
deviation_51 = sum(abs(bias_51))/5
deviation_SB = sum(abs(bias_SB))/5

% Graph the Bias
bias = vertcat(bias_51, bias_SB);
figure(13);
subplot(2,1,1);
bar(transpose(bias));
legend('5.1 System', 'Yamaha YSP-2500');
xlabel('Angle of Incidence (degrees)');
ylabel('Bias (degrees)');
set(gca,'xticklabel',angles);
grid on
grid minor

% Graph the standard deviation
subplot(2,1,2);
sdev = vertcat(stddevs_51, stddevs_SB);
figure(13); bar(transpose(sdev));
legend('5.1 System', 'Yamaha YSP-2500');
xlabel('Angle of Incidence (degrees)');
ylabel('Standard Deviation (degrees)');
set(gca,'xticklabel',angles);
grid on
grid minor

%{
%----------------------------------------------------------------------------------%
%----------------------------------------SPEECH------------------------------------%
%----------------------------------------------------------------------------------%
% Read in Front (MS) and Back (XY) audio files along with sampling rate and
% number of channels for 5.1 SURROUND SYSTEM
filename_F = 'Z:\FYP\Audio\Speech\51-Speech-MS.wav';
filename_B = 'Z:\FYP\Audio\Speech\51-Speech-XY.wav';

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

[W_51,X_51,Y_51] = A2Bformat(Lf,Rf,Lb,Rb);

% FOR SOUNDBAR
filename_F = 'Z:\FYP\Audio\Speech\SB-Speech-MS.wav';
filename_B = 'Z:\FYP\Audio\Speech\SB-Speech-XY.wav';

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

[W_SB,X_SB,Y_SB] = A2Bformat(Lf,Rf,Lb,Rb);

% getting intensity vectors, comparing directionality results from using
% different Y-components

% this is effectively the number of samples over which the signal is
% assumed steady-state
resolution = Fs/4;

[Iy_51, Ix_51] = get_intensity_vector(W_51, X_51, Y_51, resolution);
angle_of_incidence_51 = atan2d(Iy_51, Ix_51);

[Iy_SB, Ix_SB] = get_intensity_vector(W_SB, X_SB, Y_SB, resolution);
angle_of_incidence_SB = atan2d(Iy_SB, Ix_SB);

figure(2);plot(angle_of_incidence_51, 'b', 'LineWidth', 1);
hold on
plot(angle_of_incidence_SB, 'r', 'LineWidth', 1);
hold off
title('Speech');
legend('5.1 Surround', 'Soundbar');
xlabel('time (samples)')
ylabel('Angle of Incidence (degrees)');
%}