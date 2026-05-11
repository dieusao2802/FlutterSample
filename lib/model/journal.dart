import 'package:equatable/equatable.dart';

// Model đại diện cho 1 bài Journal trong app.
// Kế thừa Equatable để 2 Journal có cùng giá trị các field được coi là bằng nhau (==).
// → Hữu ích khi dùng trong state management (Riverpod, Bloc) để rebuild đúng lúc.
class Journal extends Equatable {
  final String id; // Khoá chính, duy nhất cho mỗi Journal (thường là UUID).
  final String? title; // Tiêu đề. Nullable vì cho phép Journal chưa nhập title.
  final String? content; // Nội dung dài. Nullable tương tự title.
  final DateTime? dateTime; // Thời điểm Journal nói tới (do user chọn ở date+time picker). Nullable cho record cũ migrate từ v1.
  final bool done; // Đánh dấu đã hoàn thành (legacy field, giữ lại theo yêu cầu).
  final String? folderId; // FK tới Folder. Nullable nếu Journal chưa được gán vào folder nào.
  final List<String> imagePaths; // Danh sách path ảnh đính kèm, thứ tự đúng như user sắp xếp.

  // Constructor có giá trị mặc định cho các field optional → tạo Journal mới chỉ cần truyền id.
  const Journal({
    required this.id,
    this.title,
    this.content,
    this.dateTime,
    this.done = false,
    this.folderId,
    this.imagePaths = const [],
  });

  // Tạo bản copy của Journal với các field được override.
  // Pattern phổ biến cho immutable model — sửa 1 field mà không phải khai báo lại toàn bộ.
  Journal copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? dateTime,
    bool? done,
    String? folderId,
    List<String>? imagePaths,
  }) {
    return Journal(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
      done: done ?? this.done,
      folderId: folderId ?? this.folderId,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }

  // Convert sang Map để insert vào SQLite.
  // Lưu ý: CHỈ map các cột thuộc bảng `journals`. `imagePaths` được lưu ở bảng phụ `journal_images`,
  // xử lý riêng bởi JournalDbService.insertJournal().
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      // DateTime → millisecondsSinceEpoch (INTEGER) để lưu/sort dễ trong SQLite.
      'dateTime': dateTime?.millisecondsSinceEpoch,
      // bool → 0/1 vì SQLite không có kiểu bool native.
      'isCompleted': done ? 1 : 0,
      'folderId': folderId,
    };
  }

  // Tạo Journal từ 1 row Map đọc từ SQLite.
  // imagePaths để mặc định const [] — sẽ được fill sau bởi JournalDbService._attachImages().
  factory Journal.fromMap(Map<String, dynamic> map) {
    final ts = map['dateTime'] as int?;
    return Journal(
      id: map['id'] ?? '',
      title: map['title'],
      content: map['content'],
      // Reverse millisecondsSinceEpoch → DateTime. Null thì giữ null (record cũ migrate chưa có dateTime).
      dateTime: ts == null ? null : DateTime.fromMillisecondsSinceEpoch(ts),
      done: map['isCompleted'] == 1,
      folderId: map['folderId'],
    );
  }

  // Equatable cần biết các field để compare. Bao gồm cả imagePaths để 2 Journal khác ảnh sẽ không bằng nhau.
  @override
  List<Object?> get props => [id, title, content, dateTime, done, folderId, imagePaths];
}
