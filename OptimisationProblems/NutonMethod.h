#pragma once
#include <vector>
#include <iostream>

class NutonMethod
{
public:
	double function(const std::vector<double>& value) const;
	std::vector<double> gradient(const std::vector<double>& value) const;
	void minimise(const std::vector<double>& startPoint, std::vector<double>& minimumPoint,
		double& minimumValue, double epsilon) const;
	void updatePoint(std::vector<double>& point) const;
	double norm2(const std::vector<double>& firstPoint,
		const std::vector<double>& secondPoint) const;
};