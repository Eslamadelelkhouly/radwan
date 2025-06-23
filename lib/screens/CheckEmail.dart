import 'package:diagnosify_app/screens/ForgotPassword.dart';
import 'package:diagnosify_app/screens/SetNewPassword.dart';
import 'package:flutter/material.dart';

class CheckEmailScreen extends StatefulWidget {
  @override
  _CheckEmailScreenState createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      // Here you can add the logic to verify the code
      String code = _codeController.text;
      print('Verification code entered: $code');
      // You can also navigate to another screen or show a success message
    }
  }

  void _resendEmail() {
    // Here you can add the logic to resend the email
    print('Resend email requested');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Your Email',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We sent a reset link to contact@dscode...com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Enter 5 digit code that mentioned in the email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: 'Enter 5 digit code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the code';
                  }
                  if (value.length != 5) {
                    return 'Please enter a valid 5 digit code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetNewPasswordScreen()),
                    );
                    // Navigate to forgot password screen
                  },
                  child: Text('Verify Code',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff048497),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                    // Navigate to forgot password screen
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Haven’t got the email yet? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        ' Resend email',
                        style: TextStyle(color: Color(0xff048497)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
