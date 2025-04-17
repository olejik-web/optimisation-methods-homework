import pyomo.environ as pyo

class BinPackingModel(pyo.ConcreteModel):
    def __init__(self, **data):
        super().__init__()
        self._create_params(data)
        self._create_vars()
        self._create_constraints()
        self._create_objective()

    def _create_params(self, data):
        self.stuffCount = data["num_stuff"]
        self.binsCount = data['num_bins']
        self.binCapacity = data['bin_capacity']
        self.stuffWeights = data['stuff']

    def _create_vars(self):
        self.binsStuffMatrix = pyo.Var(pyo.RangeSet(self.binsCount), 
            pyo.RangeSet(self.stuffCount), within=pyo.Binary)
        self.openBins = pyo.Var(pyo.RangeSet(self.binsCount), within=pyo.Binary)
    
    def objectiveRule(self, model) -> pyo.Expression:
        return sum(self.openBins[i] for i in range(1, self.binsCount))

    def stuffInOnlyOneBinRule(self, model, stuffNum):
        return sum(self.binsStuffMatrix[binNum, stuffNum] for binNum in range(1, self.binsCount + 1)) == 1

    def sumBinAllStuffRule(self, model, binNum):
        return sum(self.binsStuffMatrix[binNum, stuffNum] * self.stuffWeights[stuffNum - 1] 
            for stuffNum in range(1, self.stuffCount + 1)) <= self.binCapacity * self.openBins[binNum]

    def _create_constraints(self):
        self.firstConstraint = pyo.Constraint(pyo.RangeSet(self.stuffCount), rule=self.stuffInOnlyOneBinRule)
        self.secondConstraint = pyo.Constraint(pyo.RangeSet(self.binsCount), rule=self.sumBinAllStuffRule)

    def _create_objective(self):
        self.objectiveFunction = pyo.Objective(rule=self.objectiveRule)

    def solve(self, solver: str, tee: bool = False, print_details: bool = True):
        solver = pyo.SolverFactory(solver)
        solver.solve(self, tee=tee)
        if print_details:
            self.pprint()
        print("Количество заполненных корзин: {}".format(
            int(sum(self.openBins[i].value for i in range(1, self.binsCount + 1)))))
        for binNum in range(1, self.binsCount + 1):
            binWeights = [self.stuffWeights[stuffNum - 1] for stuffNum in range(1, self.stuffCount + 1) 
                if self.binsStuffMatrix[binNum, stuffNum].value > 0]
            print("Корзина {}: [{}], [{}], {}".format(binNum,
                ', '.join([str(stuffNum) for stuffNum in range(1, self.stuffCount + 1) 
                if self.binsStuffMatrix[binNum, stuffNum].value > 0]), 
                ', '.join([str(self.stuffWeights[stuffNum - 1]) for stuffNum in range(1, self.stuffCount + 1) 
                if self.binsStuffMatrix[binNum, stuffNum].value > 0]), sum(binWeights)))

if __name__ == '__main__':
    """
    Необходимо установить pyomo:
        !pip install pyomo
    Установить любой MILP-солвер (highs можно поставить через пакетный менеджер pip):
        !pip install highspy
    """
    data1 = {
        "num_stuff": 5,
        "num_bins": 3,
        "stuff": [1, 2, 3, 4, 5],
        "bin_capacity": 10
    }

    data2 = {
        "num_stuff": 10,
        "num_bins": 10,
        "stuff": [42,63,67,57,93,90,38,36,45,42],
        "bin_capacity": 150
    }

    data3 = {
        "num_stuff": 10,
        "num_bins": 10,
        "stuff": [42,63,67,57,93,90,38,36,45,42],
        "bin_capacity": 150
    }

    data4 = {
        "num_stuff": 30,
        "num_bins" : 30,
        "stuff": [42,63,67,57,24,90,38,36,45,42,33,12,73,49,
            24,15,23,57,72,7,47,33,65,69,34,77,54,13,2,84],
        "bin_capacity": 150
    }

    model = BinPackingModel(**data4)
    model.solve("appsi_highs", print_details=False)