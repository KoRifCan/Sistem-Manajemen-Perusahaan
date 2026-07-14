class EmployeeModel {
  final String id;
  final String nip;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String? nik;
  final String? placeOfBirth;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? bloodType;
  final String? maritalStatus;
  final String? address;
  final String? city;
  final String? departmentId;
  final String? positionId;
  final String? levelId;
  final String? status; // Tetap, Kontrak, Probation, Magang
  final DateTime joinDate;
  final DateTime? contractEndDate;
  final String? shift;
  final String? location;
  final String? superiorId;
  final double? baseSalary;
  final String? taxStatus;
  final String? bankName;
  final String? bankAccount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeeModel({
    required this.id,
    required this.nip,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.nik,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.bloodType,
    this.maritalStatus,
    this.address,
    this.city,
    this.departmentId,
    this.positionId,
    this.levelId,
    this.status,
    required this.joinDate,
    this.contractEndDate,
    this.shift,
    this.location,
    this.superiorId,
    this.baseSalary,
    this.taxStatus,
    this.bankName,
    this.bankAccount,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> map, String id) {
    return EmployeeModel(
      id: id,
      nip: map['nip'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      nik: map['nik'],
      placeOfBirth: map['placeOfBirth'],
      dateOfBirth: (map['dateOfBirth'] as DateTime?),
      gender: map['gender'],
      religion: map['religion'],
      bloodType: map['bloodType'],
      maritalStatus: map['maritalStatus'],
      address: map['address'],
      city: map['city'],
      departmentId: map['departmentId'],
      positionId: map['positionId'],
      levelId: map['levelId'],
      status: map['status'],
      joinDate: (map['joinDate'] as DateTime?) ?? DateTime.now(),
      contractEndDate: map['contractEndDate'] as DateTime?,
      shift: map['shift'],
      location: map['location'],
      superiorId: map['superiorId'],
      baseSalary: (map['baseSalary'] as num?)?.toDouble(),
      taxStatus: map['taxStatus'],
      bankName: map['bankName'],
      bankAccount: map['bankAccount'],
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'nip': nip,
    'name': name,
    'email': email,
    'phone': phone,
    'photoUrl': photoUrl,
    'nik': nik,
    'placeOfBirth': placeOfBirth,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'religion': religion,
    'bloodType': bloodType,
    'maritalStatus': maritalStatus,
    'address': address,
    'city': city,
    'departmentId': departmentId,
    'positionId': positionId,
    'levelId': levelId,
    'status': status,
    'joinDate': joinDate,
    'contractEndDate': contractEndDate,
    'shift': shift,
    'location': location,
    'superiorId': superiorId,
    'baseSalary': baseSalary,
    'taxStatus': taxStatus,
    'bankName': bankName,
    'bankAccount': bankAccount,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
