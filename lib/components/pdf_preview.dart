// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/components/custom_loader.dart';
// import '/theme/app_colors.dart';
// import 'package:printing/printing.dart';
// import '../models/expense_report.dart';
// import '../views/includes/more_menu.dart';
// import 'pdf_report.dart';

// class PDFPreviewPage extends StatelessWidget {
//   final List<ExpenseReport> expensesForReport;
//   final String fromDate;
//   final String toDate;
//   const PDFPreviewPage({
//     super.key,
//     required this.fromDate,
//     required this.toDate,
//     required this.expensesForReport,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'expenses_report'.tr,
//           style: const TextStyle(color: Colors.white),
//         ),
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//                backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white,

//         actions: [
//           MoreMenu(
//             onProfilePressed: () {},
//             onNotificationsPressed: () {},
//             onLogoutPressed: () {},
//             onSettingsPressed: () {},
//           ),
//         ],
//       ),
//       body: PdfPreview(
//         canChangeOrientation: false,
//         canChangePageFormat: false,
//         loadingWidget: customLoader(AppColors.primaryColor),
//         pdfFileName:
//             "NASI-${"expenses".tr}-${"report".tr}-$fromDate-${"to".tr}-$toDate",
//         canDebug: false,
//         actionBarTheme: PdfActionBarTheme(
//                  backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white,

//         ),
//         build:
//             (format) => generatePdfReport(expensesForReport, fromDate, toDate),
//       ),
//     );
//   }
// }
