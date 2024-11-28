class Host {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Host({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
