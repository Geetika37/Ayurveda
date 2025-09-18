import 'dart:developer';

import 'package:ayurvedaapp/app/core/constants/app_urls.dart';
import 'package:ayurvedaapp/app/core/utils/toasts.dart';
import 'package:ayurvedaapp/app/data/models/patientlist_model.dart';
import 'package:ayurvedaapp/app/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  final RxBool isPatientListLoading = true.obs;
  final RxList<Patient> patientList = <Patient>[].obs;
  final RxList<Patient> filteredPatientList = <Patient>[].obs;
  final RxString selectedSortOption = 'Date'.obs;

  final TextEditingController searchController = TextEditingController();

  final List<String> sortOptions = ['Date', 'Name', 'Treatment'];

  @override
  void onInit() {
    super.onInit();
    fetchPatientList();

    // Listen to search text changes
    searchController.addListener(() {
      filterPatients();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchPatientList() async {
    try {
      isPatientListLoading.value = true;

      final response = await apiService.authGetRequest(
        url: AppUrls.getPatientList,
      );

      log('Patient Response: $response');

      if (response != null && response['status'] == true) {
        final patientListResponse = PatientListResponse.fromJson(response);
        patientList.value = patientListResponse.patients;
        filteredPatientList.value = patientListResponse.patients;
        sortPatients(selectedSortOption.value);
        log('Successfully loaded ${patientList.length} patients');
      } else {
        Toasts.showError('Failed to load patient list. Please try again.');
      }
    } catch (e) {
      log('Patient List Error: $e');
      Toasts.showError('Patient List failed. Please try again.');
    } finally {
      isPatientListLoading.value = false;
    }
  }

  void filterPatients() {
    final searchText = searchController.text.toLowerCase();

    if (searchText.isEmpty) {
      filteredPatientList.value = patientList;
    } else {
      filteredPatientList.value =
          patientList.where((patient) {
            return patient.name.toLowerCase().contains(searchText) ||
                patient.primaryTreatmentName.toLowerCase().contains(
                  searchText,
                ) ||
                patient.phone.contains(searchText);
          }).toList();
    }

    sortPatients(selectedSortOption.value);
  }

  void sortPatients(String sortBy) {
    selectedSortOption.value = sortBy;

    switch (sortBy) {
      case 'Date':
        filteredPatientList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case 'Name':
        filteredPatientList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Treatment':
        filteredPatientList.sort(
          (a, b) => a.primaryTreatmentName.compareTo(b.primaryTreatmentName),
        );
        break;
    }
  }

  void onSearchChanged() {
    filterPatients();
  }

  void onSortChanged(String sortBy) {
    sortPatients(sortBy);
  }

  void onRefresh() {
    fetchPatientList();
  }
}
