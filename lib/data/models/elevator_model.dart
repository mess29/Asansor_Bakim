class ElevatorModel {
  final String id;
  final String name;           // Asansörün adı veya kodu (zorunlu)
  final String? siteName;      // Bina/Site adı
  final String? block;         // Blok/detay (ops.)
  final String? location;      // Adres (sokak, mahalle vs.)
  final String? district;      // Bölge/ilçe
  final String? municipalitySerialNo; // Belediye seri no
  final String? firmSerialNo;        // Firma seri no
  final String? type;          // İnsan/Yük (enum olabilir, şimdilik String)
  final String? driveType;     // Elektrik/Hidrolik
  final int? stopCount;        // Kaç durak
  final double? capacityKg;    // kg
  final int? capacityPerson;   // kişi
  final double? monthlyFee;    // Aylık ücret (opsiyonel)
  final String? authorizedName;    // Yetkili kişi adı
  final String? authorizedPhone;   // Yetkili telefon
  final String? installationYear;  // Sadece yıl (String/int)
  final String? lastInspectionDate; // Son denetim (ops.)
  final String? warrantyEndDate;    // Garanti bitişi (ops.)

  ElevatorModel({
    required this.id,
    required this.name,
    this.siteName,
    this.block,
    this.location,
    this.district,
    this.municipalitySerialNo,
    this.firmSerialNo,
    this.type,
    this.driveType,
    this.stopCount,
    this.capacityKg,
    this.capacityPerson,
    this.monthlyFee,
    this.authorizedName,
    this.authorizedPhone,
    this.installationYear,
    this.lastInspectionDate,
    this.warrantyEndDate,
  });

  // Map ve fromMap fonksiyonlarını eksiksiz şekilde güncelle!
  factory ElevatorModel.fromMap(Map<String, dynamic> map) {
    return ElevatorModel(
      id: map['id'],
      name: map['name'],
      siteName: map['siteName'],
      block: map['block'],
      location: map['location'],
      district: map['district'],
      municipalitySerialNo: map['municipalitySerialNo'],
      firmSerialNo: map['firmSerialNo'],
      type: map['type'],
      driveType: map['driveType'],
      stopCount: map['stopCount'] is int ? map['stopCount'] : int.tryParse(map['stopCount'] ?? ''),
      capacityKg: map['capacityKg'] is double ? map['capacityKg'] : double.tryParse(map['capacityKg']?.toString() ?? ''),
      capacityPerson: map['capacityPerson'] is int ? map['capacityPerson'] : int.tryParse(map['capacityPerson'] ?? ''),
      monthlyFee: map['monthlyFee'] is double ? map['monthlyFee'] : double.tryParse(map['monthlyFee']?.toString() ?? ''),
      authorizedName: map['authorizedName'],
      authorizedPhone: map['authorizedPhone'],
      installationYear: map['installationYear'],
      lastInspectionDate: map['lastInspectionDate'],
      warrantyEndDate: map['warrantyEndDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'siteName': siteName,
      'block': block,
      'location': location,
      'district': district,
      'municipalitySerialNo': municipalitySerialNo,
      'firmSerialNo': firmSerialNo,
      'type': type,
      'driveType': driveType,
      'stopCount': stopCount,
      'capacityKg': capacityKg,
      'capacityPerson': capacityPerson,
      'monthlyFee': monthlyFee,
      'authorizedName': authorizedName,
      'authorizedPhone': authorizedPhone,
      'installationYear': installationYear,
      'lastInspectionDate': lastInspectionDate,
      'warrantyEndDate': warrantyEndDate,
    };
  }
}
