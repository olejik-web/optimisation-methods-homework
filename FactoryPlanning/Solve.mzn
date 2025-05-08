% ПЛАНИРОВАНИЕ НА ЗАВОДЕ

% Машиностроительный завод производит семь изделий (PROD 1 - PROD 7) на
% следующих станках: четыре шлифовальных, два вертикально-сверлильных, три горизонтально-сверлильных, один
% сверлильный и один строгальный. Каждый продукт приносит определенный вклад в прибыль (определяется
% как $/единица отпускной цены минус стоимость сырья). Эти величины (в $/единицу)
%, а также время производства единицы продукции (часы), необходимое для каждого процесса, даны.
% Целевое количество станков должно быть остановлено для технического обслуживания.
% Мы хотим найти оптимальное сочетание продуктов для производства и продажи при заданных производственных мощностях и маркетинговых
% ограничений. 
% Целевая функция: (Общая прибыль от продажи) - (Издержки производства).

%DATA
% Количество рассматриваемых месяцев
int: NbMonths;
% 2 восьмичасовые смены в день, 24 рабочих дня в месяц;
float: HoursMonth;
% Стоимость хранения запасов на конец месяца
float: CostHold;
% Начальные запасы
float: StartHold;
% Конечные запасы
float: EndHold;
% Максимальное количество запасов в любой месяц
float: MaxHold;

int: MaintenanceLength = 7;
int: DaysCount = 24;

% Продукты
enum Prod;
% Машины
enum Process;

% profitProd[j] - прибыль на единицу продукции j
array[Prod] of float: ProfitProd;
% processProd[i,j] - часы работы процесса i, необходимые для производства продукта j
array[Process, Prod] of float: ProcessProd;
% marketProd[i,j] дает маркетинговое ограничение на продукт j для месяца i
array[1..NbMonths, Prod] of float: MarketProd;
% количество машин каждого типа
array[Process] of int: NumProcess;
% Сколько машин должно выйти из строя за 6 месяцев
array[Process] of int: NumDown;
% array[Process, 1..max(NumDown)] of array[1..NbMonths, 1..24]: DownData;
% Переменные %
array [1..NbMonths, 1..DaysCount, Process, 1..max(NumProcess), Prod] of var 0..16000: countMatrix;

constraint forall(month in 2..(NbMonths - 1))(sum(day in 1..DaysCount, product in Prod,
  process in Process, number in 1..NumProcess[process])
  (countMatrix[month, day, process, number, product]) <= MaxHold);

constraint sum(day in 1..DaysCount, product in Prod,
  process in Process, number in 1..NumProcess[process])
  (countMatrix[NbMonths, day, process, number, product]) = EndHold;

constraint sum(day in 1..DaysCount, product in Prod,
  process in Process, number in 1..NumProcess[process])
  (countMatrix[1, day, process, number, product]) + StartHold <= MaxHold;

constraint forall(month in 1..NbMonths, product in Prod)(sum(day in 1..DaysCount, 
  process in Process, number in 1..NumProcess[process])
  (countMatrix[month, day, process, number, product]) <= MarketProd[month, product]);

constraint forall(month in 1..NbMonths, day in 1..DaysCount, 
  process in Process, processNumber in 1..NumProcess[process])(
  sum(product in Prod)(countMatrix[month, day, process, processNumber, product] * 
  ProcessProd[process, product]) <= 16);

constraint forall(month in 1..NbMonths, day in 1..DaysCount, process in Process, 
  processNumber in (NumProcess[process] + 1)..max(NumProcess), product in Prod)(
  countMatrix[month, day, process, processNumber, product] = 0);

constraint forall(process in Process, processNumber in 1..NumDown[process])
  (sum(firstDay in 1..DaysCount * NbMonths, 
  secondDay in firstDay..min(firstDay + MaintenanceLength - 1, DaysCount * NbMonths))(
  if sum(indexDay in firstDay..secondDay)(if sum(product in Prod)(
  countMatrix[indexDay div DaysCount + (if indexDay mod DaysCount > 0 then 1 else 0 endif), 
  (if indexDay mod DaysCount = 0 then DaysCount else indexDay mod DaysCount endif), 
  process, processNumber, product]) = 0 
  then 1 else 0 endif) = MaintenanceLength then 1 else 0 endif) > 0);

% var int sum
% var int: x;
solve maximize sum(month in 1..NbMonths, day in 1..DaysCount, process in Process, 
  processNumber in 1..NumProcess[process], product in Prod)(
  countMatrix[month, day, process, processNumber, product] * ProfitProd[product] - 
  countMatrix[month, day, process, processNumber, product] * CostHold);

output [show(process) ++ show(number) ++ 
  show([[[countMatrix[month, day, process, number, product] | product in Prod]
  | day in 1..DaysCount] | month in 1..NbMonths]) ++ "\n" 
  | process in Process, number in 1..NumProcess[process]];
output show([sum(day in 1..DaysCount, process in Process, 
  processNumber in 1..NumProcess[process], product in Prod)(
  countMatrix[month, day, process, processNumber, product]) | month in 1..NbMonths]) ++ "\n";
output "Итоговая прибыль: " ++ show(sum(month in 1..NbMonths, day in 1..DaysCount, process in Process, 
  processNumber in 1..NumProcess[process], product in Prod)(
  countMatrix[month, day, process, processNumber, product] * ProfitProd[product] - 
  countMatrix[month, day, process, processNumber, product] * CostHold));
