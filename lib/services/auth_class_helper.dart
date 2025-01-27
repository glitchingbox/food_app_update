import 'package:firebase_auth/firebase_auth.dart';


class AuthClassHelper {
  static Future<String> userSigninWithPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //logOut

  static Future logOut() async {
    try {
      return FirebaseAuth.instance.signOut();
    } on FirebaseAuth catch (e) {
      return e.toString();
    }
  }


  
}
