class Treatment {
  final int id;
  final List<TreatmentBranch> branches;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Treatment({
    required this.id,
    required this.branches,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? 0,
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map((branchJson) => TreatmentBranch.fromJson(branchJson))
              .toList() ??
          [],
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branches': branches.map((branch) => branch.toJson()).toList(),
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class TreatmentBranch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  TreatmentBranch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory TreatmentBranch.fromJson(Map<String, dynamic> json) {
    return TreatmentBranch(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      patientsCount: json['patients_count'] ?? 0,
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}

class TreatmentListResponse {
  final bool status;
  final String message;
  final List<Treatment> treatments;

  TreatmentListResponse({
    required this.status,
    required this.message,
    required this.treatments,
  });

  factory TreatmentListResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      treatments:
          (json['treatments'] as List<dynamic>?)
              ?.map((treatmentJson) => Treatment.fromJson(treatmentJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'treatments': treatments.map((treatment) => treatment.toJson()).toList(),
    };
  }
}
