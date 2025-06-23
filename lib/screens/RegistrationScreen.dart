import 'package:diagnosify_app/screens/Chat_Screen.dart';
import 'package:diagnosify_app/screens/home_view.dart';
import 'package:flutter/material.dart';

class RegistrationScreen2 extends StatefulWidget {
  @override
  _RegistrationScreen2State createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  final formKey = GlobalKey<FormState>();

  bool _isFirstTimeRegistration = true; // Simulate first-time registration
  final _diseaseController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _contingencyPlanController = TextEditingController();

  void _submitForm() {
    // Here you can add the logic to process the form data
    print('Disease: ${_diseaseController.text}');
    print('Diagnosis: ${_diagnosisController.text}');
    print('Medications: ${_medicationsController.text}');
    print('Symptoms: ${_symptomsController.text}');
    print('Contingency Plan: ${_contingencyPlanController.text}');
    // You can also navigate to another screen or show a success message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildHealthQuestionnaire(),
    );
  }

  Widget _buildHealthQuestionnaire() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/IMG-20250226-WA0009-removebg-preview.png',
              ),
              Text(
                'please answer the following questions',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'What disease do you suffer from?',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your disease' : null,
                controller: _diseaseController,
                decoration: InputDecoration(
                  hintText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'When were you diagnosed with this disease?',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your diagnosis date' : null,
                controller: _diagnosisController,
                decoration: InputDecoration(
                  hintText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'What medications do you take?',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your medications' : null,
                controller: _medicationsController,
                decoration: InputDecoration(
                  hintText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'What are the most common symptoms that affect you?',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your symptoms' : null,
                controller: _symptomsController,
                decoration: InputDecoration(
                  hintText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Do you have a contingency plan in case further fatigue occurs?',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                validator: (value) => value!.isEmpty
                    ? 'Please enter your contingency plan'
                    : null,
                controller: _contingencyPlanController,
                decoration: InputDecoration(
                  hintText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submitForm();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                      setState(() {
                        _isFirstTimeRegistration =
                            false; // Mark registration as complete
                      });
                    }
                  },
                  child: Text('Next',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 38, vertical: 12),
                    backgroundColor: Color(0xff048497),
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
    _diseaseController.dispose();
    _diagnosisController.dispose();
    _medicationsController.dispose();
    _symptomsController.dispose();
    _contingencyPlanController.dispose();
    super.dispose();
  }
}
