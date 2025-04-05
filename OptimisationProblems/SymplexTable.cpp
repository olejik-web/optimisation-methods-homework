#include <iostream>
#include "SymplexTable.h"

SymplexTable::SymplexTable(const std::vector<double>& borderValues,
	const std::vector<double>& functionalCoefficients,
	const std::vector<std::vector<double>>& coefficientsMatrix, FindValue findValue) :
	m_coefficientsMatrix(coefficientsMatrix),
	m_borderValues(borderValues),
	m_functionalCoefficients(functionalCoefficients),
	m_findValue(findValue)
{
	for (int i = 0; i < m_coefficientsMatrix[0].size(); i++)
		m_variables.push_back(i + 1);
	for (int i = m_variables.size() - m_borderValues.size(); i < m_variables.size(); i++)
		m_basis.push_back(i + 1);
	m_deltaValues = std::vector<double>(m_variables.size() + 1, 0);
}

void SymplexTable::defineMainRow(int& row, int mainColumn) const
{
	double value = 1e9;
	for (int i = 0; i < m_borderValues.size(); i++)
	{
		if (abs(m_coefficientsMatrix[i][mainColumn]) < EPSILON)
			continue;
		double calculateValue =
			m_borderValues[i] / m_coefficientsMatrix[i][mainColumn];
		if (calculateValue >= 0 && value > calculateValue)
		{
			value = calculateValue;
			row = i;
		}
	}
}

void SymplexTable::defineMainColumn(int& column) const
{
	double value;
	switch (m_findValue)
	{
	case FindValue::FindMin:
		value = 0;
		for (int i = 0; i < m_deltaValues.size() - 1; i++)
		{
			if (value < m_deltaValues[i])
			{
				value = m_deltaValues[i];
				column = i;
			}
		}
		return;
	case FindValue::FindMax:
		value = 0;
		for (int i = 0; i < m_deltaValues.size() - 1; i++)
		{
			if (value > m_deltaValues[i])
			{
				value = m_deltaValues[i];
				column = i;
			}
		}
		return;
	}
}

void SymplexTable::calculateDeltaValues()
{
	for (int i = 0; i < m_deltaValues.size() - 1; i++)
	{
		m_deltaValues[i] = 0;
		for (int j = 0; j < m_basis.size(); j++)
			m_deltaValues[i] +=
			m_coefficientsMatrix[j][i] * m_functionalCoefficients[m_basis[j] - 1];
		m_deltaValues[i] -= m_functionalCoefficients[i];
	}
	m_deltaValues.back() = 0;
	for (int j = 0; j < m_basis.size(); j++)
		m_deltaValues.back() +=
		m_borderValues[j] * m_functionalCoefficients[m_basis[j] - 1];
}

void SymplexTable::defineMinBorderValue(double& minBorderValue, int& row) const
{
	for (int i = 0; i < m_borderValues.size(); i++)
	{
		if (m_borderValues[i] < 0 && minBorderValue > m_borderValues[i])
		{
			minBorderValue = m_borderValues[i];
			row = i;
		}
	}
}

void SymplexTable::deleteNegativeBorderValue(int negativeValueRow, bool& ok)
{
	double minValue = 0;
	int minValueColumn = -1;
	for (int i = 0; i < m_variables.size(); i++)
	{
		if (minValue > m_coefficientsMatrix[negativeValueRow][i] &&
			m_coefficientsMatrix[negativeValueRow][i] < 0)
		{
			minValue = m_coefficientsMatrix[negativeValueRow][i];
			minValueColumn = i;
		}
	}
	if (minValueColumn < 0)
	{
		ok = false;
		return;
	}
	m_basis[negativeValueRow] = m_variables[minValueColumn];
	recalculate(minValueColumn, negativeValueRow);
}

void SymplexTable::recalculate(int mainColumn, int mainRow)
{
	m_basis[mainRow] = m_variables[mainColumn];
	double mainValue = m_coefficientsMatrix[mainRow][mainColumn];
	for (int i = 0; i < m_variables.size(); i++)
		m_coefficientsMatrix[mainRow][i] /= mainValue;
	m_borderValues[mainRow] /= mainValue;
	for (int i = 0; i < m_borderValues.size(); i++)
	{
		if (i != mainRow)
		{
			double mainRowValue = m_coefficientsMatrix[i][mainColumn];
			for (int j = 0; j < m_variables.size(); j++)
				m_coefficientsMatrix[i][j] -= m_coefficientsMatrix[mainRow][j] * mainRowValue;
			m_borderValues[i] -= m_borderValues[mainRow] * mainRowValue;
		}
	}
}

void SymplexTable::solve(double& functionalValue, std::vector<double>& solveVector, bool& haveSolve)
{
	double minBorderValue = 0;
	int minBorderValueRow = -1;
	defineMinBorderValue(minBorderValue, minBorderValueRow);
	while (minBorderValue < 0)
	{
		deleteNegativeBorderValue(minBorderValueRow, haveSolve);
		if (!haveSolve)
			return;
		minBorderValue = 0;
		minBorderValueRow = -1;
		defineMinBorderValue(minBorderValue, minBorderValueRow);
	}
	calculateDeltaValues();
	int mainColumn = -1;
	int mainRow = -1;
	defineMainColumn(mainColumn);
	while (mainColumn != -1)
	{
		defineMainRow(mainRow, mainColumn);
		if (mainRow == -1)
		{
			haveSolve = false;
			return;
		}
		recalculate(mainColumn, mainRow);
		calculateDeltaValues();
		print();
		mainColumn = -1;
		mainRow = -1;
		defineMainColumn(mainColumn);
	}
	for (auto borderValue : m_borderValues)
	{
		if (borderValue < 0)
		{
			haveSolve = false;
			return;
		}
	}
	haveSolve = true;
	functionalValue = m_deltaValues.back();
	solveVector = std::vector<double>(m_variables.size(), 0);
	for (int i = 0; i < m_borderValues.size(); i++)
		solveVector[m_basis[i] - 1] = m_borderValues[i];
}

void SymplexTable::print() const
{
	std::cout << "C ";
	for (auto value : m_functionalCoefficients)
		std::cout << value << " ";
	std::cout << 0 << "\n";
	for (int i = 0; i < m_basis.size(); i++)
	{
		std::cout << m_basis[i] << " ";
		for (auto matrixValue : m_coefficientsMatrix[i])
			std::cout << matrixValue << " ";
		std::cout << m_borderValues[i];
		std::cout << "\n";
	}
	for (auto deltaValue : m_deltaValues)
		std::cout << deltaValue << " ";
	std::cout << "\n\n";
}