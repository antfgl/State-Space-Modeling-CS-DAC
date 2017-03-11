%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017

clear;
close all;
%%%properties of current steering DAC%%%
N=5; %number of bits
Vdd=2; %supply voltage

I_u=1.2e-6; %unit element current
R_u=1e7; %unit element resistance
C_u=5e-15; %unit element capacity

R_l=100; %load resistance
C_l=100e-13; %load capacity

R_sw=100; %switch resistance
Iu=I_u+Vdd/R_u; %linearized unit elment current

cont=[N,Iu,R_u,C_u,R_l,C_l,R_sw];%save DAC characteristics in a container

f_s=1e8; %sample frequency
T_s=1/f_s; %sample period
t=0:T_s/50:T_s; %calculate 50 support points for the transition between two input codes

%calculate DAC output
[YF YFn XN XT]=auto(cont,t); %compute nodal(XN) and terminal(XT) output voltages for all possible input codewords. Compute the DACs terminal response for  a continous transition (0 - 2^N-1) of the input codewords -> (YF,YFn)

Vpp=reshape(YF,[],1); %concatenate the single output responses in a single vector
Vnn=reshape(YFn,[],1);

tp=linspace(0,(2^N-1)*t(length(t)),(2^N-1)*(length(t))); %time vector for DAC output characteristics
figure(1);
title(['' num2str(N) '-Bit DAC output characteristics '])
hold on;
plot(tp,Vpp,'r');
plot(tp,Vnn,'k');
legend('positive output terminal','negative output terminal')
xlabel('time [s]','FontSize',14) % x-axis label
ylabel('Terminal Output Voltage [V]','FontSize',14) % y-axis label
lsb_start=YF(length(YF(:,1)),1)-YF(1,1);
lsb_end=YF(length(YF(:,1)),length(YF(1,:)))-YF(1,length(YF(1,:)));

%Synthetic CS DAC output
%set the characteristics of the analog input signal
prime=107;
pts=2^8;
f_sig=(prime/pts)*f_s; %calculation of the input signal frequency 
ratio=f_s/f_sig

%calculate DAC output signal
[v_d v_p v_n]=sample(N,f_s,prime,pts,XN,XT,cont);
