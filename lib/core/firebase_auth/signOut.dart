import 'package:firebase_auth/firebase_auth.dart';

Future<void> signOut({required Function(FirebaseAuthException e) onError, required Function() onComplete, }) async {
  try {
    await FirebaseAuth.instance.signOut();
    onComplete();
    print('User signed out');

  }on FirebaseAuthException catch(e) {
    onError(e);
  }
}
