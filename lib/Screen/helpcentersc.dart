import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_bus/components/color.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final Uuid uuid = const Uuid();

  void _submitFeedback() async {
    String feedback = _feedbackController.text;
    if (feedback.isEmpty) {
      _showError (AppLocalizations.of(context)!.plsenterurfeedback) ;
      return;
    }

    String id = uuid.v4();
    Timestamp time = Timestamp.now();

    await FirebaseFirestore.instance.collection('feedback').doc(id).set({
      'feedback': feedback,
      'id': id,
      'time': time,
    });

    _showSuccess(AppLocalizations.of(context)!.thxforfeedback);
    _feedbackController.clear();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.feedback,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.entercomplaint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent,
                        border: Border.all(color: primaryColor, width: 3),
                        ),
              child: TextButton(
                onPressed: _submitFeedback,
                child: Text(AppLocalizations.of(context)!.submit,
                  style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}