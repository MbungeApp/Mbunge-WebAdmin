import 'package:file_picker/file_picker.dart';

class AssetPickerService {
  AssetPickerService._internal();
  static final AssetPickerService _asset = AssetPickerService._internal();
  factory AssetPickerService() {
    return _asset;
  }

  static Future<FilePickerResult> pickImage({bool allowMulti = false}) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: allowMulti,
    );
    return result;
  }
}
