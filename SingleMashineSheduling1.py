import pyomo.environ as pyo
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

class SingleMashineShedulingModel1(pyo.ConcreteModel):
    def __init__(self, **data):
        super().__init__()
        self._create_params(data)
        self._create_vars()
        self._create_constraints()
        self._create_objective()
        self.tasksOrder = []

    def _create_params(self, data):
        self.horizon = data["horizon"]
        self.tasksNumber = data["tasksNumber"]
        self.processingTimes = [0] + data["processingTimes"]
        self.releaseTimes = [0] + data["releaseTimes"]
        self.deadlines = [0] + data["deadlines"]

    def _create_vars(self):
        self.precedenceIndicators = pyo.Var(pyo.RangeSet(self.tasksNumber), 
            pyo.RangeSet(self.tasksNumber), within=pyo.Binary)
        self.startTimes = pyo.Var(pyo.RangeSet(self.tasksNumber), 
            within=pyo.RangeSet(self.horizon))
        self.executeTime = pyo.Var(within=pyo.NonNegativeIntegers)
    
    def objectiveRule(self, model):
        return self.executeTime

    def firstRule(self, model, first, second):
        if first >= second:
            return pyo.Constraint.Skip
        return self.precedenceIndicators[first, second] + \
            self.precedenceIndicators[second, first] == 1

    def secondRule(self, model, first, second):
        if first == second:
            return pyo.Constraint.Skip
        return self.startTimes[second] - self.startTimes[first] >= \
            self.horizon * (self.precedenceIndicators[first, second] - 1) + \
            self.processingTimes[first]

    def thirdRule(self, model, taskNumber):
        return self.startTimes[taskNumber] + \
            self.processingTimes[taskNumber] - 1 <= self.executeTime

    def fourRule(self, model, taskNumber):
        return self.releaseTimes[taskNumber] <= self.startTimes[taskNumber]
    
    def fiveRule(self, model, taskNumber):
        return self.startTimes[taskNumber] + self.processingTimes[taskNumber] - 1 <= self.deadlines[taskNumber]

    def _create_constraints(self):
        self.firstConstraint = pyo.Constraint(pyo.RangeSet(self.tasksNumber),
            pyo.RangeSet(self.tasksNumber), rule=self.firstRule)
        self.secondConstraint = pyo.Constraint(pyo.RangeSet(self.tasksNumber),
            pyo.RangeSet(self.tasksNumber), rule=self.secondRule)
        self.thidConstraint = pyo.Constraint(pyo.RangeSet(self.tasksNumber), rule=self.thirdRule)
        self.fourConstraint = pyo.Constraint(pyo.RangeSet(self.tasksNumber), rule=self.fourRule)
        self.fiveConstraint = pyo.Constraint(pyo.RangeSet(self.tasksNumber), rule=self.fiveRule)

    def _create_objective(self):
        self.objectiveFunction = pyo.Objective(rule=self.objectiveRule)

    def solve(self, solver: str, tee: bool = False, print_details: bool = True):
        solver = pyo.SolverFactory(solver)
        solver.solve(self, tee=tee)
        if print_details:
            self.pprint()
        for i in range(1, self.tasksNumber + 1):
            self.tasksOrder.append(
                {
                    "number": str(i),
                    "start": self.startTimes[i].value, 
                    "finish": self.startTimes[i].value + self.processingTimes[i] - 1
                }
            )
            print("Задача {} выполняется в промежутке [{}, {}]".format(self.tasksOrder[-1]["number"], 
                self.tasksOrder[-1]["start"], self.tasksOrder[-1]["finish"]))
        print("Необходимое время выполения всех задач:", self.executeTime.value)

def drawTasksShedule(model, grid):
    bw = 0.3
    idx = 0
    plt.subplot(grid[0:7, 0])
    for i, task in enumerate(model.tasksOrder):
        x = model.releaseTimes[i + 1]
        y = min(model.deadlines[i + 1] + 1, model.horizon)
        plt.fill_between([x, y],[idx-bw, idx-bw],[idx+bw, idx+bw], color='cyan', alpha=0.6)
        x = task['start']
        y = min(task["finish"] + 1, model.executeTime.value)
        plt.fill_between([x, y],[idx-bw, idx-bw],[idx+bw, idx+bw], color='red', alpha=0.8)
        plt.plot([x, y, y, x, x], [idx-bw, idx-bw, idx+bw, idx+bw, idx-bw], color='k')
        idx += 1
    plt.ylim(-0.5, idx-0.5)
    plt.xlim(1, model.horizon)
    plt.title("Расписание задач")
    plt.xlabel('Время')
    plt.ylabel('Задачи')
    plt.yticks(range(model.tasksNumber), [task["number"] for task in model.tasksOrder])

def drawWorkerShedule(model, grid):
    start = 1
    finish = model.executeTime.value
    shedule = {}
    bw = 0.3
    plt.subplot(grid[9:, 0])
    for i, task in enumerate(model.tasksOrder):
        x = task["start"]
        y = min(task["finish"] + 1, model.executeTime.value)
        plt.fill_between([x, y], [-bw, -bw], [bw, bw], color="red", alpha=0.5)
        plt.plot([x, y, y, x, x], [-bw, -bw, bw, bw, -bw],color='k')
        plt.text((x + y) / 2.0, 0, i + 1, color='black', weight='bold',
            horizontalalignment='center', verticalalignment='center')
    plt.xlim(1, model.horizon)
    plt.ylim(-0.5, 0.5)
    plt.yticks([])
    plt.title("Расписание работника")
    plt.xlabel('Время')
    plt.grid()

if __name__ == '__main__':
    data = {
        "horizon": 45,
        "tasksNumber": 7,
        "processingTimes": [1, 3, 5, 4, 7, 2, 10],
        "releaseTimes": [1, 7, 4, 1, 5, 12, 1],
        "deadlines": [6, 40, 40, 17, 35, 25, 12]
    }
    data30 = {
        "horizon": 360,
        "tasksNumber": 30,
        "processingTimes": [8 ,5 ,14 ,2 ,5 ,7 ,3 ,3 ,
            16 ,2 ,3 ,3 ,3 ,10 ,18 ,23 ,8 ,1 ,13 ,3 ,3 ,7 ,25 ,
            1 ,1 ,5 ,13 ,1 ,1 ,10],
        "releaseTimes": [1 ,14 ,26 ,4 ,4 ,39 ,53 ,66 ,55 ,94 ,
            76 ,78 ,5 ,71 ,54 ,117 ,40 ,203 ,69 ,84 ,98 ,10 ,1 ,
            88 ,204 ,103 ,281 ,31 ,246 ,139],
        "deadlines": [313 ,296 ,99 ,106 ,190 ,109 ,267 ,174 ,
            267 ,141 ,351 ,335 ,304 ,231 ,358 ,320 ,291 ,273 ,250 ,
            280 ,327 ,264 ,352 ,317 ,351 ,314 ,347 ,334 ,331 ,342]
    }
    model = SingleMashineShedulingModel1(**data)
    model.solve("appsi_highs", print_details=False)
    plt.figure(figsize=(12, 0.5 * len(model.tasksOrder) + 1), constrained_layout=True)
    grid = GridSpec(10, 1)
    drawTasksShedule(model, grid)
    drawWorkerShedule(model, grid)
    plt.subplots_adjust(hspace=10)
    plt.show()