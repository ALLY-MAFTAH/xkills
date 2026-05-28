import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import '../utils/web_store.dart';

/// App Store guideline 5.1.1(v): clear account deletion with confirmation steps.
Future<void> showDeleteAccountDialog(
  BuildContext context,
  AuthController authController,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _DeleteAccountDialogContent(authController: authController),
  );
}

class _DeleteAccountDialogContent extends StatefulWidget {
  final AuthController authController;

  const _DeleteAccountDialogContent({required this.authController});

  @override
  State<_DeleteAccountDialogContent> createState() =>
      _DeleteAccountDialogContentState();
}

class _DeleteAccountDialogContentState extends State<_DeleteAccountDialogContent> {
  static const String _requiredPhrase = 'DELETE';

  bool _understood = false;
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (!_understood) return false;
    return _confirmController.text.trim() == _requiredPhrase;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryColor,
      title: Text(
        'delete_account_title'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'delete_account_intro'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            _bullet('delete_account_bullet_profile'.tr),
            _bullet('delete_account_bullet_enrollments'.tr),
            _bullet('delete_account_bullet_cart_wishlist'.tr),
            _bullet('delete_account_bullet_reviews'.tr),
            _bullet('delete_account_bullet_irreversible'.tr),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                openWebStorePath('/contact-us/');
              },
              icon: Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.tertiaryColor,
              ),
              label: Text(
                'delete_account_help_website'.tr,
                style: TextStyle(
                  color: AppColors.tertiaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _understood,
              onChanged: (v) => setState(() => _understood = v ?? false),
              activeColor: AppColors.tertiaryColor,
              checkColor: const Color(0xFF071B1A),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'delete_account_checkbox'.tr,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'delete_account_type_label'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: AppColors.tertiaryColor,
              decoration: InputDecoration(
                hintText: 'delete_account_type_hint'.tr,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.tertiaryColor.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('delete_account_cancel'.tr),
        ),
        TextButton(
          onPressed: !_canSubmit
              ? null
              : () async {
                  Navigator.of(context).pop();
                  await widget.authController.deleteAccount();
                },
          child: Text(
            'delete_account_confirm_button'.tr,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: AppColors.tertiaryColor,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
