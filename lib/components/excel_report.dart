// // ignore_for_file: depend_on_referenced_packages

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '/components/validations.dart';
// import '/constants/auth_user.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

// import '../models/expense_report.dart';
// import 'toasts.dart';

// Future<Uint8List> generateExcelReport(
//   String action,
//   List<ExpenseReport> expensesForReport,
//   String fromDate,
//   String toDate,
// ) async {
  
//   final excel = Excel.createExcel();

//   final sheet = excel['Sheet1'];
//   sheet.appendRow([TextCellValue('')]);
//   sheet.appendRow([TextCellValue(Auth().user!.school!.name!)]);
//   sheet.appendRow([TextCellValue('')]);
//   sheet.appendRow([
//     TextCellValue('${"report_generated_by".tr} ${Auth().user!.fullName}'),
//   ]);
//   sheet.appendRow([TextCellValue('')]);
//   sheet.appendRow([
//     TextCellValue('${"expenses".tr} ${"from".tr} $fromDate ${"to".tr} $toDate'),
//   ]);
//   sheet.appendRow([TextCellValue('')]);

//   sheet.appendRow([
//     TextCellValue('SN'),
//     TextCellValue('item'.tr),
//     TextCellValue('description'.tr),
//     TextCellValue('category'.tr),
//     TextCellValue('amount'.tr),
//     TextCellValue('date'.tr),
//   ]);

//   int serialNumber = 1;

//   for (final expense in expensesForReport) {
//     sheet.appendRow([
//       TextCellValue(serialNumber.toString()),
//       TextCellValue(expense.itemName ?? ''),
//       TextCellValue(expense.description ?? ''),
//       TextCellValue(expense.categoryName ?? ''),
//       TextCellValue(getMoneyFormat(expense.amount!)),
//       TextCellValue(getFormattedDate(expense.expenseDate!)),
//     ]);
//     serialNumber++;
//   }

//   final excelData = excel.encode();

//   if (action == "view") {
//     final directory = await getTemporaryDirectory();
//     final filePath =
//         '${directory.path}/NASI-${"expenses".tr}-${"report".tr}-$fromDate-${"to".tr}-$toDate.xlsx';

//     final file = File(filePath);
//     await file.writeAsBytes(excelData!);

//     OpenFile.open(filePath);
//     return Uint8List.fromList(excelData);
//   } else {
//     return Uint8List.fromList(excelData!);
//   }
// }
