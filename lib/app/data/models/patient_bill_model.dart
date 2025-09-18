class PatientBillData {
  final String patientName;
  final String address;
  final String whatsappNumber;
  final DateTime bookedOn;
  final DateTime treatmentDate;
  final String treatmentTime;
  final List<BillTreatmentItem> treatments;
  final double totalAmount;
  final double discount;
  final double advance;
  final double balance;

  PatientBillData({
    required this.patientName,
    required this.address,
    required this.whatsappNumber,
    required this.bookedOn,
    required this.treatmentDate,
    required this.treatmentTime,
    required this.treatments,
    required this.totalAmount,
    required this.discount,
    required this.advance,
    required this.balance,
  });
}

class BillTreatmentItem {
  final String treatmentName;
  final double price;
  final int maleCount;
  final int femaleCount;
  final double total;

  BillTreatmentItem({
    required this.treatmentName,
    required this.price,
    required this.maleCount,
    required this.femaleCount,
    required this.total,
  });
}
