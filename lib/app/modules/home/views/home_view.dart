import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:ayurvedaapp/app/core/utils/storageutil.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_button.dart';
import 'package:ayurvedaapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../controllers/home_controller.dart';
import '../widgets/booking_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scafflodBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Handle notification
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
          ),
          const Gap(8),
          IconButton(
            onPressed: () async {
              await StorageUtil.clearAll();
              Get.offAllNamed(Routes.LOGIN);
            },
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            const Gap(16),

            // Sort Section
            _buildSortSection(),
            const Gap(16),

            // Patient List
            Expanded(
              child: Obx(() {
                if (controller.isPatientListLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                if (controller.filteredPatientList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const Gap(16),
                        Text(
                          'No patients found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Try adjusting your search criteria',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    controller.onRefresh();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.filteredPatientList.length,
                    itemBuilder: (context, index) {
                      final patient = controller.filteredPatientList[index];
                      return BookingCard(
                        patient: patient,
                        index: index,
                        onTap: () {
                          // Navigate to patient details
                          // Get.toNamed(Routes.PATIENT_DETAILS, arguments: patient);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text: 'Register',
          onPressed: () {
            Get.toNamed(Routes.REGISTERPAGE);
          },
          buttoncolor: AppColors.primaryColor,
          textcolor: AppColors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Search for treatments',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () => controller.onSearchChanged(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Search',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Row(
      children: [
        Text(
          'Sort by:',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedSortOption.value,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isExpanded: true,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                  items:
                      controller.sortOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.onSortChanged(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
