import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/emi_calculator.dart';
import '../services/history_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // SLIDER VALUES
  double loanAmount = 1000000; // ₹10L default
  double interestRate = 7.5; // 7.5%
  double tenureYears = 10; // 10 years

  // OUTPUT VALUES
  bool calculated = false;
  int emi = 0;
  int totalInterest = 0;
  int totalPayment = 0;

  final historyService = HistoryService();

  Future<void> calculate() async {
    final result = await calculateEMI(
      loanAmount,
      interestRate,
      tenureYears.toInt(),
    );

    setState(() {
      emi = result['emi'];
      totalInterest = result['totalInterest'];
      totalPayment = result['totalPayment'];
      calculated = true;
    });

    await historyService.saveHistory(
      loanAmount,
      interestRate,
      tenureYears.toInt(),
      emi,
      totalInterest,
      totalPayment,
    );
  }

  // ---------------- SLIDER CARD ---------------- //
  Widget sliderCard({
    required String title,
    required Widget slider,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          slider,
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PIE CHART DATA ---------------- //
  List<PieChartSectionData> getPieData() {
    return [
      PieChartSectionData(
        value: loanAmount,
        color: Colors.blue.shade800,
        radius: 72,
        title: "Principal\n₹${loanAmount.toInt()}",
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        value: totalInterest.toDouble(),
        color: Colors.lightBlueAccent,
        radius: 72,
        title: "Interest\n₹$totalInterest",
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          "EMI Calculator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Home Loan EMI Calculator",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 28),

            // LOAN AMOUNT SLIDER
            sliderCard(
              title: "Loan Amount",
              slider: Slider(
                min: 100000,
                max: 10000000,
                divisions: 100,
                value: loanAmount,
                activeColor: Colors.blue.shade800,
                onChanged: (v) => setState(() => loanAmount = v),
              ),
              value: "₹ ${loanAmount.toInt()}",
            ),

            // TENURE SLIDER
            sliderCard(
              title: "Tenure (Years)",
              slider: Slider(
                min: 1,
                max: 30,
                value: tenureYears,
                divisions: 29,
                activeColor: Colors.blue.shade800,
                onChanged: (v) => setState(() => tenureYears = v),
              ),
              value: "${tenureYears.toInt()} years",
            ),

            // INTEREST RATE SLIDER
            sliderCard(
              title: "Interest Rate (% P.A.)",
              slider: Slider(
                min: 1,
                max: 15,
                divisions: 140,
                value: interestRate,
                activeColor: Colors.blue.shade800,
                onChanged: (v) => setState(() => interestRate = v),
              ),
              value: "${interestRate.toStringAsFixed(1)}%",
            ),

            const SizedBox(height: 20),

            // CALCULATE BUTTON
            Center(
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Calculate EMI",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // EMI RESULT + PIE CHART
            if (calculated)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Home Loan EMI: ₹ $emi",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: SizedBox(
                        height: 270,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 45,
                            sectionsSpace: 2,
                            sections: getPieData(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Total Payment: ₹ $totalPayment",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Total Interest: ₹ $totalInterest",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
