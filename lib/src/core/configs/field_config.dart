class FieldConfig {
  final String labelText;
  final String key;
  final FieldType fieldType;
  final List<String>? selectItems;

  FieldConfig({
    required this.labelText,
    required this.key,
    required this.fieldType,
    this.selectItems,
  });
}

enum FieldType { text, date, select }
