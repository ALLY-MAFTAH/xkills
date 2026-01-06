import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../components/toasts.dart';
import '../../includes/auth_inputs_decoration.dart';
import '/components/slide_animations.dart';
import '/enums/enums.dart';
import '../../controllers/auth_controller.dart';
import '/constants/auth_user.dart';
import '/views/auth/signin_page.dart';
import '../../models/user.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../theme/app_colors.dart';

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

  void _showImageSourceOptions() async {
    Get.bottomSheet(
      backgroundColor: AppColors.secondaryColor,
      isScrollControlled: true,
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Wrap(
              runSpacing: 20,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    'Choose From Gallery'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  tileColor: Colors.white.withOpacity(.1),
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    0,
                  ),
                  onTap: () async {
                    Get.back();
                    authController.selectedProfileImage = await _picker
                        .pickImage(source: ImageSource.gallery);
                    if (authController.selectedProfileImage != null) {
                      await authController.updateProfilePhoto();
                      _loadInitialData();
                    }
                  },
                ),
                ListTile(
                  tileColor: Colors.white.withOpacity(.1),
                  leading: Icon(Icons.camera_alt, color: Colors.white),
                  title: Text(
                    'Capture Using Camera'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    0,
                  ),
                  onTap: () async {
                    Get.back();
                    authController.selectedProfileImage = await _picker
                        .pickImage(source: ImageSource.camera);
                    if (authController.selectedProfileImage != null) {
                      await authController.updateProfilePhoto();
                      _loadInitialData();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildProfileCard() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.white60, size: 18),
                  const SizedBox(width: 8),

                  Expanded(
                    child: _inlineEditableField(
                      editingController: authController.nameEditController,
                      value: thisUser?.name ?? "N/A",
                      editable: isInEditMode,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 28,
                      borderRadius: BorderRadius.circular(5),
                      isTheFirstRow: true,
                      inputType: InputType.normalText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              _infoRow(
                Icons.phone,
                thisUser?.phone,
                InputType.phone,
                authController.phoneEditController,
              ),
              _infoRow(
                Icons.email,
                thisUser?.email,
                InputType.email,
                authController.emailEditController,
              ),
              _infoRow(
                Icons.location_on,
                thisUser?.address,
                InputType.address,
                authController.addressEditController,
              ),
              _infoRow(
                Icons.settings_accessibility_sharp,
                GetUtils.capitalize(thisUser!.role!),
                InputType.normalText,
                TextEditingController(text: ""),
                isRoleRow: true,
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.tertiaryColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              authController.isUploading
                  ? SizedBox(width: 100, height: 100, child: customLoader())
                  : ClipOval(
                    child:
                        thisUser?.photo != null && thisUser!.photo!.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: thisUser!.photo!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder:
                                  (_, __) => Center(child: customLoader()),
                              errorWidget:
                                  (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white70,
                                  ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white70,
                            ),
                  ),
        ),
        Positioned(
          right: Get.width / 3,
          top: 65,
          child:
              authController.isUploading
                  ? SizedBox.shrink()
                  : BottomTopSlide(
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: AppColors.tertiaryColor.withOpacity(1),
                        child: ListTile(
                          minTileHeight: 30,
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            _showImageSourceOptions();
                            isInEditMode = false;
                          },
                          shape: ShapeBorder.lerp(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            0,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Icon(
                              Icons.photo_camera_outlined,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child:
              authController.isSubmitting || !isInEditMode
                  ? Container()
                  : LeftRightSlide(
                    child: Container(
                      margin: const EdgeInsets.only(top: 60, left: 10),
                      width: 70,
                      height: 32,
                      child: Center(
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white.withOpacity(0.08),
                          child: Center(
                            child: ListTile(
                              minTileHeight: 27,
                              onTap:
                                  authController.isSubmitting
                                      ? null
                                      : () async {
                                        authController.nameEditController
                                            .clear();
                                        authController.phoneEditController
                                            .clear();
                                        authController.emailEditController
                                            .clear();
                                        authController.addressEditController
                                            .clear();
                                        authController.nameEditController.text =
                                            thisUser?.name ?? '';
                                        authController
                                            .phoneEditController
                                            .text = thisUser?.phone ?? '';
                                        authController
                                            .emailEditController
                                            .text = thisUser?.email ?? '';
                                        authController
                                            .addressEditController
                                            .text = thisUser?.address ?? '';
                                        authController.update();
                                        isInEditMode = false;
                                        setState(() {});
                                      },
                              shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                0,
                              ),
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Cancel".tr,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RightLeftSlide(
            child: Container(
              margin: const EdgeInsets.only(top: 60, right: 10),
              width: 70,
              height: 32,
              child: Center(
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.white.withOpacity(0.08),
                  child: Center(
                    child: ListTile(
                      minTileHeight: 27,
                      onTap:
                          authController.isSubmitting
                              ? null
                              : () async {
                                if (isInEditMode) {
                                  await authController.updateProfile();
                                  _loadInitialData();
                                }
                                isInEditMode = !isInEditMode;
                                print(isInEditMode);
                                setState(() {});
                              },
                      shape: ShapeBorder.lerp(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        0,
                      ),
                      contentPadding: EdgeInsets.zero,
                      title:
                          authController.isSubmitting
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customLoader(
                                    radius: 10,
                                    color: AppColors.tertiaryColor,
                                  ),
                                ],
                              )
                              : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (!isInEditMode)
                                    Icon(
                                      FontAwesomeIcons.edit,
                                      color: AppColors.tertiaryColor,
                                      size: 12,
                                    ),
                                  Text(
                                    isInEditMode ? "Save".tr : "Edit".tr,
                                    style: TextStyle(
                                      color: AppColors.tertiaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    IconData icon,
    String? value,
    InputType inputType,
    TextEditingController editingController, {
    bool isRoleRow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 18),
          const SizedBox(width: 8),

          Expanded(
            child: _inlineEditableField(
              inputType: inputType,
              editingController: editingController,
              value: value ?? editingController.text,
              editable: isInEditMode && !isRoleRow,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              height: 24,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineEditableField({
    required TextEditingController editingController,
    required String value,
    required bool editable,
    required InputType inputType,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.bold,
    double height = 26,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(5)),
    bool isTheFirstRow = false,
  }) {
    return SizedBox(
      height: height, // 🔒 lock height
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: editable ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child:
              editable
                  ? KeyboardActions(
                    config: _buildConfig(context),
                    child: TextField(
                      controller: editingController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.done,
                      focusNode:
                          inputType == InputType.phone ? phoneFocusNode : null,
                      keyboardType:
                          inputType == InputType.email
                              ? TextInputType.emailAddress
                              : inputType == InputType.phone
                              ? TextInputType.phone
                              : inputType == InputType.address
                              ? TextInputType.streetAddress
                              : TextInputType.text,
                      inputFormatters: [],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        letterSpacing: 1,
                      ),
                      autofocus: true,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isTheFirstRow ? 2.5 : 4,
                        ),
                      ),
                    ),
                  )
                  : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        height: 1.2,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.08),
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        minTileHeight: 50,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          0,
        ),
        leading: Icon(icon, color: AppColors.tertiaryColor, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.tertiaryColor, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: AppColors.secondaryColor.withOpacity(.2),
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: phoneFocusNode,
          toolbarButtons: [
            (node) {
              return BottomTopSlide(
                child: GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "DONE",
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ],
        ),
      ],
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
                                  _buildProfileCard(),
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

                                  _buildActionCard(
                                    title: 'Change Password'.tr,
                                    icon: Icons.lock_outline,
                                    onTap: () {
                                      _changePasswordDialog();
                                    },
                                  ),

                                  _buildActionCard(
                                    title: 'Payment History'.tr,
                                    icon: Icons.history,
                                    onTap: () {},
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

                                  const SizedBox(height: 50),
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
