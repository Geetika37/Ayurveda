import 'dart:developer';

import 'package:ayurvedaapp/app/core/constants/app_urls.dart';
import 'package:ayurvedaapp/app/core/utils/toasts.dart';
import 'package:ayurvedaapp/app/data/models/branchlist_model.dart';
import 'package:ayurvedaapp/app/data/models/treatmentlist_mode.dart';
import 'package:ayurvedaapp/app/data/models/patient_bill_model.dart';
import 'package:ayurvedaapp/app/data/services/api_service.dart';
import 'package:ayurvedaapp/app/core/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterpageController extends GetxController {
  final ApiService apiService = ApiService();

  final RxBool isBranchListLoading = true.obs;
  final RxBool isTreatmentListLoading = true.obs;
  final RxBool isCreatePatientLoading = false.obs;

  // Data storage for branches and treatments
  final Rx<BranchListResponse?> branchListResponse = Rx<BranchListResponse?>(
    null,
  );
  final Rx<TreatmentListResponse?> treatmentListResponse =
      Rx<TreatmentListResponse?>(null);

  // Getters for easy access to the data
  List<Branch> get branches => branchListResponse.value?.branches ?? [];
  List<Treatment> get treatments =>
      treatmentListResponse.value?.treatments ?? [];

  // Form controllers for patient registration
  final TextEditingController nameController = TextEditingController();
  final TextEditingController executiveController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();

  // Selected data
  final Rx<Branch?> selectedBranch = Rx<Branch?>(null);
  final RxList<Treatment> selectedTreatments = <Treatment>[].obs;
  final RxList<Treatment> selectedMaleTreatments = <Treatment>[].obs;
  final RxList<Treatment> selectedFemaleTreatments = <Treatment>[].obs;
  final Rx<DateTime> selectedDateTime = DateTime.now().obs;

  // Additional UI state variables
  final RxString selectedLocation = ''.obs;
  final RxString selectedPaymentOption = 'Cash'.obs;

  // Treatment gender counts for UI
  final RxMap<String, int> treatmentGenderCounts = <String, int>{}.obs;
  final RxInt dialogMaleCount = 0.obs;
  final RxInt dialogFemaleCount = 0.obs;

  // Dialog state variables
  final Rx<Treatment?> dialogSelectedTreatment = Rx<Treatment?>(null);

  @override
  void onInit() async {
    super.onInit();
    // Fetch data when controller is initialized
    await fetchBranchList();
    await fetchTreatmentList();
  }

  Future<void> fetchBranchList() async {
    try {
      isBranchListLoading.value = true;

      final response = await apiService.authGetRequest(
        url: AppUrls.getBranchList,
      );

      log('Branch Response: $response');

      if (response != null && response['status'] == true) {
        // Parse the response using the model
        branchListResponse.value = BranchListResponse.fromJson(response);
        log('Branches loaded: ${branches.length} branches');
      } else {
        Toasts.showError('Failed to load Branch list. Please try again.');
      }
    } catch (e) {
      log('Branch List Error: $e');
      Toasts.showError('Branch List failed. Please try again.');
    } finally {
      isBranchListLoading.value = false;
    }
  }

  Future<void> fetchTreatmentList() async {
    try {
      isTreatmentListLoading.value = true;

      final response = await apiService.authGetRequest(
        url: AppUrls.getTreatmentList,
      );

      log('Treatment Response: $response');

      if (response != null && response['status'] == true) {
        // Parse the response using the model
        treatmentListResponse.value = TreatmentListResponse.fromJson(response);
        log('Treatments loaded: ${treatments.length} treatments');
      } else {
        Toasts.showError('Failed to load Treatment list. Please try again.');
      }
    } catch (e) {
      log('Treatment List Error: $e');
      Toasts.showError('Treatment List failed. Please try again.');
    } finally {
      isTreatmentListLoading.value = false;
    }
  }

  Future<void> createPatient() async {
    try {
      isCreatePatientLoading.value = true;

      // Validation
      if (nameController.text.isEmpty) {
        Toasts.showError('Please enter patient name');
        return;
      }
      if (phoneController.text.isEmpty) {
        Toasts.showError('Please enter phone number');
        return;
      }
      if (selectedBranch.value == null) {
        Toasts.showError('Please select a branch');
        return;
      }
      if (selectedTreatments.isEmpty) {
        Toasts.showError('Please select at least one treatment');
        return;
      }

      // Format date and time from selected DateTime
      final DateTime dateTime = selectedDateTime.value;
      final String formattedDateTime =
          '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}-${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';

      // Prepare treatment IDs based on gender counts
      List<int> allTreatmentIds = [];
      List<int> maleIds = [];
      List<int> femaleIds = [];

      for (Treatment treatment in selectedTreatments) {
        int maleCount = getTreatmentGenderCount(treatment, 'Male');
        int femaleCount = getTreatmentGenderCount(treatment, 'Female');

        // If no gender counts are set, default to 1 for the treatment
        if (maleCount == 0 && femaleCount == 0) {
          allTreatmentIds.add(treatment.id);
        } else {
          // Add to all treatments list
          for (int i = 0; i < (maleCount + femaleCount); i++) {
            allTreatmentIds.add(treatment.id);
          }

          // Add to gender-specific lists
          for (int i = 0; i < maleCount; i++) {
            maleIds.add(treatment.id);
          }
          for (int i = 0; i < femaleCount; i++) {
            femaleIds.add(treatment.id);
          }
        }
      }

      final String treatmentIds =
          allTreatmentIds.isNotEmpty ? allTreatmentIds.join(',') : '';
      final String maleIdsString = maleIds.isNotEmpty ? maleIds.join(',') : '';
      final String femaleIdsString =
          femaleIds.isNotEmpty ? femaleIds.join(',') : '';

      log('Selected treatments count: ${selectedTreatments.length}');
      log('All treatment IDs: $allTreatmentIds');
      log('Male IDs: $maleIds');
      log('Female IDs: $femaleIds');
      log('Treatment IDs string: $treatmentIds');
      log('Male IDs string: $maleIdsString');
      log('Female IDs string: $femaleIdsString');

      final Map<String, dynamic> requestData = {
        'name': nameController.text.trim(),
        'excecutive':
            executiveController.text.trim().isEmpty
                ? 'Default Executive'
                : executiveController.text.trim(),
        'payment': selectedPaymentOption.value,
        'phone': phoneController.text.trim(),
        'address':
            addressController.text.trim().isEmpty
                ? 'N/A'
                : addressController.text.trim(),
        'total_amount': int.tryParse(totalAmountController.text.trim()) ?? 0,
        'discount_amount':
            int.tryParse(discountAmountController.text.trim()) ?? 0,
        'advance_amount':
            int.tryParse(advanceAmountController.text.trim()) ?? 0,
        'balance_amount':
            int.tryParse(balanceAmountController.text.trim()) ?? 0,
        'date_nd_time': formattedDateTime,
        'id': "".toString(), // Empty string for new patient
        'male': maleIdsString, // Male treatment IDs
        'female': femaleIdsString, // Female treatment IDs
        'branch': selectedBranch.value!.id,
        'treatments': treatmentIds, // All treatment IDs
      };

      log('Create Patient Request Data: $requestData');

      final response = await apiService.authPostRequest(
        url: AppUrls.registerPatient,
        data: requestData,
      );

      log('Create Patient Response: $response');

      if (response != null && response['status'] == true) {
        Toasts.showSuccess('Patient registered successfully!');

        // Generate PDF bill after successful registration
        await _generatePatientBill();

        _clearForm();
      } else {
        final errorMessage =
            response?['message'] ??
            'Failed to register patient. Please try again.';
        Toasts.showError(errorMessage);
      }
    } catch (e) {
      log('Create Patient Error: $e');
      Toasts.showError('Patient registration failed. Please try again.');
    } finally {
      isCreatePatientLoading.value = false;
    }
  }

  // Helper method to generate patient bill PDF
  Future<void> _generatePatientBill() async {
    try {
      // Prepare treatment items for the bill
      List<BillTreatmentItem> billTreatments = [];

      for (Treatment treatment in selectedTreatments) {
        int maleCount = getTreatmentGenderCount(treatment, 'Male');
        int femaleCount = getTreatmentGenderCount(treatment, 'Female');

        // If no gender counts are set, default to 1 for the treatment
        if (maleCount == 0 && femaleCount == 0) {
          maleCount = 1;
        }

        double treatmentPrice = double.tryParse(treatment.price) ?? 0.0;
        double totalPrice = treatmentPrice * (maleCount + femaleCount);

        billTreatments.add(
          BillTreatmentItem(
            treatmentName: treatment.name,
            price: treatmentPrice,
            maleCount: maleCount,
            femaleCount: femaleCount,
            total: totalPrice,
          ),
        );
      }

      // Create bill data
      PatientBillData billData = PatientBillData(
        patientName: nameController.text.trim(),
        address:
            addressController.text.trim().isEmpty
                ? 'N/A'
                : addressController.text.trim(),
        whatsappNumber: phoneController.text.trim(),
        bookedOn: DateTime.now(),
        treatmentDate: selectedDateTime.value,
        treatmentTime: _formatTime(selectedDateTime.value),
        treatments: billTreatments,
        totalAmount: double.tryParse(totalAmountController.text.trim()) ?? 0.0,
        discount: double.tryParse(discountAmountController.text.trim()) ?? 0.0,
        advance: double.tryParse(advanceAmountController.text.trim()) ?? 0.0,
        balance: double.tryParse(balanceAmountController.text.trim()) ?? 0.0,
      );

      // Generate PDF
      await PDFService.generatePatientBill(billData);
    } catch (e) {
      log('PDF Generation Error: $e');
      Toasts.showError('Failed to generate patient bill PDF');
    }
  }

  // Helper method to format time
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  // Helper method to clear form after successful registration
  void _clearForm() {
    nameController.clear();
    executiveController.clear();
    paymentController.clear();
    phoneController.clear();
    addressController.clear();
    totalAmountController.clear();
    discountAmountController.clear();
    advanceAmountController.clear();
    balanceAmountController.clear();
    selectedBranch.value = null;
    selectedTreatments.clear();
    selectedMaleTreatments.clear();
    selectedFemaleTreatments.clear();
    selectedDateTime.value = DateTime.now();
    selectedLocation.value = '';
    selectedPaymentOption.value = 'Cash';
    treatmentGenderCounts.clear();
    dialogMaleCount.value = 0;
    dialogFemaleCount.value = 0;
  }

  // Helper methods for treatment and branch selection
  void selectBranch(Branch branch) {
    selectedBranch.value = branch;
  }

  // Treatment management methods
  void addTreatment(Treatment treatment) {
    if (!selectedTreatments.contains(treatment)) {
      selectedTreatments.add(treatment);
      // Initialize gender counts for this treatment
      treatmentGenderCounts['${treatment.id}_male'] = dialogMaleCount.value;
      treatmentGenderCounts['${treatment.id}_female'] = dialogFemaleCount.value;

      // Reset dialog counters
      dialogMaleCount.value = 0;
      dialogFemaleCount.value = 0;
    }
  }

  void removeTreatment(Treatment treatment) {
    selectedTreatments.remove(treatment);
    // Remove gender counts for this treatment
    treatmentGenderCounts.remove('${treatment.id}_male');
    treatmentGenderCounts.remove('${treatment.id}_female');
  }

  // Gender count management for treatments
  int getTreatmentGenderCount(Treatment treatment, String gender) {
    final key = '${treatment.id}_${gender.toLowerCase()}';
    return treatmentGenderCounts[key] ?? 0;
  }

  void incrementGenderCount(Treatment treatment, String gender) {
    final key = '${treatment.id}_${gender.toLowerCase()}';
    int currentCount = treatmentGenderCounts[key] ?? 0;
    treatmentGenderCounts[key] = currentCount + 1;
  }

  void decrementGenderCount(Treatment treatment, String gender) {
    final key = '${treatment.id}_${gender.toLowerCase()}';
    int currentCount = treatmentGenderCounts[key] ?? 0;
    if (currentCount > 0) {
      treatmentGenderCounts[key] = currentCount - 1;
    }
  }

  // Dialog gender count management
  int getDialogGenderCount(String gender) {
    return gender.toLowerCase() == 'male'
        ? dialogMaleCount.value
        : dialogFemaleCount.value;
  }

  void incrementDialogGenderCount(String gender) {
    if (gender.toLowerCase() == 'male') {
      dialogMaleCount.value++;
    } else {
      dialogFemaleCount.value++;
    }
  }

  void decrementDialogGenderCount(String gender) {
    if (gender.toLowerCase() == 'male') {
      if (dialogMaleCount.value > 0) {
        dialogMaleCount.value--;
      }
    } else {
      if (dialogFemaleCount.value > 0) {
        dialogFemaleCount.value--;
      }
    }
  }

  void toggleTreatmentSelection(Treatment treatment) {
    if (selectedTreatments.contains(treatment)) {
      selectedTreatments.remove(treatment);
    } else {
      selectedTreatments.add(treatment);
    }
  }

  void toggleMaleTreatmentSelection(Treatment treatment) {
    if (selectedMaleTreatments.contains(treatment)) {
      selectedMaleTreatments.remove(treatment);
    } else {
      selectedMaleTreatments.add(treatment);
    }
  }

  void toggleFemaleTreatmentSelection(Treatment treatment) {
    if (selectedFemaleTreatments.contains(treatment)) {
      selectedFemaleTreatments.remove(treatment);
    } else {
      selectedFemaleTreatments.add(treatment);
    }
  }

  void setDateTime(DateTime dateTime) {
    selectedDateTime.value = dateTime;
  }

  // Dialog management methods
  void resetDialogState() {
    dialogSelectedTreatment.value = null;
    dialogMaleCount.value = 0;
    dialogFemaleCount.value = 0;
  }

  void setDialogTreatment(Treatment? treatment) {
    dialogSelectedTreatment.value = treatment;
  }

  void addTreatmentFromDialog() {
    if (dialogSelectedTreatment.value != null) {
      final treatment = dialogSelectedTreatment.value!;

      if (!selectedTreatments.contains(treatment)) {
        selectedTreatments.add(treatment);
        // Initialize gender counts for this treatment
        treatmentGenderCounts['${treatment.id}_male'] = dialogMaleCount.value;
        treatmentGenderCounts['${treatment.id}_female'] =
            dialogFemaleCount.value;
      }

      // Reset dialog state
      resetDialogState();
    }
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is disposed
    nameController.dispose();
    executiveController.dispose();
    paymentController.dispose();
    phoneController.dispose();
    addressController.dispose();
    totalAmountController.dispose();
    discountAmountController.dispose();
    advanceAmountController.dispose();
    balanceAmountController.dispose();
    super.onClose();
  }
}
