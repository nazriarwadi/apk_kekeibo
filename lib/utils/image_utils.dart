// File: utils/image_utils.dart
import 'api_url.dart';

class ImageUtils {
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return ""; // Return empty string jika path gambar tidak tersedia
    }
    // Gabungkan baseUrl dengan path gambar
    return "${ApiUrl.baseUrl}$imagePath";
  }
}
