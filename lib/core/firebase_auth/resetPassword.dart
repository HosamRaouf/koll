

import 'package:firebase_auth/firebase_auth.dart';

Future<void> resetPassword(String email, {required Function() onSuccess, required Function(FirebaseAuthException error) onError}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    print('Password reset email sent successfully');
    onSuccess();
  } on FirebaseAuthException catch (e) {
    onError(e);
  }
}


checkResponseStat(FirebaseAuthException e, {required String errorMessage}) {
  errorMessage = "";
  if (e.code == 'user-not-found') {
    errorMessage = 'هذا المستخدم غير موجود';
  }
  else if (e.code == 'network-request-failed') {
    errorMessage = 'خطأ في الشبكة، حاول مرة أخرى';
  }
  else if (e.code == 'invalid-email') {
    errorMessage = 'من فضلك أدخل البريد الإلكتروني بشكل صحيح';
  }
  else if (e.code == 'invalid-credential') {
    errorMessage = 'لا يوجد بريد إلكتروني بهذا الإسم';
  }
  else if (e.code == 'too-many-requests') {
    errorMessage = 'لقد تخطيت الحد الأقصى من المحاولات، حاول في وقت لاحق' ;
  }
  else {
    errorMessage = "";
  }
}