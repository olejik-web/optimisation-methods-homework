%KNAPSACK PROBLEM 
% DATA 
%number of items
int: n;
% knapsack capacity
int: K;
% values 
array[1..n] of int: c;
% weights 
array[1..n] of int: w;
%VARIABLES 
array[1..n] of var 0..1: x;
 
%OBJECTIVE 
solve maximize sum(i in 1..n)(x[i] * c[i]);

%CONSTRAINT
constraint sum(i in 1..n)(x[i] * w[i]) <= K; 

% OUTPUT 
output  ["Total value = \( sum(i in 1..n)(x[i]*c[i]))\n"];