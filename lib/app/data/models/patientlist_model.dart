class PatientListResponse {
  final bool status;
  final String message;
  final List<Patient> patients;

  PatientListResponse({
    required this.status,
    required this.message,
    required this.patients,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      patients:
          json['patient'] != null
              ? (json['patient'] as List)
                  .map((item) => Patient.fromJson(item))
                  .toList()
              : [],
    );
  }
}

class Patient {
  final int id;
  final List<PatientDetail> patientDetailsSet;
  final Branch branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final double? price;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime dateTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.patientDetailsSet,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      patientDetailsSet:
          json['patientdetails_set'] != null
              ? (json['patientdetails_set'] as List)
                  .map((item) => PatientDetail.fromJson(item))
                  .toList()
              : [],
      branch: Branch.fromJson(json['branch'] ?? {}),
      user: json['user'] ?? '',
      payment: json['payment'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      price: json['price']?.toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
      dateTime: DateTime.parse(
        json['date_nd_time'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Get primary treatment name for display
  String get primaryTreatmentName {
    if (patientDetailsSet.isNotEmpty) {
      return patientDetailsSet.first.treatmentName;
    }
    return 'No Treatment';
  }

  // Format date for display
  String get formattedDate {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  // Get total patient count (male + female)
  int get totalPatientCount {
    int total = 0;
    for (var detail in patientDetailsSet) {
      total += detail.getTotalCount();
    }
    return total;
  }
}

class PatientDetail {
  final int id;
  final String male;
  final String female;
  final int patient;
  final int treatment;
  final String treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    required this.treatment,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] ?? 0,
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      patient: json['patient'] ?? 0,
      treatment: json['treatment'] ?? 0,
      treatmentName: json['treatment_name'] ?? '',
    );
  }

  // Get total count of male and female patients
  int getTotalCount() {
    int maleCount = int.tryParse(male) ?? 0;
    int femaleCount = int.tryParse(female) ?? 0;
    return maleCount + femaleCount;
  }
}

class Branch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  Branch({
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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
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
}
