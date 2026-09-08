import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_upload_provider.dart';
import '../widgets/experience_form_card.dart';
import '../widgets/education_form_card.dart';
import '../widgets/skills_tag_input.dart';

class CVReviewScreen extends ConsumerWidget {
  const CVReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsedCV = ref.watch(parsedCVProvider);

    if (parsedCV == null) {
      return const Scaffold(body: Center(child: Text('No parsed CV data.')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF0F1E36)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Step 2 of 2',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF0F1E36),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Review AI extracted data',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(initialValue: parsedCV.fullName, decoration: _inputDec('Full Name')),
            const SizedBox(height: 12),
            TextFormField(initialValue: parsedCV.email, decoration: _inputDec('Email')),
            const SizedBox(height: 12),
            TextFormField(initialValue: parsedCV.phone, decoration: _inputDec('Phone')),
            
            const SizedBox(height: 24),
            const Text('Professional Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(initialValue: parsedCV.targetTitle, decoration: _inputDec('Target Role')),
            
            const SizedBox(height: 24),
            const Text('Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...parsedCV.experiences.map((exp) => ExperienceFormCard(
              title: exp.title,
              company: exp.company,
              duration: '${exp.startDate} - ${exp.endDate}',
              onDelete: () {},
            )),
            
            const SizedBox(height: 24),
            const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...parsedCV.education.map((edu) => EducationFormCard(
              degree: edu.degree,
              institution: edu.institution,
              year: edu.year,
              status: edu.attestationStatus,
            )),
            
            const SizedBox(height: 24),
            const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SkillsTagInput(skills: parsedCV.skills, onRemove: (skill) {}),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F1E36),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save & Complete Profile', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
