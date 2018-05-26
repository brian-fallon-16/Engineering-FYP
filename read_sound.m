% Clear the work space and close all open figure windows
clear; clear all; close all;

filename_F = 'Z:\FYP\Audio\Recordings From Dome\Front (MS) cropped.wav';
filename_B = 'Z:\FYP\Audio\Recordings From Dome\Back (XY) cropped.wav';
[front,Fs] = audioread(filename_F);
[back,Fs] = audioread(filename_B);

[samples, channels] = size(front);
Lf = front(1:samples,1);
Rf = front(1:samples,2);
Lb = back(1:samples,1);
Rb = back(1:samples,2);

x = 1:samples;

figure('name', 'White noise dome recordings');
subplot(2,2,2)
plot(x/Fs,Lf);
title('Lf','fontsize',14,'fontname','Helvetica');

subplot(2,2,4)
plot(x/Fs,Rf,'m');
title('Rf','fontsize',14,'fontname','Helvetica');

subplot(2,2,1)
plot(x/Fs,Lb,'b');
title('Lb','fontsize',14,'fontname','Helvetica');

subplot(2,2,3)
plot(x/Fs,Rb,'m');
title('Rb','fontsize',14,'fontname','Helvetica');
xlabel('Time','fontsize',14,'fontname','Helvetica');
ylabel('Amplitude','fontsize',14,'fontname','Helvetica');

figure('name', 'My B-Format');
%B-format - note multiplication by 0.25 to average the 4 signals
subplot(3,1,1)
W = 0.25*(Lf+Rf+Lb+Rb);
plot(x/Fs,W,'b');
title('W');

subplot(3,1,2)
X = 0.25*(Lf+Rf-Lb-Rb);
plot(x/Fs,X,'b');
title('X');

subplot(3,1,3)
Y = 0.25*(Lf-Rf+Lb-Rb);
plot(x/Fs,Y,'b');
title('Y');



p1 = sqrt(2).*W;
p = transpose([p1,p1]);
u = transpose([X, Y]);
I = p.*u;
Ix = I(1, 1:end);
Iy = I(2, 1:end);

index=1;
for i=1:Fs/2:samples-(Fs/2)
    xblock = Ix(i:i+(Fs/2)-1);
    %xrms(index) = sqrt((2/Fs)*sum(xblock.^2));
    xrms(index)  = (2/Fs)*sum(xblock);
    
    yblock = Iy(i:i+(Fs/2)-1);
    %yrms(index) = sqrt((2/Fs)*sum(yblock.^2));
    yrms(index)  = (2/Fs)*sum(yblock);
    
    index = index+1;
end;


theta1 = atan2d(yrms, xrms);


filename_W = 'Z:\FYP\Audio\Google B-Format\W.aiff';
filename_X = 'Z:\FYP\Audio\Google B-Format\X.aiff';
filename_Y = 'Z:\FYP\Audio\Google B-Format\Y.aiff';
[W,Fs] = audioread(filename_W);
[X,Fs] = audioread(filename_X);
[Y,Fs] = audioread(filename_Y);

[samples, channels] = size(W);
x = 1:samples;

W_g = W(1:end,1);
X_g = X(1:end,2);
Y_g = Y(1:end,1);

figure('name', 'Google B-Format');
%B-format
subplot(3,1,1)
plot(x/Fs,W_g,'b');
title('W');

subplot(3,1,2)
plot(x/Fs,X_g,'b');
title('X');

subplot(3,1,3)
plot(x/Fs,Y_g,'b');
title('Y');

p1 = sqrt(2).*W_g;
p = transpose([p1,p1]);
u = transpose([X_g, Y_g]);
I = p.*u;
Ix = I(1, 1:end);
Iy = I(2, 1:end);

index=1;
for i=1:Fs/2:samples-(Fs/2)
    xblock = Ix(i:i+(Fs/2)-1);
    %xrms(index) = sqrt((2/Fs)*sum(xblock.^2));
    xrms(index)  = (2/Fs)*sum(xblock);
    
    yblock = Iy(i:i+(Fs/2)-1);
    %yrms(index) = sqrt((2/Fs)*sum(yblock.^2));
    yrms(index)  = (2/Fs)*sum(yblock);
    
    index = index+1;
end;


theta2 = atan2d(yrms, xrms);
x1 = 1:0.5:60.5;
x2 = 1:0.5:66;
figure(5);plot(x1,theta1, 'r', x2 ,theta2, 'b', 'LineWidth', 2);
title('Angle of incidence of wideband noise on H2n');
legend('My B-Format', 'Google B-Format');
grid on
grid minor
