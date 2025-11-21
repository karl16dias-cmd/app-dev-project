import '../config/supabase_config.dart';

class UserService {
  Future<void> updateUsername(String username) async {
    final uid = supabase.auth.currentUser!.id;

    await supabase
        .from('profiles')
        .update({'username': username})
        .eq('user_id', uid);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final uid = supabase.auth.currentUser!.id;

    final res = await supabase
        .from('profiles')
        .select()
        .eq('user_id', uid)
        .single();

    return res;
  }
}
