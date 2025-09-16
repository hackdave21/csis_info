class CsisService {
  final String name;
  final String description;
  final String? icon;
  final List<String> features;

  const CsisService({
    required this.name,
    required this.description,
    this.icon,
    this.features = const [],
  });
}