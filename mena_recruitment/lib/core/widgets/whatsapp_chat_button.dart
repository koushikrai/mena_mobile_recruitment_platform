import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';

class WhatsAppChatButton extends StatelessWidget {
  final String? jobTitle;
  final String? referenceCode;
  final String? customMessage;
  final bool isCompact;

  const WhatsAppChatButton({
    super.key,
    this.jobTitle,
    this.referenceCode,
    this.customMessage,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return InkWell(
        onTap: () => WhatsAppService.showWhatsAppAssistantSheet(
          context: context,
          title: jobTitle,
          referenceCode: referenceCode,
          initialMessage: customMessage,
        ),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFA5D6A7)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_rounded, color: Color(0xFF2E7D32), size: 16),
              SizedBox(width: 6),
              Text(
                'WhatsApp HR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => WhatsAppService.showWhatsAppAssistantSheet(
        context: context,
        title: jobTitle,
        referenceCode: referenceCode,
        initialMessage: customMessage,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
      ),
      icon: const Icon(Icons.chat_rounded, size: 20),
      label: const Text(
        'Chat on WhatsApp',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
