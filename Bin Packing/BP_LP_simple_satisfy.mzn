int: num_bins;                      % количество контейнеров
int: num_stuff;                     % количество предметов
array[1..num_stuff] of int: stuff;  % веса предметов
int: bin_capacity;                  % вместимость контейнера

% таблица с распределением по контейнерам; X[i, j] = 1 == вещь j в контейнере i.
array[1..num_bins, 1..num_stuff] of var 0..1: X;

% CONSTRAINTS
% каждая вещь ровно в одном контейнере
constraint forall(s in 1..num_stuff)(
  sum(b in 1..num_bins)(X[b, s]) = 1
);

% сумма масс вещей в контейнере не должна превышать его вместимость
constraint forall(b in 1..num_bins)(
  sum(s in 1..num_stuff)(X[b, s] * stuff[s]) <= bin_capacity
);


% OBJECTIVE
% распределить как-нибудь
solve satisfy;

output show2d(X);


