import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_list/core/navigation/global_navigator.dart';
import 'package:todo_list/domain/services/i_notification_service.dart';

class LocalNotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  /// Payload notification được dùng như **deep link path** (vd: `/login`,
  /// `/task/123`). Khi user tap, dùng [GoRouter] để điều hướng — tự đi qua
  /// redirect logic (auth guard...) giống mọi navigation thông thường.
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    GlobalNavigator.router?.pushPath(payload);
  }

  @override
  Future<void> sendNotification({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'forgot_password_channel',
      'Forgot Password',
      channelDescription: 'Thông báo thông tin tài khoản để reset mật khẩu',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
      payload: '/login',
    );
  }
}
