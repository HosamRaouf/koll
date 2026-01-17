import 'package:firebase_auth/firebase_auth.dart';


Future<void> signInWithEmailPassword(String email, String password, {required Function() onSuccess, required Function(FirebaseAuthException e) onError, required Function() onLoading, required Function() onLoadingComplete}) async {
  onLoading();
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User signed in: ${userCredential.user}');
    onSuccess();
    onLoadingComplete();
  } on FirebaseAuthException catch (e) {
    onLoadingComplete();
    onError(e);
  }
}