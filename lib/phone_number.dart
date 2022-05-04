import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final phoneNumberController = TextEditingController();
  String smsCode = '';
  String verificationId = '';

  void _verifyPhoneNumber() async {
    String phone = "+81" + phoneNumberController.text;
    print(phone);
    final firebaseAuth = FirebaseAuth.instance;

    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verid) {
      this.verificationId = verid;
    };

    final PhoneCodeSent smsCodeSent = (String verid, forceCodeResend) {
      this.verificationId = verid;
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      print('verified');
    };

    final PhoneVerificationFailed verifiedFailed =
        (FirebaseAuthException exception) {
      print('miss');
      print('${exception.message}');
    };

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiedFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieval,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
             Expanded(
                child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    decoration: const InputDecoration())),
            ElevatedButton(
                onPressed: () {
                  _verifyPhoneNumber();
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
