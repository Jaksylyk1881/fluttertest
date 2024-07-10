import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';

class CustomDateInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FocusNode focusNode;
  final AutovalidateMode? autovalidateMode;
  final bool autoFillCurrentDate;

  const CustomDateInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    this.autovalidateMode,
    this.autoFillCurrentDate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (autoFillCurrentDate && controller.text.isEmpty) {
      DateTime now = DateTime.now();
      controller.text = "${now.day}/${now.month}/${now.year}";
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: 10.r,
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: 10.r,
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText: labelText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              controller.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
            }
          },
        ),
      ),
    );
  }
}
