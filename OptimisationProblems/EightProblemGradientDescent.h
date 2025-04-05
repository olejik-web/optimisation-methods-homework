#pragma once
#include "GradientDescent.h"
class EightProblemGradientDescent : public GradientDescent
{
public:
    double function(const std::vector<double>& value,
        double penaltyValue) const override;
    double borderFunction(const std::vector<double>& value) const;
    std::vector<double> gradient(const std::vector<double>& value,
        double penaltyValue) const override;
    void minimise(const std::vector<double>& startPoint,
        std::vector<double>& solvePoint, double& functionValue,
        double epsilon) const;
    void printPoint(const std::vector<double>& point) const;
};

