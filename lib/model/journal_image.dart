import 'package:equatable/equatable.dart';

// Model đại diện cho 1 ảnh đính kèm của Journal (1 row trong bảng journal_images).
// Hiện tại JournalDbService đang lưu/đọc ảnh trực tiếp dưới dạng List<String> trong Journal.imagePaths,
// model này được giữ để dùng khi cần thao tác ảnh ở mức từng record (ví dụ: edit position, xoá 1 ảnh).
class JournalImage extends Equatable {
  final String id; // Khoá chính của row ảnh. Pattern thường dùng: "<journalId>_<index>".
  final String journalId; // FK tới Journal sở hữu ảnh này.
  final String path; // Đường dẫn file ảnh trên local (sau này có thể là http URL).
  final int position; // Thứ tự hiển thị trong journal (0-based).

  const JournalImage({
    required this.id,
    required this.journalId,
    required this.path,
    required this.position,
  });

  // Tạo bản copy với các field được override → tiện khi cần đổi position mà giữ nguyên id/path.
  JournalImage copyWith({
    String? id,
    String? journalId,
    String? path,
    int? position,
  }) {
    return JournalImage(
      id: id ?? this.id,
      journalId: journalId ?? this.journalId,
      path: path ?? this.path,
      position: position ?? this.position,
    );
  }

  // Convert sang Map để insert/update vào bảng journal_images.
  // Tên các key trùng khớp 100% với tên cột trong schema SQL.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'journalId': journalId,
      'path': path,
      'position': position,
    };
  }

  // Tạo JournalImage từ 1 row Map đọc từ SQLite.
  // Fallback giá trị mặc định ('' và 0) để tránh null crash nếu cột bị null bất thường.
  factory JournalImage.fromMap(Map<String, dynamic> map) {
    return JournalImage(
      id: map['id'] ?? '',
      journalId: map['journalId'] ?? '',
      path: map['path'] ?? '',
      position: map['position'] as int? ?? 0,
    );
  }

  // Equatable: so sánh dựa trên tất cả field.
  @override
  List<Object?> get props => [id, journalId, path, position];
}
