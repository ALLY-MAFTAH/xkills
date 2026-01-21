import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '/components/toasts.dart';
import '/includes/auth_inputs_decoration.dart';
import '/includes/account_screen_includes.dart';
import '/controllers/auth_controller.dart';
import '/constants/auth_user.dart';
import '/views/auth/signin_page.dart';
import '/models/user.dart';
import '/components/custom_loader.dart';
import '/constants/app_brand.dart';
import '/theme/app_colors.dart';
import 'payment_history_screen.dart';
import 'saved_courses_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final authController = Get.put(AuthController());
  User? thisUser;
  bool isInEditMode = false;
  final ImagePicker _picker = ImagePicker();
  final FocusNode phoneFocusNode = FocusNode();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  String selectedLanguage = 'EN';
  Locale currentLocale = Get.locale!;
  String _selectedLanguage = Get.locale!.languageCode;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    authController.nameEditController.text = thisUser?.name ?? '';
    authController.phoneEditController.text = thisUser?.phone ?? '';
    authController.emailEditController.text = thisUser?.email ?? '';
    authController.addressEditController.text = thisUser?.address ?? '';
  }

  void handleLogout(BuildContext context) {
    final storage = GetStorage();
    storage.erase();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SigninPage()),
    );
  }

  void _loadInitialData() {
    thisUser = Auth().user;
  }

  Future<void> _refreshData() async {
    authController.nameEditController.text = thisUser?.name ?? '';
    await authController.getUserData();
    _loadInitialData();
    if (mounted) {
      setState(() {});
    }
  }

  void _changePasswordDialog() async {
    Get.bottomSheet(
      backgroundColor: AppColors.secondaryColor,
      isScrollControlled: true,
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: changePasswordFormKey,
              child: Center(
                child: SingleChildScrollView(
                  child: GetBuilder<AuthController>(
                    builder: (authController) {
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              'Change Password'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color:
                                    authController.isLoading
                                        ? Colors.grey[700]
                                        : Colors.white,
                                fontSize: 12,
                              ),
                              enabled: !authController.isLoading,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              controller:
                                  authController.currentPasswordController,
                              onSaved: (input) {
                                setState(() {
                                  authController
                                      .currentPasswordController
                                      .text = input as String;
                                });
                              },
                              obscureText:
                                  authController.currentPasswordObscure,
                              decoration: getInputDecoration(
                                authController,
                                'Current Password',
                                () {
                                  authController.currentPasswordObscure =
                                      !authController.currentPasswordObscure;
                                  authController.update();
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color:
                                    authController.isLoading
                                        ? Colors.grey[700]
                                        : Colors.white,
                                fontSize: 12,
                              ),
                              enabled: !authController.isLoading,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              controller: authController.newPasswordController,
                              onSaved: (input) {
                                setState(() {
                                  authController.newPasswordController.text =
                                      input as String;
                                });
                              },
                              obscureText: authController.newPasswordObscure,
                              decoration: getInputDecoration(
                                authController,
                                'New Password',
                                () {
                                  authController.newPasswordObscure =
                                      !authController.newPasswordObscure;
                                  authController.update();
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color:
                                    authController.isLoading
                                        ? Colors.grey[700]
                                        : Colors.white,
                                fontSize: 12,
                              ),
                              enabled: !authController.isLoading,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              controller:
                                  authController.confirmPasswordController,
                              onSaved: (input) {
                                setState(() {
                                  authController
                                      .confirmPasswordController
                                      .text = input as String;
                                });
                              },
                              obscureText:
                                  authController.confirmPasswordObscure,
                              decoration: getInputDecoration(
                                authController,
                                'Confirm Password',
                                () {
                                  authController.confirmPasswordObscure =
                                      !authController.confirmPasswordObscure;
                                  authController.update();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: Center(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primaryColor,
                                            AppColors.secondaryColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed:
                                        authController.isLoading
                                            ? null
                                            : () {
                                              if (authController
                                                  .currentPasswordController
                                                  .text
                                                  .isEmpty) {
                                                errorToast(
                                                  "Current Password Field Cannot Be Empty"
                                                      .tr,
                                                );
                                              }
                                              if (authController
                                                  .newPasswordController
                                                  .text
                                                  .isEmpty) {
                                                errorToast(
                                                  "New Password Field Cannot Be Empty"
                                                      .tr,
                                                );
                                              } else if (authController
                                                  .confirmPasswordController
                                                  .text
                                                  .isEmpty) {
                                                errorToast(
                                                  "Confirm Password Field Cannot Be Empty"
                                                      .tr,
                                                );
                                              } else if (authController
                                                      .newPasswordController
                                                      .text
                                                      .trim() !=
                                                  authController
                                                      .confirmPasswordController
                                                      .text
                                                      .trim()) {
                                                errorToast(
                                                  "Passwords Do Not Match".tr,
                                                );
                                              } else {
                                                setState(() {
                                                  authController
                                                      .changePassword();
                                                });
                                              }
                                            },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      side: BorderSide.none,
                                    ),
                                    child:
                                        authController.isLoading
                                            ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [customLoader()],
                                            )
                                            : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Change Password'.tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeLanguageDialog(BuildContext context) {
    final List<Map<String, dynamic>> languages = [
      {'name': 'English'.tr, 'code': 'en', 'flag': '🇬🇧'},
      {'name': 'Swahili'.tr, 'code': 'sw', 'flag': '🇹🇿'},
    ];

    List<Map<String, dynamic>> filteredLanguages = [...languages];

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.grey[300],

          title: Text(
            'Change Language'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.secondaryColor,
            ),
          ),
          titlePadding: EdgeInsets.only(left: 10, top: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              ...filteredLanguages.map((lang) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        _selectedLanguage == lang['code']
                            ? AppColors.secondaryColor
                            : AppColors.secondaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    minTileHeight: 45,
                    leading: Text(lang['flag'], style: TextStyle(fontSize: 24)),
                    title: Text(
                      lang['name'],
                      style: TextStyle(
                        color:
                            _selectedLanguage == lang['code']
                                ? Colors.white
                                : AppColors.secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    trailing:
                        _selectedLanguage == lang['code']
                            ? Icon(Icons.check_circle, color: Colors.white)
                            : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang['code'];
                      });
                      Get.back();
                      authController.changeLanguage(_selectedLanguage == 'sw');
                    },
                  ),
                );
              }),

              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.secondaryColor,
      backgroundColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: GestureDetector(
          onTap: () {
            isInEditMode = false;
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // 1. Sliver AppBar Spacer
                    SliverAppBar(
                      expandedHeight: 80.0,
                      collapsedHeight: 0.0,
                      toolbarHeight: 0.0,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Container(),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GetBuilder<AuthController>(
                            builder: (authController) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Profile'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  buildProfileCard(
                                    context: context,
                                    thisUser: thisUser,
                                    loadInitialData: _loadInitialData,
                                    picker: _picker,
                                    phoneFocusNode: phoneFocusNode,
                                    isInEditMode: isInEditMode,
                                    onEditModeChanged: (val) {
                                      isInEditMode = val;
                                    },
                                    setState: (void Function() fn) {
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 25),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Account Settings".tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  buildActionCard(
                                    title: 'Change Language'.tr,
                                    icon: Icons.language_rounded,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) =>
                                                changeLanguageDialog(context),
                                      );
                                    },
                                  ),

                                  buildActionCard(
                                    title: 'Payment History'.tr,
                                    icon: Icons.history,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => PaymentHistoryScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  buildActionCard(
                                    title: 'Saved Courses'.tr,
                                    icon: Icons.school_rounded,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SavedCoursesScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  buildActionCard(
                                    title: 'Change Password'.tr,
                                    icon: Icons.lock_outline,
                                    onTap: () {
                                      _changePasswordDialog();
                                    },
                                  ),

                                  const SizedBox(height: 30),

                                  Card(
                                    color: Colors.red.withOpacity(0.12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: ListTile(
                                      shape: ShapeBorder.lerp(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        0,
                                      ),
                                      minTileHeight: 50,
                                      leading: const Icon(
                                        Icons.logout,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                      title: const Text(
                                        'Log Out',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onTap: () => handleLogout(context),
                                    ),
                                  ),

                                  SizedBox(
                                    height: Platform.isAndroid ? 70 : 110,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                appBrand(context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
