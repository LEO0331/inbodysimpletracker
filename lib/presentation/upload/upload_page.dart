import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_page.dart';
import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedImage;
  String _extractedText = "";
  Map<String, dynamic> _parsedMetrics = {};

  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _processImage(_selectedImage!);
    }
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _extractedText = recognizedText.text;
    });

    // Parse metrics
    final metrics = _parseMetrics(recognizedText.text);
    setState(() {
      _parsedMetrics = metrics;
    });

    // Save to Firestore if user is logged in
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      final report = InbodyReport(
        id: '',
        reportDate: DateTime.parse(metrics["reportDate"]),
        weight: metrics["weight"],
        bodyFatPercent: metrics["bodyFatPercent"],
        muscleMass: metrics["muscleMass"],
        visceralFat: metrics["visceralFat"],
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.user!.uid)
          .collection("reports")
          .add(report.toMap());
    }
  }

  Map<String, dynamic> _parseMetrics(String text) {
    final weightRegex = RegExp(r'Weight[:\s]*([\d.]+)');
    final fatRegex = RegExp(r'Body\s*Fat[:\s]*([\d.]+)');
    final muscleRegex = RegExp(r'Muscle\s*Mass[:\s]*([\d.]+)');
    final visceralRegex = RegExp(r'Visceral\s*Fat[:\s]*([\d.]+)');

    double? weight;
    double? bodyFat;
    double? muscleMass;
    double? visceralFat;

    final weightMatch = weightRegex.firstMatch(text);
    if (weightMatch != null) weight = double.tryParse(weightMatch.group(1)!);

    final fatMatch = fatRegex.firstMatch(text);
    if (fatMatch != null) bodyFat = double.tryParse(fatMatch.group(1)!);

    final muscleMatch = muscleRegex.firstMatch(text);
    if (muscleMatch != null) muscleMass = double.tryParse(muscleMatch.group(1)!);

    final visceralMatch = visceralRegex.firstMatch(text);
    if (visceralMatch != null) visceralFat = double.tryParse(visceralMatch.group(1)!);

    return {
      "weight": weight ?? 0,
      "bodyFatPercent": bodyFat ?? 0,
      "muscleMass": muscleMass ?? 0,
      "visceralFat": visceralFat ?? 0,
      "reportDate": DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload InBody Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Show sample image if no user image selected
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage == null
                  ? Image.asset("assets/images/sample_report.jpg", fit: BoxFit.cover)
                  : Image.file(_selectedImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Pick Report Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 20),

            // OCR extracted text
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _extractedText.isEmpty ? "No text extracted yet" : _extractedText,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    if (_parsedMetrics?.isNotEmpty ?? false) ...[
                      Text("Weight: ${_parsedMetrics["weight"]} kg"),
                      Text("Body Fat: ${_parsedMetrics["bodyFatPercent"]} %"),
                      Text("Muscle Mass: ${_parsedMetrics["muscleMass"]} kg"),
                      Text("Visceral Fat: ${_parsedMetrics["visceralFat"]}"),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Go to Login"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
