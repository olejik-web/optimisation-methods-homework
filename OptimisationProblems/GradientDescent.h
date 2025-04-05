#pragma once

#include <math.h>
#include <iostream>
#include <iomanip>
#include <vector>

class GradientDescent
{
public:
	virtual double function(const std::vector<double>& value, double penaltyValue = 0) const;
	virtual std::vector<double> gradient(const std::vector<double>& value, double penaltyValue = 0) const;
	void makeStep(std::vector<double>& lastPoint, std::vector<double>& currentPoint,
		double penalyValue = 0) const;
	void defineStepLength(const std::vector<double>& point, double& stepLength,
		double epsilon, double penaltyValue = 0) const;
	double norm2(const std::vector<double>& firstPoint,
		const std::vector<double>& secondPoint) const;
	void minimise(const std::vector<double>& startPoint, double& functionValue,
		std::vector<double>& solvePoint, double epsilon, double penaltyValue = 0) const;
private:
	std::vector<double> m_startPoint;
};