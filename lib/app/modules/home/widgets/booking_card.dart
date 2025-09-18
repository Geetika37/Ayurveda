import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:ayurvedaapp/app/data/models/patientlist_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

class BookingCard extends StatelessWidget {
  final Patient patient;
  final int index;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.patient,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with index and name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            patient.primaryTreatmentName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),

                // Date and details row
                Row(
                  children: [
                    // Date icon and text
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                        const Gap(4),
                        Text(
                          patient.formattedDate,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    // People icon and count
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.orange.shade400,
                        ),
                        const Gap(4),
                        Text(
                          patient.user,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(12),

                // View booking details button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View Booking details',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
