import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ayurvedaapp/app/data/models/patient_bill_model.dart';
import 'package:ayurvedaapp/app/core/utils/toasts.dart';
import 'dart:developer';

class PDFService {
  static Future<void> generatePatientBill(PatientBillData billData) async {
    try {
      final pdf = pw.Document();

      // Create the PDF content
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo and clinic info
                _buildHeader(),
                pw.SizedBox(height: 20),

                // Patient Details Section
                _buildPatientDetails(billData),
                pw.SizedBox(height: 20),

                // Treatment Table
                _buildTreatmentTable(billData),
                pw.SizedBox(height: 20),

                // Total Amount Section
                _buildTotalSection(billData),
                pw.SizedBox(height: 30),

                // Footer
                _buildFooter(),
              ],
            );
          },
        ),
      );

      // Save and preview the PDF
      await _savePDF(pdf, billData.patientName);
    } catch (e) {
      log('PDF Generation Error: $e');
      Toasts.showError('Failed to generate PDF');
    }
  }

  // Alternative method for immediate preview with more options
  static Future<void> generateAndPreviewPatientBill(
    PatientBillData billData,
  ) async {
    try {
      final pdf = pw.Document();

      // Create the PDF content (same as above)
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                pw.SizedBox(height: 20),
                _buildPatientDetails(billData),
                pw.SizedBox(height: 20),
                _buildTreatmentTable(billData),
                pw.SizedBox(height: 20),
                _buildTotalSection(billData),
                pw.SizedBox(height: 30),
                _buildFooter(),
              ],
            );
          },
        ),
      );

      // Generate PDF bytes
      final Uint8List pdfBytes = await pdf.save();
      final fileName =
          'patient_bill_${billData.patientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Show PDF in a viewer with print and share options
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
        format: PdfPageFormat.a4,
      );

      // Also save PDF to device for future reference
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        log('PDF saved to: ${file.path}');
      }

      Toasts.showSuccess('PDF preview opened successfully!');
    } catch (e) {
      log('PDF Preview Error: $e');
      Toasts.showError('Failed to preview PDF');
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        children: [
          // Logo and clinic name
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 60,
                height: 60,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  color: PdfColors.green,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'LOGO',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'KUMARAKOM',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Cheepunkal P.O, Kumarakom, kottayam, Kerala - 686563',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'e-mail: info@kumarakom.com, www.kumarakom.com',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Mob: +91 9876543210 | +91 9876543210',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'GST No: 32AABCU9603F1ZW',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
        ],
      ),
    );
  }

  static pw.Widget _buildPatientDetails(PatientBillData billData) {
    String formatDate(DateTime date) =>
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Patient Details',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Name', billData.patientName),
                    _buildDetailRow('Address', billData.address),
                    _buildDetailRow('WhatsApp Number', billData.whatsappNumber),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Booked On',
                      '${formatDate(billData.bookedOn)} | 11:12pm',
                    ),
                    _buildDetailRow(
                      'Treatment Date',
                      formatDate(billData.treatmentDate),
                    ),
                    _buildDetailRow('Treatment Time', billData.treatmentTime),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  static pw.Widget _buildTreatmentTable(PatientBillData billData) {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Treatment',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FractionColumnWidth(0.3),
              1: const pw.FractionColumnWidth(0.15),
              2: const pw.FractionColumnWidth(0.1),
              3: const pw.FractionColumnWidth(0.1),
              4: const pw.FractionColumnWidth(0.15),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Treatment', isHeader: true),
                  _buildTableCell('Price', isHeader: true),
                  _buildTableCell('Male', isHeader: true),
                  _buildTableCell('Female', isHeader: true),
                  _buildTableCell('Total', isHeader: true),
                ],
              ),
              // Data rows
              ...billData.treatments.map(
                (treatment) => pw.TableRow(
                  children: [
                    _buildTableCell(treatment.treatmentName),
                    _buildTableCell('₹${treatment.price.toInt()}'),
                    _buildTableCell(treatment.maleCount.toString()),
                    _buildTableCell(treatment.femaleCount.toString()),
                    _buildTableCell('₹${treatment.total.toInt()}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTotalSection(PatientBillData billData) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 200,
        child: pw.Column(
          children: [
            _buildTotalRow('Total Amount', '₹${billData.totalAmount.toInt()}'),
            _buildTotalRow('Discount', '₹${billData.discount.toInt()}'),
            _buildTotalRow('Advance', '₹${billData.advance.toInt()}'),
            pw.Divider(),
            _buildTotalRow(
              'Balance',
              '₹${billData.balance.toInt()}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTotalRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            'Thank you for choosing us',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Your health, our commitment',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 30),
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Signature',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _savePDF(pw.Document pdf, String patientName) async {
    try {
      // Generate PDF bytes
      final Uint8List pdfBytes = await pdf.save();
      final fileName =
          'patient_bill_${patientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Show PDF preview immediately using the printing package
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
        format: PdfPageFormat.a4,
      );

      // For mobile platforms, also save to documents directory
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        log('PDF saved to: ${file.path}');
      }

      Toasts.showSuccess('PDF generated and opened for preview!');
    } catch (e) {
      log('Save PDF Error: $e');
      // Fallback to share if preview fails
      try {
        final Uint8List pdfBytes = await pdf.save();
        final fileName = 'patient_bill_${patientName.replaceAll(' ', '_')}.pdf';

        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
        Toasts.showSuccess('PDF generated successfully!');
      } catch (fallbackError) {
        log('Fallback PDF Error: $fallbackError');
        Toasts.showError('Failed to generate PDF');
      }
    }
  }
}
