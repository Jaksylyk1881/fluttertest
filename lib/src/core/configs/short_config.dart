class ShortEntityConfig {
  final String label;
  final String code;
  final dynamic value;
  final bool isDivider;

  const ShortEntityConfig({
    required this.label,
    required this.value,
    required this.code,
    this.isDivider = false,
  });
}

class BlockEntityConfig {
  final String label;
  final String description;

  const BlockEntityConfig({
    required this.label,
    required this.description,
  });
}
