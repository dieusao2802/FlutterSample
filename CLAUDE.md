# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Chạy app
flutter run

# Phân tích code (lint)
flutter analyze

# Chạy toàn bộ tests
flutter test

# Chạy một test cụ thể
flutter test test/path/to/file_test.dart

# Format code
dart format lib/

# Sinh code (json_serializable, pigeon)
flutter pub run build_runner build
flutter pub run build_runner watch  # Chế độ watch liên tục

# Build release
flutter build apk --release
```

## Kiến trúc

Dự án theo pattern **MVVM** + **Provider** + **GetIt**.

### Luồng dữ liệu

```
Screen (UI)
  ↕ Provider / ChangeNotifier
ViewModel (extends BaseViewModel)
  ↕ GetIt (service locator)
Repository / Service
  ↕
SQLite (sqflite) + SharedPreferences
```

- **GetIt** đăng ký tất cả services, repositories và ViewModels trong `lib/core/di/service_locator.dart`, được gọi tại `main()` trước `runApp`.
- **Provider** dùng cho `TodoList` (ChangeNotifier) — quản lý danh sách todo trong bộ nhớ.
- **BaseViewModel** (`lib/view_models/base_view_model.dart`) cung cấp `ViewState` (idle / busy / error) và tự `notifyListeners()` khi state thay đổi.

### Lưu trữ

| Lưu trữ | Dùng cho |
|---|---|
| SQLite (`todo_app.db`) | Bảng `todos` và `users` |
| SharedPreferences | Session — key `user_email` để auto-login |

`DatabaseService` là singleton, lazy-init kết nối SQLite. Sơ đồ DB hiện tại ở version 2 (v2 thêm bảng `users`).

### Xác thực

Splash screen kiểm tra SharedPrefs + SQLite để quyết định điều hướng đến `/login` hay `/home`. `AuthRepository.login()` hiện đang mock — `ApiService` (Dio, baseUrl `https://api.example.com`) chưa tích hợp thật.

### Cấu trúc thư mục `lib/`

```
core/
  constants/    # AppColors
  di/           # service_locator.dart — đăng ký GetIt
  routes/       # AppRoutes (tên route)
  utils/        # validation, helper
data/
  repositories/ # AuthRepository
  services/     # DatabaseService, TodoDbService, UserDbService, ApiService
model/          # Todo, User, Gender
notifiers/      # TodoList (ChangeNotifier)
view_models/
  base_view_model.dart
  auth/         # LoginViewModel, RegisterViewModel, SplashViewModel
screens/        # UI screens (splash, auth, home)
widgets/        # Reusable widgets
style/          # TextStyles
log/            # AppLog wrapper (info/warning/error/exception/fatal)
pigeon/         # Platform channel code — auto-generated, đừng sửa tay
```

## Lưu ý quan trọng

- `pigeon/` là code auto-generated — không sửa tay, chạy `build_runner` để tái sinh.
- Models dùng `toMap()` / `fromMap()` cho SQLite (bool lưu thành INTEGER 0/1).
- `AppColors` và `TextStyles` là nguồn style duy nhất — không hardcode màu / font-size trực tiếp trong widget.