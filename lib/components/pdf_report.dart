// // ignore_for_file: avoid_print

// import 'dart:math';
// import 'dart:typed_data';
// import 'package:get/get.dart';

// import '../constants/auth_user.dart';
// import '/components/validations.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart';
// import 'package:printing/printing.dart';

// import '../models/expense_report.dart';

// Future<Uint8List> generatePdfReport(
//   List<ExpenseReport> expensesForReport,
//   String fromDate,
//   String toDate,
// ) async {
//   final pdf = pw.Document(
//     version: PdfVersion.pdf_1_5,
//     compress: true,
//     pageMode: PdfPageMode.outlines,
//   );

//   final image = await imageFromAssetBundle('assets/images/logo1.png');

//   const firstPageExpenseReportsPerPage = 14;
//   const restPagesExpenseReportsPerPage = 19;
//   final totalExpenseReports = expensesForReport.length;
//   final totalPages =
//       (totalExpenseReports / restPagesExpenseReportsPerPage).ceil();

//   int index = 1;

//   for (var page = 0; page < totalPages; page++) {
//     pdf.addPage(
//       pw.Page(
//         orientation: pw.PageOrientation.landscape,
//         build: (context) {
//           final start = page * restPagesExpenseReportsPerPage;
//           final end = min(
//             (page == 0)
//                 ? ((page + 1) * firstPageExpenseReportsPerPage)
//                 : (page * restPagesExpenseReportsPerPage +
//                     restPagesExpenseReportsPerPage),
//             totalExpenseReports,
//           );

//           final pageExpenseReports = expensesForReport.sublist(start, end);

//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               page == 0
//                   ? pw.Column(
//                     children: [
//                       pw.Center(child: pw.Image(image, height: 50)),
//                       pw.Center(
//                         child: pw.Text(
//                           Auth().user!.school!.name ?? '',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                             fontSize: 17,
//                           ),
//                         ),
//                       ),
//                       pw.SizedBox(height: 10),
//                       pw.Center(
//                         child: pw.Text(
//                           "${"expenses".tr} ${"from".tr} $fromDate ${"to".tr} $toDate",
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                   : pw.Container(),
//               pw.SizedBox(height: 20),
//               pw.TableHelper.fromTextArray(
//                 context: context,
//                 data: <List<String>>[
//                   [
//                     'SN',
//                     'item'.tr,
//                     'description'.tr,
//                     'category'.tr,
//                     'amount'.tr,
//                     'date'.tr,
//                   ],
//                   for (final expense in pageExpenseReports)
//                     [
//                       (index++).toString(),
//                       expense.itemName ?? '',
//                       expense.description ?? '',
//                       expense.categoryName ?? '',
//                       getMoneyFormat(expense.amount!),
//                       getFormattedDate(expense.expenseDate!),
//                     ],
//                 ],
//                 border: pw.TableBorder.all(),
//                 headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                 cellStyle: const pw.TextStyle(fontSize: 10),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(
//                     "${"report_generated_by".tr}: ${Auth().user!.fullName}",
//                     style: pw.TextStyle(
//                       color: PdfColors.grey600,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.Text(
//                     "${"at".tr}: ${DateTime.now()}",
//                     style: pw.TextStyle(
//                       color: PdfColors.grey600,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   final pdfData = pdf.save();

//   return pdfData;
// }
