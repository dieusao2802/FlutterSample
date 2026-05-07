import 'package:equatable/equatable.dart';
import 'package:todo_list/core/enums/folder_color.dart';

class Folder extends Equatable {
  final String id;
  final String name;
  final FolderColor color;

  const Folder({
    required this.id,
    required this.name,
    required this.color,
  });

  Folder copyWith({
    String? id,
    String? name,
    FolderColor? color,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorIndex': color.index,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    final index = map['colorIndex'] as int? ?? 0;
    return Folder(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      color: index < FolderColor.values.length
          ? FolderColor.values[index]
          : FolderColor.values[0],
    );
  }

  @override
  List<Object?> get props => [id, name, color];
}
