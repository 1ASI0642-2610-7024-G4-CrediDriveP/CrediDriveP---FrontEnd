class OfficerModel {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  const OfficerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory OfficerModel.fromJson(Map<String, dynamic> json) {
    return OfficerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}