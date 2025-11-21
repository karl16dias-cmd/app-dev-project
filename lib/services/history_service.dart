import '../config/supabase_config.dart';

class HistoryService {
  Future<void> saveHistory(
    double loanAmount,
    double interestRate,
    int tenureYears,
    int emi,
    int totalInterest,
    int totalPayment,
  ) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('emi_history').insert({
      'user_id': user.id,
      'loan_amount': loanAmount,
      'interest_rate': interestRate,
      'tenure_years': tenureYears,
      'emi': emi, // FIXED: correct column name
      'total_interest': totalInterest,
      'total_payment': totalPayment,
    });
  }

  Future<List<dynamic>> getHistory() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final data = await supabase
        .from('emi_history')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return data;
  }
}
