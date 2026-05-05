import 'package:pigeon/pigeon.dart';

// Đây là nơi bạn chỉnh sửa đường dẫn xuất (Output)
@ConfigurePigeon(PigeonOptions(
  // Đường dẫn file Dart được tạo ra (nên đặt là .g.dart để tách biệt)
  dartOut: 'lib/pigeon/user_api.g.dart',
  dartOptions: DartOptions(),

  // Đường dẫn file Kotlin cho Android
  kotlinOut: 'android/app/src/main/kotlin/com/tohsoft/pigeon/UserApi.kt',
  kotlinOptions: KotlinOptions(),

  // Đường dẫn file Swift cho iOS
  swiftOut: 'ios/Runner/pigeon/UserApi.swift',
  swiftOptions: SwiftOptions(),
))

// Định nghĩa cấu trúc dữ liệu
class UserPigeon {
  String? name;
  String? email;
  String? password;
}

// Định nghĩa các hàm giao tiếp
@HostApi()
abstract class UserNativeApi {
  void saveUserToNative(UserPigeon user);
  UserPigeon getUserFromNative();
}