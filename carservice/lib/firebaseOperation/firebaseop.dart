import 'dart:developer';
import 'dart:io';

import 'package:carservice/packages/packages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOP {
  // make firebase auth instance
  static final firebaseAuth = FirebaseAuth.instance;
  //make firestore instance
  static final firestoredb = FirebaseFirestore.instance;
  //verification if
  static var verificationIdUser = '';

  // add user data into firestore
  static Future<void> addUserInfo() async {
    GetUserinfo info = GetUserinfo(
      id: firebaseAuth.currentUser!.uid.toString(),
      name: firebaseAuth.currentUser!.displayName.toString(),
      emial: firebaseAuth.currentUser!.email.toString(),
      image: firebaseAuth.currentUser!.photoURL.toString(),
      phone: firebaseAuth.currentUser!.phoneNumber.toString(),
    );

    return await firestoredb
        .collection("Users")
        .doc(firebaseAuth.currentUser!.uid)
        .set(info.toJson());
  }

  // check User Exit or not
  // check the login user is exit or not
  static Future<bool> userExits() async {
    return (await firestoredb
            .collection("Users")
            .doc(firebaseAuth.currentUser!.uid)
            .get())
        .exists;
  }

  //create Account firebase
  static Future<UserCredential> createAccountFirebase(
      String email, String pass) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: pass);
  }

  // login Account
  static Future<UserCredential> loginAccountFirebase(
      String email, String pass) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pass);
  }

  // Signin With Google
  static Future<UserCredential?> signInWithGoogle() async {
    await InternetAddress.lookup("google.com");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Reset Password
  static Future<void> fergotPass(String email, BuildContext context) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        SnackBars(context, "Reset Mail Send Successflly");
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ));
      });
    } on FirebaseAuthException catch (e) {
      SnackBars(context, e.code).showSnackBars();
    }
  }

  // sign in with Phone Number
  static Future<void> loginWithPhone(String phone, BuildContext context) async {
    await firebaseAuth
        .verifyPhoneNumber(
      phoneNumber: "+91${phone.toString()}",
      verificationCompleted: (credential) async {
        log("verification complete");
        await firebaseAuth.signInWithCredential(credential);
      },
      codeSent: (verificationId, forceResendingToken) {
        log("code send");
        verificationIdUser = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log("time out");
        verificationIdUser = verificationId;
      },
      verificationFailed: (error) {
        log("verification fail ${error.code}");
        if (error.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          SnackBars(context, "The provided phone number is not valid.")
              .showSnackBars();
        } else {
          SnackBars(context, "Something Went Wrong").showSnackBars();
        }
      },
    )
        .then((value) {
      SnackBars(context, "Login Successfully With Phone Number");
    });
  }

  // veryfy OTP
  static Future<bool> verifyOTP(String otp) async {
    var credential = await firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationIdUser, smsCode: otp));

    return credential.user != null ? true : false;
  }
}
