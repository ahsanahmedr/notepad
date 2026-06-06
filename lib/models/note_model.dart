class NoteModel {
  final String id;
  final String title;
  final String content;
  final String category; // 'Products list', 'To-do Lists', etc.
  final int colorIndex;  // card ka color
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.colorIndex,
    required this.createdAt,
  });

  factory NoteModel.fromMap(String id, Map<String, dynamic> data) {
    return NoteModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'Notes',
      colorIndex: data['colorIndex'] ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'colorIndex': colorIndex,
      'createdAt': createdAt,
    };
  }
}