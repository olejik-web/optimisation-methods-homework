#include <iostream>
#include <math.h>
#include <vector>
#include "GradientDescent.h"
#include "FiveProblemGradientDescent.h"
#include "EightProblemGradientDescent.h"
#include "NutonMethod.h"
#include "SymplexTable.h"

void printPoint(const std::vector<double>& point)
{
    std::cout << "(";
    for (int i = 0; i < point.size() - 1; i++)
        std::cout << point[i] << ", ";
    std::cout << point.back() << ")";
}

void solveFiveProblem()
{
    FiveProblemGradientDescent gradientDescent;
    double minimiseEpsilonValue = 1e-6;
    std::vector<double> startPoint = { 0, 3 };
    double functionMinimumValue;
    std::vector<double> solvePoint(2);
    gradientDescent.minimise(startPoint, functionMinimumValue,
        solvePoint, minimiseEpsilonValue);
    std::cout << "StartPoint: ";
    printPoint(startPoint);
    std::cout << "\n";
    std::cout << "FindPoint: ";
    printPoint(solvePoint);
    std::cout << "\n";
    std::cout << "FunctionMinimumValue: " << functionMinimumValue;
    std::cout << "\n\n";
    startPoint = { 3, 0 };
    gradientDescent.minimise(startPoint, functionMinimumValue,
        solvePoint, minimiseEpsilonValue);
    std::cout << "StartPoint: ";
    printPoint(startPoint);
    std::cout << "\n";
    std::cout << "FindPoint: ";
    printPoint(solvePoint);
    std::cout << "\n";
    std::cout << "FunctionMinimumValue: " << functionMinimumValue;
    std::cout << "\n";
}

void solveEightProblem()
{
    EightProblemGradientDescent gradientDescent;
    double minimiseEpsilonValue = 1e-6;
    std::vector<double> startPoint = { 0, 2 };
    std::vector<double> solvePoint = startPoint;
    double functionMinimumValue;
    gradientDescent.minimise(startPoint, solvePoint,
        functionMinimumValue, minimiseEpsilonValue);
    std::cout << "StartPoint: ";
    printPoint(startPoint);
    std::cout << "\n";
    std::cout << "FindPoint: ";
    printPoint(solvePoint);
    std::cout << "\n";
    std::cout << "FunctionMaximumValue: " << -functionMinimumValue;
    std::cout << "\n";
}

void solveSevenProblem()
{
    NutonMethod nutonMethod;
    std::vector<double> minimumPoint;
    double minimumValue;
    double minimiseEpsilonValue = 1e-6;
    nutonMethod.minimise({ 2, 2 }, minimumPoint,
        minimumValue, minimiseEpsilonValue);
    std::cout << "MinumumPoint: ";
    printPoint(minimumPoint);
    std::cout << "\n";
    std::cout << "MinumumValue: " << minimumValue;
}

void solveNineProblem()
{
    // Домашняя задача
    SymplexTable symplexTable(
    { -3, -2, 7 },
    { 1, 3, -1, 0, 0, 0 },
    {
        {-1, -1, -1, 1, 0, 0},
        {1, -2, 0, 0, 1, 0},
        {-1, 5, 1, 0, 0, 1},
    },
    SymplexTable::FindValue::FindMin
    );
    // Тест 1
    /* SymplexTable symplexTable(
        { 12, 6, -16 },
        { 1, 2, 0, 0, 0},
        {
            {4, -2, 1, 0, 0},
            {-1, 3, 0, 1, 0},
            {-2, -4, 0, 0, 1},
        },
        SymplexTable::FindValue::FindMax
    );*/
    // Тест 2
    /* SymplexTable symplexTable(
    { 10, 12, 8 },
    { 5, 2, 3, 0, 0, 0},
    {
        {2, 3, 1, 1, 0, 0},
        {4, 2, 2, 0, 1, 0},
        {2, 1, 2, 0, 0, 1},
    },
    SymplexTable::FindValue::FindMax
    );*/
    std::vector<double> solve;
    bool haveSolve;
    double functionalValue;
    symplexTable.solve(functionalValue, solve, haveSolve);
    if (!haveSolve)
        std::cout << "No solution";
    else
    {
        std::cout << "Finded function value: " << functionalValue << "\n";
        std::cout << "Solve: (";
        for (auto value : solve)
            std::cout << value << " ";
        std::cout << ")";
    }
}

int main()
{
    // solveFiveProblem();
    // solveEightProblem();
    // solveSevenProblem();
    // solveNineProblem();
}
