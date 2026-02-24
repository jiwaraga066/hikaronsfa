import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

Future<File> addAttendanceWatermark({
  required XFile originalXFile,
  required String status,
  required String sales,
  required String address,
  required String latitude,
  required String longitude,
  required String customer,
}) async {
  final bytes = await originalXFile.readAsBytes();
  img.Image? image = img.decodeImage(bytes);

  if (image == null) {
    throw Exception("Gagal decode image");
  }

  final now = DateTime.now();
  final formattedTime = DateFormat("dd MMM yyyy HH:mm").format(now);

  int padding = 20;
  int lineHeight = 28;
  int maxTextWidth = image.width - (padding * 2);

  // 🔥 FUNCTION AUTO WRAP
  List<String> wrapTextByLength(String text, int maxCharsPerLine) {
    List<String> result = [];

    while (text.length > maxCharsPerLine) {
      int breakIndex = text.lastIndexOf(" ", maxCharsPerLine);
      if (breakIndex == -1) {
        breakIndex = maxCharsPerLine;
      }

      result.add(text.substring(0, breakIndex));
      text = text.substring(breakIndex).trim();
    }

    if (text.isNotEmpty) {
      result.add(text);
    }

    return result;
  }

  List<String> lines = [];

  lines.add(status);
  lines.add("Sales : $sales");

  // 🔥 WRAP ADDRESS
  lines.addAll(wrapTextByLength("Address : $address", 50));

  lines.add("Location : $latitude, $longitude");
  lines.add("Time : $formattedTime");
  lines.add("Customer : $customer");

  int boxHeight = (lines.length * lineHeight) + (padding * 2);

  // Background hitam transparan
  img.fillRect(image, x1: 0, y1: image.height - boxHeight, x2: image.width, y2: image.height, color: img.ColorRgba8(0, 0, 0, 160));

  // Draw text
  for (int i = 0; i < lines.length; i++) {
    int yPosition = image.height - boxHeight + padding + (i * lineHeight);

    // Shadow
    img.drawString(image, font: img.arial24, x: padding + 2, y: yPosition + 2, lines[i], color: img.ColorRgb8(0, 0, 0));

    // Text utama
    img.drawString(image, font: img.arial24, x: padding, y: yPosition, lines[i], color: img.ColorRgb8(255, 255, 255));
  }

  final directory = await getTemporaryDirectory();
  final newPath = "${directory.path}/absen_${DateTime.now().millisecondsSinceEpoch}.jpg";

  final watermarkedFile = File(newPath)..writeAsBytesSync(img.encodeJpg(image, quality: 85));

  return watermarkedFile;
}
