#include "GradientDescent.h"

double GradientDescent::function(const std::vector<double>& value,
    double penaltyValue) const
{
    return 0;
}

std::vector<double> GradientDescent::gradient(const std::vector<double>& value,
    double penaltyValue) const
{
    return {};
}

double GradientDescent::norm2(const std::vector<double>& firstPoint,
    const std::vector<double>& secondPoint) const
{
    double norm2Value = 0;
    for (int i = 0; i < firstPoint.size(); i++)
        norm2Value += (firstPoint[i] - secondPoint[i]) *
        (firstPoint[i] - secondPoint[i]);
    return norm2Value;
}

void GradientDescent::defineStepLength(const std::vector<double>& point, double& stepLength,
    double epsilon, double penaltyValue) const
{
    double delta = epsilon;
    double difference = 1e9;
    std::vector<double> currentGradient = gradient(point, penaltyValue);
    double segmentStart = 0;
    double segmentEnd = 1;
    while (difference > epsilon)
    {
        double firstStepLength = (segmentStart + segmentEnd - delta) / 2;
        double secondStepLength = (segmentStart + segmentEnd + delta) / 2;
        std::vector<double> firstStepLengthPoint(currentGradient.size());
        for (int i = 0; i < currentGradient.size(); i++)
            firstStepLengthPoint[i] = point[i] - firstStepLength * currentGradient[i];
        std::vector<double> secondStepLengthPoint(currentGradient.size());
        for (int i = 0; i < currentGradient.size(); i++)
            secondStepLengthPoint[i] = point[i] - secondStepLength * currentGradient[i];
        double firstFunctionValue = function(firstStepLengthPoint, penaltyValue);
        double secondFunctionValue = function(secondStepLengthPoint, penaltyValue);
        if (firstFunctionValue <= secondFunctionValue)
            segmentEnd = secondStepLength;
        else
            segmentStart = firstStepLength;
        difference = (segmentEnd - segmentStart) / 2;
    }
    stepLength = (segmentStart + segmentEnd) / 2;
}

void GradientDescent::makeStep(std::vector<double>& lastPoint, std::vector<double>& currentPoint,
    double penaltyValue) const
{
    double stepLength;
    double findStepLengthEpsilon = 1e-6;
    lastPoint = currentPoint;
    defineStepLength(currentPoint, stepLength, findStepLengthEpsilon, penaltyValue);
    std::vector<double> currentGradient = gradient(currentPoint, penaltyValue);
    for (int i = 0; i < currentGradient.size(); i++)
        currentPoint[i] = currentPoint[i] - stepLength * currentGradient[i];
}

void GradientDescent::minimise(const std::vector<double>& startPoint, double& functionValue,
    std::vector<double>& solvePoint, double epsilon, double penaltyValue) const
{
    std::vector<double> currentPoint = startPoint;
    std::vector<double> lastPoint(currentPoint.size());
    for (int i = 0; i < currentPoint.size(); i++)
        lastPoint[i] = 1e4;
    while (norm2(currentPoint, lastPoint) >= epsilon * epsilon)
        makeStep(lastPoint, currentPoint, penaltyValue);
    solvePoint = currentPoint;
    functionValue = function(solvePoint, penaltyValue);
}