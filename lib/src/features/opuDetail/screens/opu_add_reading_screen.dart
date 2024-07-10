import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/configs/field_config.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/services/message_service.dart';
import 'package:fluttertest/src/core/services/shared_service.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_dynamic_fileds.dart';
import 'package:fluttertest/src/core/widgets/custom_photo_block.dart';

@RoutePage()
class OpuAddReadingScreen extends StatefulWidget {
  final String accountId;

  const OpuAddReadingScreen({required this.accountId, super.key});

  @override
  State<OpuAddReadingScreen> createState() => _OpuAddReadingScreenState();
}

class _OpuAddReadingScreenState extends State<OpuAddReadingScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  late final SharedService _sharedService = SharedService();
  late final HomeService _homeService;
  final MessageService _messageService = MessageService();
  File? _imageFile;
  bool _isLoading = false;

  final List<FieldConfig> _fields = [
    FieldConfig(
        labelText: 'Дата снятия показаний',
        key: 'dateOfDeposition',
        fieldType: FieldType.date),
    FieldConfig(labelText: 'Круг', key: 'circle', fieldType: FieldType.text),
    FieldConfig(
        labelText: 'Значение', key: 'meaning', fieldType: FieldType.text),
  ];

  @override
  void initState() {
    debugPrint('Selected account: ${widget.accountId}');
    super.initState();
    for (var field in _fields) {
      _controllers[field.key] = TextEditingController();
      _focusNodes[field.key] = FocusNode();
    }
    _homeService = HomeService(context);
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    _focusNodes.forEach((key, node) {
      node.dispose();
    });
    super.dispose();
  }

  void _saveFormData() {
    if (_formKey.currentState!.validate()) {
      final formData = <String, dynamic>{};

      _controllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          formData[key] = controller.text;
        }
      });
      debugPrint('Form data: $formData');
    } else {
      debugPrint('Form is invalid');
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DynamicFormFields(
                        title: 'Показания прибора учета',
                        fields: _fields,
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                      ),
                      const SizedBox(height: 16.0),
                      PhotoBlock(
                        title: 'Фото прибора учета',
                        onPhotoChanged: (event) {
                          debugPrint('Photo changed $event');
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
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
                isPrimary: false,
                onPressed: () {
                  debugPrint('Отмена');
                  Navigator.of(context).pop();
                },
                text: 'Отмена',
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  debugPrint('Сохранить');
                  _saveFormData();
                  if (_formKey.currentState!.validate() && _imageFile != null) {
                    _messageService.showMessage(
                      context: context,
                      message: 'Успешное выполнение!',
                    );
                  }
                },
                text: 'Сохранить',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
