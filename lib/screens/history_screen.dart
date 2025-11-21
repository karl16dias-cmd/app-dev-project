import 'package:flutter/material.dart';
import '../config/supabase_config.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // ---------------- LOAD HISTORY FROM SUPABASE ---------------- //
  loadHistory() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    final data = await supabase
        .from('emi_history')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    setState(() {
      history = data;
      loading = false;
    });
  }

  // ---------------- UI ---------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(
              child: Text(
                "No EMI calculations found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final h = history[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      "Loan: ₹${h['loan_amount'].round()}  |  EMI: ₹${h['emi']}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Interest Rate: ${h['interest_rate']}%\n"
                        "Tenure: ${h['tenure_years']} years\n"
                        "Total Interest: ₹${h['total_interest']}\n"
                        "Total Payment: ₹${h['total_payment']}\n"
                        "Saved on: ${h['created_at']}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
