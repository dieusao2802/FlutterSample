abstract class INotificationService {
  Future<void> initialize();

  Future<void> sendNotification({required String title, required String body});
}