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
array[1..n] of var 0..1: x::add_to_output;

%CONSTRAINT
constraint sum(i in 1..n)(x[i] * w[i]) <= K;

array[1..n] of var int: sorted_x = reverse(sort_by(x, w));

ann: sw = int_search(sorted_x, input_order, indomain_min);

%OBJECTIVE 
solve::sw  maximize sum(i in 1..n)(x[i] * c[i]);



% OUTPUT 
output  [show(w[i]) ++ " " | i in 1..n where fix(x)[i] = 1] ++ [" = \( sum(i in 1..n)(x[i]*c[i]))\n"];
