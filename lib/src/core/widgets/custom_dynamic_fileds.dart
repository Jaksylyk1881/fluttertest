import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/configs/field_config.dart';
import 'package:fluttertest/src/core/widgets/custom_datepicker.dart';
import 'package:fluttertest/src/core/widgets/custom_input.dart';
import 'package:fluttertest/src/core/widgets/custom_select.dart';

class DynamicFormFields extends StatefulWidget {
  final String title;
  final List<FieldConfig> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;

  const DynamicFormFields({
    required this.title,
    required this.fields,
    required this.controllers,
    required this.focusNodes,
    super.key,
  });

  @override
  _DynamicFormFieldsState createState() => _DynamicFormFieldsState();
}

Widget _buildCustomSelect(String labelText, String value, List<String> items,
    ValueChanged<String?> onChanged) {
  return CustomSelect(
    key: UniqueKey(),
    labelText: labelText,
    value: value.isEmpty ? null : value,
    items: items,
    onChanged: onChanged,
  );
}

class _DynamicFormFieldsState extends State<DynamicFormFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xffF1F4F9),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6.0,
            offset: Offset(0, 2),
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 2.0,
            offset: Offset(0, 1),
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.fields.map((field) {
              switch (field.fieldType) {
                case FieldType.text:
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomInput(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      labelText: field.labelText,
                      controller: widget.controllers[field.key]!,
                      focusNode: widget.focusNodes[field.key]!,
                    ),
                  );
                case FieldType.date:
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomDateInput(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      labelText: field.labelText,
                      controller: widget.controllers[field.key]!,
                      focusNode: widget.focusNodes[field.key]!,
                      autoFillCurrentDate: true,
                    ),
                  );
                case FieldType.select:
                  // return Container(
                  //   child: Text(field.selectItems.toString()),
                  // );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildCustomSelect(
                        field.labelText,
                        widget.controllers[field.key]!.text,
                        field.selectItems ?? [], (String? value) {
                      setState(() {
                        // dropdownValue2 = value ?? '';
                        debugPrint('newValue: $value');

                        widget.controllers[field.key]!.text = value ?? '';
                      });
                    }),
                    // field.selectItems != null
                    //     ? CustomSelect(
                    //         key: UniqueKey(),
                    //         value: widget.controllers[field.key]!.text.isEmpty
                    //             ? null
                    //             : widget.controllers[field.key]!.text,
                    //         labelText: field.labelText,
                    //         items: field.selectItems ?? [],
                    //         onChanged: (newValue) {
                    //           setState(() {
                    //             debugPrint('newValue: $newValue');

                    //             // widget.controllers[field.key]!.text =
                    //             //     newValue ?? '';
                    //           });
                    //         },
                    //       )
                    //     : Container(),
                  );
                default:
                  return Container();
              }
            }).toList(),
          ),
        ],
      ),
    );
  }
}
