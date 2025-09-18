import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registerpage_controller.dart';
import 'package:ayurvedaapp/app/data/models/branchlist_model.dart';
import 'package:ayurvedaapp/app/data/models/treatmentlist_mode.dart';

class RegisterpageView extends GetView<RegisterpageController> {
  const RegisterpageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Name',
              controller: controller.nameController,
              hintText: 'Enter your full name',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Whatsapp Number',
              controller: controller.phoneController,
              hintText: 'Enter your whatsapp number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Address',
              controller: controller.addressController,
              hintText: 'Enter your address',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Location',
              items: ['Kochi', 'Kozhikode', 'Kumarakom', 'Other'],
              onChanged:
                  (value) => controller.selectedLocation.value = value ?? '',
            ),
            const SizedBox(height: 16),
            _buildBranchDropdown(),
            const SizedBox(height: 16),
            _buildTreatmentsSection(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Total Amount',
              controller: controller.totalAmountController,
              hintText: 'Enter total amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Discount Amount',
              controller: controller.discountAmountController,
              hintText: 'Enter discount amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Advance Amount',
              controller: controller.advanceAmountController,
              hintText: 'Enter advance amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Balance Amount',
              controller: controller.balanceAmountController,
              hintText: 'Enter balance amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildPaymentOptions(),
            const SizedBox(height: 16),
            _buildDateTimeSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            hint: Text(
              'Select $label',
              style: TextStyle(color: Colors.grey[500]),
            ),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBranchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Branch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isBranchListLoading.value) {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonFormField<Branch>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              hint: Text(
                'Select the branch',
                style: TextStyle(color: Colors.grey[500]),
              ),
              value: controller.selectedBranch.value,
              items:
                  controller.branches.map((Branch branch) {
                    return DropdownMenuItem<Branch>(
                      value: branch,
                      child: Text(branch.name),
                    );
                  }).toList(),
              onChanged: (Branch? branch) {
                if (branch != null) {
                  controller.selectBranch(branch);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTreatmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isTreatmentListLoading.value) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          // Show selected treatments only
          if (controller.selectedTreatments.isEmpty) {
            return const SizedBox.shrink(); // Show nothing if no treatments selected
          }

          return Column(
            children:
                controller.selectedTreatments.asMap().entries.map((entry) {
                  int index = entry.key;
                  Treatment treatment = entry.value;
                  return _buildTreatmentItem(treatment, index + 1);
                }).toList(),
          );
        }),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => _showTreatmentSelectionDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('+ Add Treatments'),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentItem(Treatment treatment, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ${treatment.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(child: _buildGenderCounter('Male', treatment)),
                    const SizedBox(width: 12),
                    Flexible(child: _buildGenderCounter('Female', treatment)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () => controller.removeTreatment(treatment),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCounter(String gender, Treatment treatment) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              gender,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 4),

        Obx(() {
          int count = controller.getTreatmentGenderCount(treatment, gender);
          return Container(
            width: 32,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Option',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Row(
            children:
                ['Cash', 'Card', 'UPI'].map((option) {
                  bool isSelected =
                      controller.selectedPaymentOption.value == option;
                  return Expanded(
                    child: GestureDetector(
                      onTap:
                          () => controller.selectedPaymentOption.value = option,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green[600] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.green[600]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatment Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Obx(() {
                        final date = controller.selectedDateTime.value;
                        return Text(
                          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                          style: const TextStyle(fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 12),
                      Obx(() {
                        final time = controller.selectedDateTime.value;
                        return Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(() {
      return CustomButton(
        isLoading: controller.isCreatePatientLoading.value,
        text: 'Save',
        onPressed: () => controller.createPatient(),
        buttoncolor: AppColors.primaryColor,
        textcolor: AppColors.scafflodBackgroundColor,
      );
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDateTime.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green[600]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final current = controller.selectedDateTime.value;
      controller.setDateTime(
        DateTime(
          picked.year,
          picked.month,
          picked.day,
          current.hour,
          current.minute,
        ),
      );
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(controller.selectedDateTime.value),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green[600]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final current = controller.selectedDateTime.value;
      controller.setDateTime(
        DateTime(
          current.year,
          current.month,
          current.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  }

  void _showTreatmentSelectionDialog() {
    // Reset dialog state when opening
    controller.resetDialogState();

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Treatment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Treatment>(
                        isExpanded: true,
                        value: controller.dialogSelectedTreatment.value,
                        hint: const Text('Choose preferred treatment'),
                        items:
                            controller.treatments.map((Treatment treatment) {
                              return DropdownMenuItem<Treatment>(
                                value: treatment,
                                child: Text(treatment.name),
                              );
                            }).toList(),
                        onChanged: (Treatment? treatment) {
                          controller.setDialogTreatment(treatment);
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Add Patients',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    _buildPatientCounter('Male'),
                    const SizedBox(width: 16),
                    _buildPatientCounter('Female'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.dialogSelectedTreatment.value != null) {
                        controller.addTreatmentFromDialog();
                        Navigator.of(context).pop();
                      } else {
                        // Show error if no treatment is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a treatment first'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatientCounter(String gender) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gender,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.green[600],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () => controller.decrementDialogGenderCount(gender),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 8),
        Obx(() {
          int count = controller.getDialogGenderCount(gender);
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.green[600],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () => controller.incrementDialogGenderCount(gender),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
