import 'package:flutter/material.dart';

class TabConfig {
  final String label;
  final Widget Function() builder;

  const TabConfig({
    required this.label,
    required this.builder,
  });
}
