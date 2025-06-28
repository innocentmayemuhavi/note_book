import 'dart:convert';

enum NoteStatus {
  pending('Pending', '⏳'),
  inProgress('In Progress', '🔄'),
  completed('Completed', '✅'),
  archived('Archived', '📦'),
  cancelled('Cancelled', '❌');

  const NoteStatus(this.label, this.emoji);
  final String label;
  final String emoji;
}

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final List<String> tags;
  final bool isPinned;
  final int color;
  final NoteStatus status;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.category = 'General',
    this.tags = const [],
    this.isPinned = false,
    this.color = 0xFFFFFFFF,
    this.status = NoteStatus.pending,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    List<String>? tags,
    bool? isPinned,
    int? color,
    NoteStatus? status,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'category': category,
      'tags': tags,
      'isPinned': isPinned,
      'color': color,
      'status': status.name,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      category: map['category'] ?? 'General',
      tags: List<String>.from(map['tags'] ?? []),
      isPinned: map['isPinned'] ?? false,
      color: map['color'] ?? 0xFFFFFFFF,
      status: NoteStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => NoteStatus.pending,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, tags: $tags, isPinned: $isPinned, color: $color, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
