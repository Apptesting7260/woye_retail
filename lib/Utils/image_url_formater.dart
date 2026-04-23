class ImageUrlFormater {
 static String extractFilename(String url) {
    return url.split('/').last;
  }
}