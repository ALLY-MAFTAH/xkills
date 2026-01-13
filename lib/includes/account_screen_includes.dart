import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../components/custom_loader.dart';
import '../components/slide_animations.dart';
import '../controllers/auth_controller.dart';
import '../enums/enums.dart';
import '../theme/app_colors.dart';
import 'keyboard_action.dart';

void showImageSourceOptions({
  required VoidCallback onCameraTapped,
  required VoidCallback onGalleryTap,
}) async {
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
                  onGalleryTap();
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
                  onCameraTapped();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget infoRow(
  BuildContext context,
  FocusNode phoneFocusNode,
  bool isInEditMode,
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
          child: inlineEditableField(
            inputType: inputType,
            editingController: editingController,
            value: value ?? editingController.text,
            editable: isInEditMode && !isRoleRow,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 24,
            borderRadius: BorderRadius.circular(5),
            context: context,
            phoneFocusNode: phoneFocusNode,
          ),
        ),
      ],
    ),
  );
}

Widget inlineEditableField({
  required BuildContext context,
  required TextEditingController editingController,
  required FocusNode phoneFocusNode,
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
                  config: buildKeyboardActionConfig(context, phoneFocusNode),
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

Widget buildActionCard({
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

Widget buildProfileCard({
  required BuildContext context,
  required dynamic thisUser,
  required VoidCallback loadInitialData,
  required ImagePicker picker,
  required FocusNode phoneFocusNode,
  required bool isInEditMode,
  required void Function(bool) onEditModeChanged,
  required void Function(void Function() fn) setState,
}) {
  final authController = Get.put(AuthController());

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
                  child: inlineEditableField(
                    editingController: authController.nameEditController,
                    value: thisUser?.name ?? "N/A",
                    editable: isInEditMode,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 28,
                    borderRadius: BorderRadius.circular(5),
                    isTheFirstRow: true,
                    inputType: InputType.normalText,
                    context: context,
                    phoneFocusNode: phoneFocusNode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            infoRow(
              context,
              phoneFocusNode,
              isInEditMode,
              Icons.phone,
              thisUser?.phone,
              InputType.phone,
              authController.phoneEditController,
            ),
            infoRow(
              context,
              FocusNode(),
              isInEditMode,
              Icons.email,
              thisUser?.email,
              InputType.email,
              authController.emailEditController,
            ),
            infoRow(
              context,
              FocusNode(),
              isInEditMode,
              Icons.location_on,
              thisUser?.address,
              InputType.address,
              authController.addressEditController,
            ),
            infoRow(
              context,
              FocusNode(),
              isInEditMode,
              Icons.settings_accessibility_sharp,
              GetUtils.capitalize(thisUser!.role!)!.tr,
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
                          showImageSourceOptions(
                            onCameraTapped: () async {
                              authController.selectedProfileImage = await picker
                                  .pickImage(source: ImageSource.camera);
                              if (authController.selectedProfileImage != null) {
                                await authController.updateProfilePhoto();
                                loadInitialData();
                              }
                            },
                            onGalleryTap: () async {
                              authController.selectedProfileImage = await picker
                                  .pickImage(source: ImageSource.gallery);
                              if (authController.selectedProfileImage != null) {
                                await authController.updateProfilePhoto();
                                loadInitialData();
                              }
                            },
                          );
                          onEditModeChanged(false);
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
                                      authController.nameEditController.clear();
                                      authController.phoneEditController
                                          .clear();
                                      authController.emailEditController
                                          .clear();
                                      authController.addressEditController
                                          .clear();
                                      authController.nameEditController.text =
                                          thisUser?.name ?? '';
                                      authController.phoneEditController.text =
                                          thisUser?.phone ?? '';
                                      authController.emailEditController.text =
                                          thisUser?.email ?? '';
                                      authController
                                          .addressEditController
                                          .text = thisUser?.address ?? '';
                                      authController.update();
                                      onEditModeChanged(false);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                loadInitialData();
                              }
                              onEditModeChanged(!isInEditMode);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
