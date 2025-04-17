%DATA
% Planning horizon
int: T;
% Total # of tasks
int: nTasks;
% Task durations
array[1..nTasks] of int: dur;
% Total # of resources
int: nRes;
% Resource capacities
array[1..nRes] of int: capa;
% Task resource demand
array[1..nTasks, 1..nRes]: demand;
% Precedence relations. prec[i,j] = 1 <=> task i preceeds j. 
array[1..nTasks, 1..nRes] of int: prec;