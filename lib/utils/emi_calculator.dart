import 'dart:math';

Map<String, dynamic> calculateEMI(double p, double rate, int years) {
  double r = rate / 12 / 100;
  int n = years * 12;

  double emi = p * r * pow((1 + r), n) / (pow((1 + r), n) - 1);
  double totalPayment = emi * n;
  double totalInterest = totalPayment - p;

  return {
    "emi": emi.round(),
    "totalPayment": totalPayment.round(),
    "totalInterest": totalInterest.round(),
  };
}
