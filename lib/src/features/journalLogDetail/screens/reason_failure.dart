import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/field_config.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_dynamic_fileds.dart';

@RoutePage()
class ReasonFailureScreen extends StatefulWidget {
  final String accountId;

  const ReasonFailureScreen({required this.accountId, super.key});

  @override
  State<ReasonFailureScreen> createState() => _ReasonFailureScreenState();
}

class _ReasonFailureScreenState extends State<ReasonFailureScreen>
    with TickerProviderStateMixin {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  late final HomeService _homeService;
  bool _isLoading = false;

  final List<FieldConfig> _fields = [
    FieldConfig(
        labelText: 'Комментарий', key: 'comment', fieldType: FieldType.text),
  ];

  @override
  void initState() {
    debugPrint('Selected account: ${widget.accountId}');
    for (var field in _fields) {
      _controllers[field.key] = TextEditingController();
      _focusNodes[field.key] = FocusNode();
    }
    super.initState();

    _homeService = HomeService(context);
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    _focusNodes.forEach((key, focusNode) {
      focusNode.dispose();
    });
    super.dispose();
  }

  void _saveFormData() {
    // final formData = {
    //   'dateOfDeposition': _controllers['dateOfDeposition']!.text,
    // };

    final filterValues = <String, dynamic>{};

    debugPrint('Form data: $filterValues');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Добавить показание",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF181C20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DynamicFormFields(
                      title: 'Пожалуйста, напишите причину отказа',
                      fields: _fields,
                      controllers: _controllers,
                      focusNodes: _focusNodes,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  debugPrint('Cancel button pressed');
                  // if (_commentController.text.isNotEmpty) {
                  _saveFormData();
                  // }
                },
                text: 'Подтвердить',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
