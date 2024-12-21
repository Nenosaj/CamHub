import 'package:file_picker/file_picker.dart';

Future<String?> pickPdfFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files only
    );

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      print('Selected PDF file: $filePath');
      return filePath;
    } else {
      print('No file selected');
      return null;
    }
  } catch (e) {
    print('Error picking file: $e');
    return null;
  }
}
