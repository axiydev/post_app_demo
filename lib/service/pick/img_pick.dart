import 'package:image_picker/image_picker.dart';
import 'package:post_app_demo/util/logger.dart';

class PickService {
  ImagePicker? _picker;
  PickService._private() {
    _picker = ImagePicker();
    Log.log('picker inited');
  }
  static final _instance = PickService._private();
  factory PickService() => _instance;
  Future<XFile?> getFileFromGallery() async {
    try {
      final XFile? file = await _picker!.pickImage(source: ImageSource.gallery);
      return file;
    } catch (e) {
      Log.log(e);
    }
    return null;
  }

  Future<XFile?> getFileFromCamera() async {
    try {
      final XFile? file = await _picker!.pickImage(source: ImageSource.camera);
      return file;
    } catch (e) {
      Log.log(e);
    }
    return null;
  }
}
