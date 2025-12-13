import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/constants/auth_user.dart';
import '/views/auth/signin_page.dart';
import '../../models/user.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../controllers/course_controller.dart';
import '../../theme/app_colors.dart';

// --- Placeholder/Mock Functions (You must implement these) ---
// Note: Replace these with your actual navigation and logout logic.
void navigateToChangeInfoScreen(BuildContext context) {}
void navigateToChangePasswordScreen(BuildContext context) {}
void navigateToPaymentHistoryScreen(BuildContext context) {}
void handleLogout(BuildContext context) {
  final storage = GetStorage();
  storage.erase();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const SigninPage()),
  );
}

Widget buildMyCourseItem(BuildContext context, dynamic course) => Container();
// --- End Placeholder/Mock Functions ---

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final courseController = Get.put(CourseController());
  User? thisUser;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Assuming Auth().user is correctly set and not null
    thisUser = Auth().user;
    courseController.myCoursesFuture = courseController.getMyCourses();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    // Await the fetch for course list before completing refresh indicator
    await courseController.myCoursesFuture;
    if (mounted) {
      setState(() {});
    }
  }

  // --- UI Builder Methods ---

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // User Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white10,
          child: ClipOval(
            child:
                thisUser?.photo != null && thisUser!.photo!.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: thisUser!.photo!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => customLoader(),
                      errorWidget:
                          (context, url, error) => const Icon(
                            Icons.person,
                            size: 90,
                            color: Colors.white70,
                          ),
                    )
                    : const Icon(Icons.person, size: 90, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 15),
        // User Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              thisUser?.name ?? "N/A",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Positioned(
            //   top: 0,
            //   // left: 0,
            //   right: 0,
            //   child: IconButton(
            //     iconSize: 20,
            //     icon: Icon(FontAwesomeIcons.edit),
            //     onPressed: () {},
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 4),
        // User Email
        // User Email
        Text(
          thisUser?.phone ?? "",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          thisUser?.email ?? "",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        // User Email
        Text(
          thisUser?.address ?? "",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        // User Email
        Text(
          "Role: ${GetUtils.capitalize(thisUser!.role!)}",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAccountActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;

    return GetBuilder<CourseController>(
      builder: (courseController) {
        return RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.secondaryColor,
          backgroundColor: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildProfileHeader(),
                                Divider(color: Colors.white.withOpacity(0.2)),
                                const SizedBox(height: 10),

                                // --- B. Settings/Actions Section ---
                                const Text(
                                  "Account Settings",
                                  style: TextStyle(
                                    color: Color(0xFFE6C068),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                _buildAccountActionTile(
                                  title: 'Change Password',
                                  icon: Icons.lock_outline,
                                  onTap:
                                      () => navigateToChangePasswordScreen(
                                        context,
                                      ),
                                ),

                                // 3. Payment History
                                _buildAccountActionTile(
                                  title: 'Payment History',
                                  icon: Icons.history,
                                  onTap:
                                      () => navigateToPaymentHistoryScreen(
                                        context,
                                      ),
                                ),

                                Divider(color: Colors.white.withOpacity(0.2)),
                                const SizedBox(height: 20),

                                const SizedBox(height: 30),

                                // --- D. Logout Section ---
                                Center(
                                  child: TextButton(
                                    onPressed: () => handleLogout(context),
                                    child: const Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  // App Brand (Fixed Header)
                  Positioned(
                    top: topPadding,
                    left: 0,
                    right: 0,
                    child: appBrand(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
