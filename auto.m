%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017

function [YF YFn XN XT] = auto(cont,t)
%extraction of variables in the cont vaector
N=cont(1);
Iu=cont(2);
R_u=cont(3);
C_u=cont(4);
R_l=cont(5);
C_l=cont(6);
R_sw=cont(7);

CSn=(2^N)-1; %total number of current sources
Z=2^N; %total number of possible system states

%calculation of initial conditions
R_swl=((R_sw/CSn)+R_l); %auxilliary variable
V_csx=Iu*(CSn/(1+(R_swl/R_u)*CSn))*R_swl; % nodal voltage of the current sources for all sources steering on one output terminal
Vn_init=Iu*(CSn/(1+(R_swl/R_u)*CSn))*R_l; %initial output voltage for all sources on the neg path

Vn0=zeros(CSn,1); %setting the initial nodal voltages for all sources steering on one output terminal
Vn0(:)=V_csx; 

XN=zeros(CSn,Z); %XN will contain all nodal voltages for all possible input values.
XN(:,1)=Vn0; %the first k entries of a row contain the nodal voltages for the CSs contributing to the pos path.
             %the entries (k+1) to (CSn-k) of the row contain the nodal voltages for the CSs contributing to the neg path.

XT=zeros(2,Z); %XT will contain the voltages at both (pos and neg) output terminals for all input codes 
XT(:,1)=[0 Vn_init]';

YF=zeros(length(t),CSn); %output values postivie terminal all possible input values
YFn=zeros(length(t),CSn); %output values negative terminal all possible input values
 
u = ones(size(t));

for k=1:CSn
    %positive output node
    %select the nodal voltages in dependance to the active current sources
    V0p=zeros(k+1,1);
    for i=1:k
        V0p(i)=XN(i,k);
    end
    V0p(k+1)=XT(1,k);
   
    A=ss_matrix_A(k,cont);
    B=ss_matrix_B_initial(A,cont);
    C=zeros(k,1)';
    C=[C 1];
    D=0;
    sys = ss(A,B,C,D);
    [Y, Tsim, X] =lsim(sys, u, t,V0p);
    %write the updated nodal voltages in XN
    for i=1:k
        XN(i,k+1)=[X(length(X(:,1)),1)];
    end
    XT(1,k+1)=Y(length(Y));
    YF(:,k)=Y;
    
    %negative output node
    V0n=zeros(CSn-k+1,1);
    for i=1:(CSn-k)
        V0n(i)=XN(k+1,k);
    end
    V0n(CSn-k+1)=XT(2,k);
        
    A=ss_matrix_A(CSn-k,cont);
    B=ss_matrix_B_initial(A,cont);
    C=zeros(CSn-k,1)';
    C=[C 1];
    D=0;
    sys = ss(A,B,C,D);
    [Y, Tsim, X] =lsim(sys, u, t,V0n);
    for i=(k+1):CSn
        XN(i,k+1)=[X(length(X(:,1)),1)];
    end     
    XT(2,k+1)=Y(length(Y));    
    YFn(:,k)=Y;
end