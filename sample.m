%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017
 
function [V_d V_p V_n] = sample(N,f_s,prime,pts,XN,XT,cont)
%f_s=1e10; %sample frequency f_s of the test signal and sample frequency in testbench_NBit_DAC for the calulation of the matrix XN and XT have to be the same

T_s=1/f_s; %sample periode for both input signal and DAC
simtime=pts/f_s; %calculate the absolute duration of the input signal

t=0:T_s:simtime; %length(t) is the total number of samples of the input vector = (pts+1)thermometer
t2=0:T_s/100:simtime; %t2 is just used to draw a "pefect" input signal
t_step=0:T_s/50:T_s; %calculate 50 support points for the transition between two input codes

f_sig=(prime/pts)*f_s; %analog input signal frequency

%generating the DAC input signal
amp=(2^N-1)/2; %set the amplitude of the sinusoidal signal so that it fits the maximum input codeword of the DAC
x = amp*(1+sin(2*pi*f_sig*t)); %add offset to the sinusoidal signal so there are only posotive values
input=round(x); %quantize the sampled input values. Quantized values correspond to thermometer-coded DAC input codewords 
x2=amp*(1+sin(2*pi*f_sig*t2)); %calculate the perfect analog input signal

%plotting the input conditions
 figure(2)
 title('Input Signal; Sampled Signal; DAC Input Codewords')
 hold on
 plot(t2,x2,'c');
 plot(t,x,'b');
 plot(t,input,'r*')
 legend('analog input signal','sampled signal','quantised DAC input codewords')
 xlabel('time [s]') % x-axis label
 ylabel('Dezimal input code') % y-axis label
 hold off

%calculation of the DACs responnse to a series of input codewords using the
%step function
out_p=zeros(length(t_step),length(input));
out_n=zeros(length(t_step),length(input));
for i=1:length(input)
   if i>1
   [Y1 Y2]=step(input(i-1),input(i),XN,XT,cont,t_step); 
   out_p(:,i)=Y1; %save each DAC step output to new row in the matrix
   out_n(:,i)=Y2;
   end
end

V_p=reshape(out_p,[],1); %concatenate the single output responses in a single vector 
V_n=reshape(out_n,[],1);
tp=0:simtime/(length(t_step)*(length(x))-1):simtime;

V_d=V_p-V_n;
 figure(3)
 title('DAC output')
 plot(tp,V_d,'r')
 legend('DAC output voltage')
 xlabel('time [s]') % x-axis label
 ylabel('Differential output voltage [V]') 