import 'package:diagnosify_app/core/manager/get_question_cubit/get_question_cubit.dart';
import 'package:diagnosify_app/core/services/question_services/model/question_model.dart';
import 'package:diagnosify_app/screens/RegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isFirstTimeRegistration = true;
  String? _chronicDisease;
  String? _smoker;
  String? _regularMedication;

  @override
  void initState() {
    super.initState();
    context.read<GetQuestionCubit>().getQestions();
  }

  void _submitForm() {
    print('Chronic Disease: $_chronicDisease');
    print('Smoker: $_smoker');
    print('Regular Medication: $_regularMedication');
  }

  bool _validateAnswers() {
    if (_chronicDisease == null ||
        _smoker == null ||
        _regularMedication == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please answer all questions before proceeding."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<GetQuestionCubit, GetQuestionState>(
        listener: (context, state) {
          if (state is GetQuestionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Failed to load questions: ${state.errorMessage['message']}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetQuestionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetQuestionSuccess) {
            List<QuestionModel> questions = state.questionModel;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                      'assets/IMG-20250226-WA0009-removebg-preview.png'),
                  const Text(
                    'Good Morning, Lara',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (questions.length > 0)
                    _buildQuestion(
                      question: questions[0].name,
                      groupValue: _chronicDisease,
                      onChanged: (val) => setState(() => _chronicDisease = val),
                    ),
                  if (questions.length > 1)
                    _buildQuestion(
                      question: questions[1].name,
                      groupValue: _smoker,
                      onChanged: (val) => setState(() => _smoker = val),
                    ),
                  if (questions.length > 2)
                    _buildQuestion(
                      question: questions[2].name,
                      groupValue: _regularMedication,
                      onChanged: (val) =>
                          setState(() => _regularMedication = val),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateAnswers()) {
                          _submitForm();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen2()),
                          );
                          setState(() {
                            _isFirstTimeRegistration = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 38, vertical: 12),
                        backgroundColor: const Color(0xff048497),
                      ),
                      child: const Text('Next',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No questions available.'));
          }
        },
      ),
    );
  }

  Widget _buildQuestion({
    required String question,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            Radio<String>(
              value: 'Yes',
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            const Text('Yes'),
            Radio<String>(
              value: 'No',
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            const Text('No'),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
