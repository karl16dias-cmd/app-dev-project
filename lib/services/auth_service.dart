import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  // ------------------ SIGN UP ------------------ //
  Future<String?> signUp(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      // If user is created successfully → Add profile row to Supabase
      if (user != null) {
        await supabase.from('profiles').insert({
          'user_id': user.id,
          'email': email,
          'username': '', // Default empty username
        });
      }

      return null; // Successfully signed up
    } catch (e) {
      return e.toString(); // Return readable error
    }
  }

  // ------------------ SIGN IN ------------------ //
  Future<String?> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // ------------------ SIGN OUT ------------------ //
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
