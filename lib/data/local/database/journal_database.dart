import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Service quản lý kết nối SQLite cho phần Journal/Folder của app.
// Sử dụng pattern singleton qua biến static _database để toàn app chỉ mở 1 connection.
class DatabaseService {
  // Lưu instance Database sau lần khởi tạo đầu — các lần gọi sau dùng lại, tránh mở DB lặp.
  static Database? _database;

  // Getter chính được dùng từ các DbService khác (FolderDbService, JournalDbService,...).
  // Lần đầu sẽ trigger _initDatabase(), lần sau trả về instance đã cache.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Mở database. Nếu file chưa tồn tại → tạo mới qua onCreate.
  // Nếu file đã tồn tại với version cũ hơn `version` hiện tại → chạy onUpgrade để migrate schema.
  Future<Database> _initDatabase() async {
    // Đường dẫn DB nằm trong thư mục mặc định của sqflite, file tên `app_v2.db`.
    String path = join(await getDatabasesPath(), 'app_v2.db');

    return await openDatabase(
      path,
      version: 2, // Bump khi schema thay đổi để kích hoạt onUpgrade trên máy user.
      // ============================================================
      // onCreate: chỉ chạy khi DB file lần đầu được tạo (user mới cài app).
      // ============================================================
      onCreate: (db, version) async {
        // Bảng folders: lưu thư mục chứa các Journal.
        // - name_normalized: phiên bản lowercase + bỏ dấu của name, dùng để search không dấu.
        // - colorIndex: index trong enum FolderColor để render màu UI.
        await db.execute('''
          CREATE TABLE folders(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            name_normalized TEXT NOT NULL,
            colorIndex INTEGER NOT NULL
          )
        ''');

        // Index trên cột name_normalized → tăng tốc query LIKE khi search folder.
        await db.execute('''
          CREATE INDEX idx_folders_name_normalized ON folders(name_normalized)
        ''');

        // Bảng journals: dữ liệu chính của 1 bài viết Journal.
        // - dateTime: lưu dạng millisecondsSinceEpoch (INTEGER) để dễ sort/filter.
        // - isCompleted: SQLite không có kiểu bool → dùng INTEGER 0/1.
        // - folderId: FK trỏ đến folders.id. ON DELETE CASCADE = xoá folder thì xoá luôn journal con.
        await db.execute('''
          CREATE TABLE journals(
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            dateTime INTEGER,
            isCompleted INTEGER,
            folderId TEXT,
            FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
          )
        ''');

        // Bảng journal_images: lưu ảnh đính kèm theo từng Journal (quan hệ 1-N).
        // - position: thứ tự hiển thị của ảnh trong journal.
        // - journalId: FK trỏ đến journals.id. CASCADE để xoá journal kéo theo xoá ảnh.
        await db.execute('''
          CREATE TABLE journal_images(
            id TEXT PRIMARY KEY,
            journalId TEXT NOT NULL,
            path TEXT NOT NULL,
            position INTEGER NOT NULL,
            FOREIGN KEY (journalId) REFERENCES journals (id) ON DELETE CASCADE
          )
        ''');

        // Index trên journalId → tăng tốc query "lấy ảnh theo journalId" (operation phổ biến nhất).
        await db.execute('''
          CREATE INDEX idx_journal_images_journalId ON journal_images(journalId)
        ''');
      },
      // ============================================================
      // onUpgrade: chạy khi user đã có DB version cũ và app bump version.
      // ============================================================
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migration v1 → v2.
        if (oldVersion < 2) {
          // Đổi tên bảng todos -> journals và bổ sung cột content + dateTime.
          // 2 cột mới để nullable vì SQLite không cho phép ADD COLUMN NOT NULL nếu không có default;
          // record cũ sẽ có giá trị NULL, record mới luôn được app gán giá trị khi save.
          await db.execute('ALTER TABLE todos RENAME TO journals');
          await db.execute('ALTER TABLE journals ADD COLUMN content TEXT');
          await db.execute('ALTER TABLE journals ADD COLUMN dateTime INTEGER');

          // Tạo bảng phụ chứa ảnh (chưa tồn tại ở v1).
          await db.execute('''
            CREATE TABLE journal_images(
              id TEXT PRIMARY KEY,
              journalId TEXT NOT NULL,
              path TEXT NOT NULL,
              position INTEGER NOT NULL,
              FOREIGN KEY (journalId) REFERENCES journals (id) ON DELETE CASCADE
            )
          ''');
          await db.execute('''
            CREATE INDEX idx_journal_images_journalId ON journal_images(journalId)
          ''');
        }
      },
    );
  }
}
