class CsisContact {
  final String type;
  final String value;
  final String displayName;
  final String? icon;

  const CsisContact({
    required this.type,
    required this.value,
    required this.displayName,
    this.icon,
  });
}
