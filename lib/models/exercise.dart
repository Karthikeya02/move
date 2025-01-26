class Exercise {
  final String name;
  final double targetOutput;
  final String unit;

  const Exercise({
    required this.name,
    required this.targetOutput,
    required this.unit,
  });

  @override
  String toString() {
    return '$name (Target: $targetOutput $unit)';
  }
}
