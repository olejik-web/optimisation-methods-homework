#include "FiveProblemGradientDescent.h"

double FiveProblemGradientDescent::function(const std::vector<double>& value,
    double penaltyValue = 0) const
{
    double x = value[0];
    double y = value[1];
    return (y * y + x * x - 1) * (y * y + x * x - 1) + (x + y - 1) * (x + y - 1);
}

std::vector<double> FiveProblemGradientDescent::gradient(const std::vector<double>& value,
    double penaltyValue = 0) const
{
    double x = value[0];
    double y = value[1];
    return
    {
        4 * y * y * x + 4 * x * x * x - 2 * x + 2 * y - 2,
        4 * y * y * y + 4 * x * x * y - 2 * y + 2 * x - 2
    };
}