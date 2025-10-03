// ignore_for_file: library_private_types_in_public_api, must_be_immutable, avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class SelectFormField extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final String initialValue;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final FocusNode searchFocusNode;
  final VoidCallback onFieldSubmitted;
  final String labelText;
  final String errorMsg;
  final bool isRequired;
  final bool enableSearch;
  final bool enabled;
  bool fieldHasError;
  final TextEditingController controller;
  final void Function(String?) onChanged;
  final void Function(String?) onSaved;

  SelectFormField({
    super.key,
    required this.items,
    required this.initialValue,
    required this.focusNode,
    required this.nextFocusNode,
    required this.searchFocusNode,
    required this.labelText,
    required this.onChanged,
    required this.onSaved,
    required this.enableSearch,
    required this.isRequired,
    required this.fieldHasError,
    required this.controller,
    required this.errorMsg,
    required this.onFieldSubmitted,
    required this.enabled,
  });

  @override
  _SelectFormFieldState createState() => _SelectFormFieldState();
}

class _SelectFormFieldState extends State<SelectFormField> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.fieldHasError ? 74 : 60,
      child: DropdownButtonFormField2<String>(
  isExpanded: true,
  focusNode: widget.focusNode,
  decoration: InputDecoration(
    enabled: widget.enabled,
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    fillColor: Colors.white,
    filled: true,
    label: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        widget.labelText,
        style: TextStyle(color: Colors.grey[400]),
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  items: widget.items,
  value: widget.items.any((item) => item.value == widget.controller.text)
      ? widget.controller.text
      : null, // Reset value if it doesn't exist in the items list
  buttonStyleData: const ButtonStyleData(
    padding: EdgeInsets.only(right: 8),
  ),
  dropdownStyleData: DropdownStyleData(
    maxHeight: 250,
    offset:
        widget.fieldHasError ? const Offset(0, 23.5) : const Offset(0, 0),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  ),
  menuItemStyleData: const MenuItemStyleData(
    height: 35,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  ),
  validator: (value) {
    if (widget.isRequired) {
      if (value == null || value.isEmpty || value == 0.toString()) {
        setState(() {
          widget.fieldHasError = true;
        });
        return widget.errorMsg;
      } else {
        setState(() {
          widget.fieldHasError = false;
        });
      }
    }
    return null;
  },
  onChanged: (value) {
    print(value);
    widget.onChanged(value);
    setState(() {});
  },
  onSaved: (value) {
    widget.onSaved(value);
    widget.onFieldSubmitted;
    setState(() {});
  },
  dropdownSearchData: !widget.enableSearch
      ? null
      : DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.normal),
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey[400]!),
                fillColor: Colors.white,
                filled: true,
                labelStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          searchMatchFn: (item, searchValue) {
            String itemText = (item.child as Text).data!;
            return itemText.toLowerCase().contains(
              searchValue.toLowerCase(),
            );
          },
        ),
  onMenuStateChange: (isOpen) {
    if (!isOpen) {
      setState(() {});
      searchController.clear();
    }
  },
),  );
  }
}
