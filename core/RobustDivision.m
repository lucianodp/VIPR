function [R] = RobustDivision(A,B)
% returns A./B with no NaN or Inf
% 0/0 = 1
% x/0 = 10e10;
maxval = 10e6;
% initialize with 0s the same size as A
R = A-A;
R1 = A./B;
R(B~=0) = R1(B~=0);
R(B==0 & A==0) = 1;
R(B==0 & A~=0) = maxval;
end
