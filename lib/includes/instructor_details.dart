import 'package:flutter/material.dart';
import 'package:skillsbank/models/instructor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skillsbank/components/toasts.dart';

// NOTE: You should rename the private widget _ContactDetailRow to public ContactDetailRow
// and move it to its own file (e.g., contact_detail_row.dart) so it can be used here.

// If you didn't separate _ContactDetailRow, you must paste its definition here.

class InstructorDetailsContent extends StatelessWidget {
  final Instructor thisInstructor;

  const InstructorDetailsContent({super.key, required this.thisInstructor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            thisInstructor.name??"Unknown Instructor",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            thisInstructor.about ?? "",
            style: const TextStyle(
              color: Color.fromARGB(255, 224, 232, 236),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
                ContactDetailRow(
            icon: Icons.phone,
            text: thisInstructor.phone,
            scheme: 'tel',
          ),
          ContactDetailRow(
            icon: Icons.email,
            text: thisInstructor.email,
            scheme: 'mailto',
          ),
          ContactDetailRow(
            icon: Icons.location_pin,
            text: thisInstructor.address,
            scheme: 'map',
          ),
          ContactDetailRow(
            icon: Icons.public,
            text: thisInstructor.website,
            scheme: 'https',
          ),
        ],
      ),
    );
  }
}

class ContactDetailRow extends StatelessWidget {
  final IconData icon;
  final String? text;
  final String scheme; // 'tel', 'mailto', 'https', 'map'

  const ContactDetailRow({
    super.key,
    required this.icon,
    required this.text,
    required this.scheme,
  });

  // The launch function remains the same
  Future<void> _launchURL(BuildContext context, String value) async {
    String encodedValue;

    switch (scheme) {
      case 'tel':
        encodedValue = 'tel:$value';
        break;
      case 'mailto':
        encodedValue = 'mailto:$value';
        break;
      case 'map':
        encodedValue =
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(value)}';
        break;
      default: // Handles 'https' (Website)
        encodedValue = value.startsWith('http') ? value : 'https://$value';
        break;
    }

    final Uri uri = Uri.parse(encodedValue);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      errorToast('Could not launch: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _launchURL(context, text!),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.6)),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                text!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  decorationColor: Colors.white.withOpacity(0.5),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
