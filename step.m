%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017

function [Ytp Ytn] = step(ICa,ICb,XN,XT,cont,t)
% step has the purpose to simulate the output of a N-Bit unary weighted DAC
% when jumping from a initial INPUT CODE ICa to a final INPUT CODE ICb.

N=cont(1); %number of bits
CSn=2^N-1; %number of single current sources

u = ones(size(t));

%ICa is the initial state. ICa CSs (current sources) are switched to the
%positive path initially. ICb is the final state. ICb CSs are switched to the positive 
%path when the DAC has settled. To simulate the DAC'S output response when
%propagating to the final state ICb, we need the initial nodal Voltages
%XN(ICa) and XT(ICa). 

%positive terminal
a=zeros(ICb,1); %ICb (+1 terminal voltage) valtage values are needed since ICb CSs will be swited to the positive site. 
a=XN((1:ICb),ICa+1); %write the ICb nodal voltages in a
b=XT(1,ICa+1)'; %write the positive terminal volatge in b

V0p=vertcat(a,b); %adding nodal and terminal voltages to create initial voltage vector

A=ss_matrix_A(ICb,cont);
B=ss_matrix_B_initial(A,cont);
C=zeros(ICb,1)';
C=[C 1];
D=0;
sys = ss(A,B,C,D);
[Y] =lsim(sys, u, t,V0p); 

Ytp=Y;

%negative terminal
c=zeros(CSn-ICb,1); %(CSn-ICb) (+1 terminal voltage) valtage values are needed since (CSn-ICb) CSs will be swited to the negative terminal. 
if ICb<CSn
c=XN(ICb+1:CSn,ICa+1); 
else
c=[];
end
d=XT(2,ICa+1)'; %(CSn-ICa) CSs are switched to the negative terminal, so the initial terminal voltage is found in the (CSn-ICa)+1 row of XT

V0n=vertcat(c,d);

A=ss_matrix_A((CSn-ICb),cont);
B=ss_matrix_B_initial(A,cont);
C=zeros((CSn-ICb),1)';
C=[C 1];
D=0;
sys = ss(A,B,C,D);
[Y] =lsim(sys, u, t,V0n);

Ytn=Y;
