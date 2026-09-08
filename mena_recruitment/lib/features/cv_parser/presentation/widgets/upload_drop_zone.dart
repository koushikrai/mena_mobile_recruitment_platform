import 'package:flutter/material.dart';

class UploadDropZone extends StatelessWidget {
  final VoidCallback onTap;

  const UploadDropZone({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            width: 2,
            style: BorderStyle.solid, 
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFF990000)),
            SizedBox(height: 16),
            Text(
              'Choose PDF, DOCX, or Image - max 15MB',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF990000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
