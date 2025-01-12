class Device {
  final int id;
  final String name;
  final String deviceIP;
  final int groupId;
  final String groupName;
  final String lastExaminationDate;

  Device({
    required this.id,
    required this.name,
    required this.deviceIP,
    required this.groupId,
    required this.groupName,
    required this.lastExaminationDate,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      deviceIP: json['deviceIP'], // Corrected the key here
      groupId: json['groupId'],
      groupName: json['groupName'],
      lastExaminationDate: json['lastExaminationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'deviceIP': deviceIP,
      'groupId': groupId,
      'groupName': groupName,
      'lastExaminationDate': lastExaminationDate,
    };
  }
}
