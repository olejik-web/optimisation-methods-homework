int: num_bins;                      % количество контейнеров
int: num_stuff;                     % количество предметов
array[1..num_stuff] of int: stuff;  % веса предметов
int: bin_capacity;                  % вместимость контейнера

% таблица с распределением по контейнерам; X[i, j] = 1 == вещь j в контейнере i.
array[1..num_bins, 1..num_stuff] of var 0..1: X;

% список используемых бинов
array[1..num_bins] of var 0..1: bins_open;

% CONSTRAINTS
% каждая вещь ровно в одном контейнере
constraint forall(s in 1..num_stuff)(
  sum(b in 1..num_bins)(X[b, s]) = 1
);

% сумма масс вещей в контейнере не должна превышать его вместимость, если он испольуется; и ноль, если не используется
constraint forall(b in 1..num_bins)(
  sum(s in 1..num_stuff)(X[b, s] * stuff[s]) <= bin_capacity * bins_open[b]
);

% OBJECTIVE
% минимизируем количество контейнеров
solve minimize sum(b in 1..num_bins)(bins_open[b]);

output [ "Number of loaded bins: " ++ show(sum(b in 1..num_bins) (bins_open[b]))] ++ ["\n"] ++
       [ "Bin " ++ show(i) ++ ": " ++ show([j | j in 1..num_stuff where X[i, j] > 0]) ++ " " ++ show([stuff[j] | j in 1..num_stuff where X[i, j] > 0]) ++ ", TW: " ++ show(sum(s in 1..num_stuff)(X[i, s] * stuff[s])) ++ "\n" | i in 1..num_bins];