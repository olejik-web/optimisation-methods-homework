#include "NutonMethod.h"

double NutonMethod::function(const std::vector<double>& value) const
{
	double x1 = value[0];
	double x2 = value[1];
	return 2 * x1 * x1 + 9 * x2 * x2 + 3 * x1 * x2 - 4 * x1 - 3 * x2 + 1;
}

std::vector<double> NutonMethod::gradient(const std::vector<double>& value) const
{
	double x1 = value[0];
	double x2 = value[1];
	return
	{
		4 * x1 + 3 * x2 - 4,
		18 * x2 + 3 * x1 - 3
	};
}

double NutonMethod::norm2(const std::vector<double>& firstPoint,
	const std::vector<double>& secondPoint) const
{
	double norm2Value = 0;
	for (int i = 0; i < firstPoint.size(); i++)
		norm2Value += (firstPoint[i] - secondPoint[i]) *
		(firstPoint[i] - secondPoint[i]);
	return norm2Value;
}

void NutonMethod::minimise(const std::vector<double>& startPoint, std::vector<double>& minimumPoint,
	double& minimumValue, double epsilon) const
{
	std::vector<double> zeroVector(startPoint.size(), 0);
	std::vector<double> currentPoint = startPoint;
	while (norm2(gradient(currentPoint), zeroVector) >= epsilon * epsilon)
		updatePoint(currentPoint);
	minimumPoint = currentPoint;
	minimumValue = function(currentPoint);
}

void NutonMethod::updatePoint(std::vector<double>& point) const
{
	std::vector<double> pointGradient = gradient(point);
	point =
	{
		point[0] - 2.0 * pointGradient[0] / 7.0 + pointGradient[1] / 21.0,
		point[1] + pointGradient[0] / 21.0 - 4 * pointGradient[1] / 63.0
	};
}