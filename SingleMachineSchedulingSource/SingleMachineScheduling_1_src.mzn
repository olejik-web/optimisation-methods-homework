% DATA
% horizon
int: T;
% num tasks
int: n;
% release times
array[1..n] of 0..T: r;
% processing times
array[1..n] of 0..T: p;
% deadlines
array[1..n] of 0..T: d;

% VARIABLES
% start times
array[1..n] of var 0..T: s;
% precedence indicators
array[1..n, 1..n] of var 0..1: Q;
% makespan
var 0..T: z;

% CONSTRAINTS



solve minimize z;


output ["TASK " ++ show(i) ++ ": " ++ show(s[i]) ++ ".." ++ show(s[i] + p[i] - 1) ++ "\n" | i in 1..n];