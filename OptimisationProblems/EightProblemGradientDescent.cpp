#include "EightProblemGradientDescent.h"

double EightProblemGradientDescent::borderFunction(const std::vector<double>& value) const
{
    double x1 = value[0];
    double x2 = value[1];
    return 2 * x1 - 3 * x2 + 6;
}

void EightProblemGradientDescent::printPoint(const std::vector<double>& point) const
{
    std::cout << "(";
    for (int i = 0; i < point.size() - 1; i++)
        std::cout << point[i] << ", ";
    std::cout << point.back() << ")";
}

void EightProblemGradientDescent::minimise(const std::vector<double>& startPoint,
    std::vector<double>& solvePoint, double& functionValue, double epsilon) const
{
    std::vector<double> lastPoint(startPoint.size());
    for (int i = 0; i < startPoint.size(); i++)
        lastPoint[i] = 1e4;
    std::vector<double> currentPoint = startPoint;
    while (norm2(lastPoint, currentPoint) >= epsilon * epsilon)
    {
        double leftPenaltyValue = 1;
        double rightPenaltyValue = 10;
        double middlePenaltyValue = (leftPenaltyValue + rightPenaltyValue) / 2;
        double binSearchEpsilon = 1e-6;
        while (rightPenaltyValue - leftPenaltyValue >= binSearchEpsilon)
        {
            middlePenaltyValue = (leftPenaltyValue + rightPenaltyValue) / 2;
            std::vector<double> stepPoint = currentPoint;
            makeStep(stepPoint, stepPoint, middlePenaltyValue);
            if (borderFunction(stepPoint) > 0)
                rightPenaltyValue = middlePenaltyValue - binSearchEpsilon;
            else
                leftPenaltyValue = middlePenaltyValue + binSearchEpsilon;
        }
        lastPoint = currentPoint;
        makeStep(currentPoint, currentPoint, middlePenaltyValue);
        solvePoint = currentPoint;
        functionValue = function(currentPoint, middlePenaltyValue);
    }
}

double EightProblemGradientDescent::function(const std::vector<double>& value,
    double penaltyValue = 0) const
{
    double x1 = value[0];
    double x2 = value[1];
    double r = penaltyValue;
    return -(-8 * x1 * x1 + 4 * x1 - x2 * x2 + 12 * x2 - 3
        + r * (2 * x1 - 3 * x2 + 6) * (2 * x1 - 3 * x2 + 6));
}

std::vector<double> EightProblemGradientDescent::gradient(const std::vector<double>& value,
    double penaltyValue = 0) const
{
    double x1 = value[0];
    double x2 = value[1];
    double r = penaltyValue;
    return
    {
        16 * x1 - 4 - 2 * r,
        2 * x2 - 12 + 3 * r
    };
}
