%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017

function A = ss_matrix_A(K,cont)
    %creation of the matrix elements for an unary DAC
    %extraction the DAC chracteristics from container vector
    R_u=cont(3);
    C_u=cont(4);
    R_l=cont(5);
    C_l=cont(6);
    R_sw=cont(7);
    %number of unary current sources
    CSn=K;
    %dimension of Matrix A
    M=CSn+1;
    %creating the (M)X(M)-Matrix A
    %for a unary weighted DAC 
    
    %basic entries of the matrix A
    e_i_i=-(1/R_u + 1/R_sw)*(1/C_u);
    e_i_M=(1/R_sw)*(1/C_u);
    e_M_i=(1/R_sw)*(1/C_l);
    e_M_M=-((1/R_l)+(CSn/R_sw))*(1/C_l);

    A=zeros(M,M);
    
    for z=1:M;
        for s=1:M;
            if s==z&&(z~=M)
                A(z,s)=e_i_i;
            elseif s==M&&(z~=M)
                A(z,s)=e_i_M;
            elseif (z==M)&&(s~=M);
                A(z,s)=e_M_i;
            elseif (z==M)&&(s==M)
                A(z,s)=e_M_M;
            else
                A(z,s)=0; 
            end
        end
    end
end