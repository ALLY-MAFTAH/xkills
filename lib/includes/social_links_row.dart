import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/components/toasts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

class SocialLinksRow extends StatefulWidget {
  final String facebookUrl;
  final String xUrl;
  final String instagramUrl;
  final String youtubeUrl;
  final String whatsappNumber; // Used to construct the WhatsApp URL
  final String linkedinUrl;
  final String telegramUrl;

  const SocialLinksRow({
    super.key,
    required this.facebookUrl,
    required this.xUrl,
    required this.instagramUrl,
    required this.youtubeUrl,
    required this.whatsappNumber,
    required this.linkedinUrl,
    required this.telegramUrl,
  });

  @override
  State<SocialLinksRow> createState() => _SocialLinksRowState();
}

class _SocialLinksRowState extends State<SocialLinksRow> {
  // Helper function to safely launch a URL
  Future<void> _launchURL(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      // Use your custom toast function
      errorToast("Link not provided.");
      return;
    }

    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        errorToast("Could not launch $urlString");
      }
    }
  }

  // Helper to construct and launch the WhatsApp link
  void _launchWhatsApp() {
    final String phone = widget.whatsappNumber;
    if (phone.isNotEmpty) {
      final String whatsappUrl = 'whatsapp://send?phone=$phone';
      _launchURL(whatsappUrl);
    }
  }

  // Define the list of social links configuration once
  List<_SocialLinkConfig> get _socialLinks {
    return [
      // Platform (Icon, Color, URL/Action)
      _SocialLinkConfig(
        icon: FontAwesomeIcons.facebook,
        color: const Color(0xFF1877F2),
        url: widget.facebookUrl,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.xTwitter,
        color: Colors.white,
        url: widget.xUrl,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.instagram,
        color: const Color(0xFFE4405F),
        url: widget.instagramUrl,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.youtube,
        color: const Color(0xFFFF0000),
        url: widget.youtubeUrl,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.whatsapp,
        color: const Color(0xFF25D366),
        // Use a special action for WhatsApp instead of a direct URL
        action: _launchWhatsApp,
        // Provide the phone number as a check for onPressed availability
        url: widget.whatsappNumber,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.linkedin,
        color: const Color(0xFF0A66C2),
        url: widget.linkedinUrl,
      ),
      _SocialLinkConfig(
        icon: FontAwesomeIcons.telegram,
        color: const Color(0xFF229ED9),
        url: widget.telegramUrl,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor.withOpacity(0.2),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Optional Label
            const Text(
              "Social: ",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),

            ..._socialLinks.map((link) {
              VoidCallback? onPressed;

              if (link.action != null) {
                onPressed = link.url.isNotEmpty ? link.action : null;
              } else {
                onPressed =
                    link.url.isNotEmpty ? () => _launchURL(link.url) : null;
              }

              return IconButton(
                padding: const EdgeInsets.all(2),
                style: IconButton.styleFrom(
                  minimumSize: const Size(40, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: FaIcon(link.icon, color: link.color, size: 18),
                onPressed: onPressed,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SocialLinkConfig {
  final IconData icon;
  final Color color;
  final String url;
  final VoidCallback? action;

  _SocialLinkConfig({
    required this.icon,
    required this.color,
    required this.url,
    this.action,
  });
}
