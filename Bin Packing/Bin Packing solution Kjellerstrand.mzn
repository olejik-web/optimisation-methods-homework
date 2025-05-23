
include "globals.mzn";

int: num_stuff;                    % number of things to pack
array[1..num_stuff] of int: stuff; % the value/weight of the things to pack
int: bin_capacity;                 % all bins have the same capacity

% Number of bins cannot exceed num_stuff...
int: num_bins; % num_stuff;

%
% decision variables
%
% either the thing is packed or not
array[1..num_bins, 1..num_stuff] of var 0..1: bins;

% calculate how many things a bin takes
array[1..num_bins] of var 0..bin_capacity: bin_loads;

% number of loaded bins (which we will minimize)
var 0..num_bins: num_loaded_bins;

% minimize the number of loaded bins
% solve minimize num_loaded_bins;

% alternative solve statement
solve :: int_search(
         [bins[i,j] | i in 1..num_bins, j in 1..num_stuff] 
         % ++ bin_loads 
         , 
         input_order, % first_fail, 
         indomain_max, 
         complete) 
     minimize num_loaded_bins;

constraint

    % sanity clause: No thing can be larger than capacity.
    % forall(s in 1..num_stuff) ( 
    %    stuff[s] <= bin_capacity 
    % )

    % /\ % the total load in the bin cannot exceed bin_capacity
    forall(b in 1..num_bins) (
       bin_loads[b] = sum(s in 1..num_stuff) (stuff[s]*bins[b,s]) 
    ) 

    /\ % calculate the total load for a bin
    sum(s in 1..num_stuff) (stuff[s]) = sum(b in 1..num_bins) (bin_loads[b])

    /\ % a thing is packed just once 
    forall(s in 1..num_stuff) ( 
       sum(b in 1..num_bins) (bins[b,s])  = 1 
    )

    % /\ % symmetry breaking: 
    %    % if bin_loads[i+1] is > 0 then bin_loads[i] must be > 0
    %  forall(b in 1..num_bins-1) (
    %    (bin_loads[b+1] > 0 -> bin_loads[b] > 0)
    %    % /\ % and should be filled in order of weight
    %    % bin_loads[b] >= bin_loads[b+1] 
    %  ) 
    /\
    decreasing(bin_loads) :: domain
    /\ % another symmetry breaking: first bin must be loaded
    bin_loads[1] > 0 

    /\ % calculate num_loaded_bins
    num_loaded_bins = sum(b in 1..num_bins) (bool2int(bin_loads[b] > 0))

;

%
% Output
%
output [
       if (b = 1 /\ s = 1) then "num_loaded_bins: " ++ show(num_loaded_bins) ++ "\n" else "" endif ++
       if s = 1 then show(bin_loads[b]) ++ " : " else "" endif ++
           show(bins[b,s]) ++ 
           if s = num_stuff then "\n" else " " endif
       | b in 1..num_bins, s in 1..num_stuff
];
