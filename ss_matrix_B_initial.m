%State-Space model of CS DAC
% Author:    Tobias Steiner
% Created:   01.03.2017

function B = ss_matrix_B_initial(A,cont)   
    %creation of the matrix elements for an unary DAC   
    %extraction the DAC chracteristics from container vector
    Vdd=cont(1);
    Iu=cont(2);
    R_u=cont(3);
    C_u=cont(4);
    R_l=cont(5);
    C_l=cont(6);
    R_sw=cont(7);
     
    %dimension of Matrix B
    M=length(A);    
    %basic entries of the matrix B
    e_i_1=Iu/C_u;  
    %creating the (M)X(1)-Matrix B
    %for a unary weighted DAC 
    B=zeros(M,1);
    for i=1:M
        if i~=M
            B(i)=B(i)+e_i_1;
        else
            B(i)=B(i)+0;
        end
    end   
end      