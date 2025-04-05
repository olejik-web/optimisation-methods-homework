#pragma once
#include "GradientDescent.h"

class FiveProblemGradientDescent : public GradientDescent
{
    double function(const std::vector<double>& value,
        double penaltyValue) const override;
    std::vector<double> gradient(const std::vector<double>& value,
        double penaltyValue) const override;
};