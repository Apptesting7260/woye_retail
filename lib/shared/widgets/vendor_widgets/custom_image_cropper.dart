

import 'package:image_cropper/image_cropper.dart';

class CropAspectRatioPresetCustom9x6 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (9, 6);

  @override
  String get name => '9x6';
}

class CropAspectRatioPresetCustom2x2 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 2);

  @override
  String get name => '2x2';
}

//200*200
class CropAspectRatioPresetCustom1x1 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1';
}

//1200 * 600
class CropAspectRatioPresetCustom2x1 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 1);

  @override
  String get name => '2x1';
}
