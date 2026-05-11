import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/local/database/journal_database.dart';
import 'package:todo_list/model/journal.dart';

// Service đóng vai trò "Repository" cho Journal — thao tác CRUD trên 2 bảng:
//   - journals: dữ liệu chính của một bài Journal (title, content, dateTime, folderId,...)
//   - journal_images: ảnh đính kèm (1 Journal có thể có nhiều ảnh, lưu theo position)
class JournalDbService {
  final DatabaseService _dbService;

  JournalDbService(this._dbService);

  // Thêm mới (hoặc thay thế nếu id trùng) một Journal kèm danh sách ảnh.
  // Toàn bộ thao tác chạy trong 1 transaction → nếu một bước fail, mọi thay đổi sẽ rollback.
  Future<void> insertJournal(Journal journal) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      // Bước 1: Insert (hoặc replace nếu id đã tồn tại) record vào bảng journals.
      await txn.insert(
        'journals',
        journal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Bước 2: Xoá hết ảnh cũ thuộc journal này trước khi insert lại.
      // Cách làm này đơn giản hơn việc "diff" từng path → đảm bảo position luôn chuẩn theo thứ tự client truyền vào.
      await txn.delete('journal_images', where: 'journalId = ?', whereArgs: [journal.id]);

      // Bước 3: Insert lần lượt từng ảnh với position = index trong list.
      // Id của ảnh được sinh theo pattern "<journalId>_<index>" để duy nhất + dễ debug.
      for (var i = 0; i < journal.imagePaths.length; i++) {
        await txn.insert('journal_images', {
          'id': '${journal.id}_$i',
          'journalId': journal.id,
          'path': journal.imagePaths[i],
          'position': i,
        });
      }
    });
  }

  // Lấy toàn bộ Journal trong DB kèm danh sách ảnh tương ứng.
  Future<List<Journal>> getJournals() async {
    final db = await _dbService.database;

    // Bước 1: Query bảng journals → list các Map row.
    final maps = await db.query('journals');

    // Bước 2: Convert mỗi Map row thành object Journal (lúc này imagePaths = []).
    final journals = maps.map((m) => Journal.fromMap(m)).toList();

    // Bước 3: Gắn danh sách ảnh từ bảng phụ vào từng Journal.
    return _attachImages(db, journals);
  }

  // Lấy danh sách Journal thuộc 1 folder cụ thể kèm ảnh.
  Future<List<Journal>> getJournalsByFolder(String folderId) async {
    final db = await _dbService.database;

    // Bước 1: Query bảng journals với điều kiện folderId trùng khớp.
    final maps = await db.query(
      'journals',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );

    // Bước 2: Convert + Bước 3: Gắn ảnh (tương tự getJournals).
    final journals = maps.map((m) => Journal.fromMap(m)).toList();
    return _attachImages(db, journals);
  }

  // Xoá một Journal theo id.
  // KHÔNG cần xoá thủ công bên bảng journal_images vì FK đã khai báo ON DELETE CASCADE.
  Future<void> deleteJournal(String id) async {
    final db = await _dbService.database;
    await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }

  // Cập nhật riêng danh sách ảnh của 1 Journal (không động vào bảng journals).
  // Dùng khi user edit ảnh mà không edit nội dung text — tránh phải gọi insertJournal lại toàn bộ.
  Future<void> updateJournalImages(String journalId, List<String> paths) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      // Bước 1: Xoá hết ảnh cũ của journal này.
      await txn.delete('journal_images', where: 'journalId = ?', whereArgs: [journalId]);

      // Bước 2: Insert lại theo thứ tự client truyền vào.
      for (var i = 0; i < paths.length; i++) {
        await txn.insert('journal_images', {
          'id': '${journalId}_$i',
          'journalId': journalId,
          'path': paths[i],
          'position': i,
        });
      }
    });
  }

  // Hàm tiện ích nội bộ: load ảnh cho 1 batch Journal và gắn vào từng Journal tương ứng.
  // Mục đích tối ưu: chỉ thực hiện 1 query duy nhất cho toàn bộ batch thay vì query nhiều lần (N+1 problem).
  Future<List<Journal>> _attachImages(Database db, List<Journal> journals) async {
    if (journals.isEmpty) return journals; // Nếu danh sách trống thì trả về luôn.

    // Bước 1: Thu thập tất cả ID của các Journal đang có trong danh sách.
    final ids = journals.map((j) => j.id).toList();

    // Bước 2: Tạo các dấu "?" tương ứng với số lượng ID để dùng trong câu lệnh SQL IN.
    // Ví dụ nếu có 3 ID, placeholders sẽ là "?,?,?".
    final placeholders = List.filled(ids.length, '?').join(',');

    // Bước 3: Truy vấn bảng ảnh một lần duy nhất cho TẤT CẢ các Journal.
    final imageMaps = await db.query(
      'journal_images',
      where: 'journalId IN ($placeholders)', // Lấy tất cả ảnh thuộc về các ID này.
      whereArgs: ids,
      orderBy: 'journalId, position ASC', // Sắp xếp theo ID và thứ tự ảnh.
    );

    // Bước 4: Nhóm các ảnh lại theo journalId bằng một Map.
    // Key: journalId, Value: Danh sách đường dẫn ảnh [path1, path2,...].
    final Map<String, List<String>> byJournal = {};
    for (final m in imageMaps) {
      final jid = m['journalId'] as String;
      byJournal.putIfAbsent(jid, () => []).add(m['path'] as String);
    }

    // Bước 5: Duyệt lại danh sách Journal và gắn danh sách ảnh tương ứng từ Map vào.
    return journals
        .map((j) => j.copyWith(imagePaths: byJournal[j.id] ?? const []))
        .toList();
  }
}
