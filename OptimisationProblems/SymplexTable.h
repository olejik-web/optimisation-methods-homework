#pragma once
#include <vector>
#include <math.h>

class SymplexTable
{
public:
	static enum FindValue
	{
		FindMax,
		FindMin
	};
	SymplexTable(const std::vector<double>& borderValues, const std::vector<double>& functionalCoefficients,
		const std::vector<std::vector<double>>& coefficientsMatrix, FindValue findValue);
	void print() const;
	void solve(double& functionalValue, std::vector<double>& solveVector, bool& haveSolve);
	void defineMainColumn(int& column) const;
	void defineMainRow(int& row, int mainColumn) const;
	void defineMinBorderValue(double& minBorderValue, int& row) const;
	void deleteNegativeBorderValue(int negativeValueRow, bool& ok);
	void recalculate(int mainColumn, int mainRow);
	void calculateDeltaValues();
private:
	static constexpr double EPSILON{ 1e-9 };
	FindValue m_findValue;
	std::vector<std::vector<double>> m_coefficientsMatrix;
	std::vector<double> m_functionalCoefficients;
	std::vector<double> m_borderValues;
	std::vector<int> m_basis;
	std::vector<int> m_variables;
	std::vector<double> m_deltaValues;
};