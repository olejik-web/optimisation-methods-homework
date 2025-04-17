% DATA
% horizon
int: T;
% num tasks
int: n;
% release times
array[1..n] of int: r;
% processing times
array[1..n] of int: p;
% deadlines
array[1..n] of int: d;

%VARIABLES
% if task starts at time
array[1..n,1..T] of var 0..1: X;
% makespan
var int: z;

%CONSTRAINTS


%OBJECTIVE
solve minimize z :: add_to_output;


output ["TASK " ++ show(i) ++ ": " ++ [show(t) ++ ".." ++ show(t + p[i] - 1) | t in 1..T where fix(X)[i, t] = 1][1] ++ "\n" | i in 1..n];