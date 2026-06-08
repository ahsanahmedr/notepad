import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';

class AddNoteScreen extends StatefulWidget {
  final NoteModel? existingNote; // null = new note, value = edit mode

  const AddNoteScreen({super.key, this.existingNote});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _selectedCategory = 'Notes';
  int _selectedColorIndex = 0;
    bool _isSaving = false;

  final List<String> _categories = [
    'Notes',
    'Important',
    'To-do Lists',
    'Lecture Notes',
    'Products list',
    'Shopping List',
    'Vacation',
  ];

  final List<Color> _cardColors = [
    const Color(0xFFFFF9C4),
    const Color(0xFFD4EDDA),
    const Color(0xFFFFE0B2),
    const Color(0xFFE3F2FD),
    const Color(0xFFF8BBD0),
    const Color(0xFFE8F5E9),
  ];

  bool get _isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
      _selectedCategory = widget.existingNote!.category;
      _selectedColorIndex = widget.existingNote!.colorIndex;
    }
  }

  Future<void> _saveNote() async {
  if (_isSaving) return; // double press rokو
  
  final title = _titleController.text.trim();
  final content = _contentController.text.trim();

  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Title zaroor likho!')),
    );
    return;
  }

  setState(() => _isSaving = true);

  try {
    if (_isEditing) {
      // Color bhi update ho ab
      
      await _service.updateNote(
        widget.existingNote!.id,
        title,
        content,
        _selectedCategory,
        _selectedColorIndex,
      );
    } else {
      await _service.addNote(
        title: title,
        content: content,
        category: _selectedCategory,
        colorIndex: _selectedColorIndex,
      );
    }
    if (mounted) Navigator.pop(context);
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardColors[_selectedColorIndex],
      appBar: AppBar(
        backgroundColor: _cardColors[_selectedColorIndex],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Note' : 'New Note',
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
actions: [
  Padding(
    padding: const EdgeInsets.only(right: 8),
    child: _isSaving
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF7C4DFF),
            ),
          )
        : TextButton(
            onPressed: _saveNote,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF7C4DFF),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
  ),
],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title field ─────────────────────────────────
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),

            const Divider(color: Colors.black12),
            const SizedBox(height: 8),

            // ── Category dropdown ────────────────────────────
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedCategory = val!),
                style: const TextStyle(
                  color: Color(0xFF7C4DFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                icon: const Icon(Icons.expand_more,
                    color: Color(0xFF7C4DFF)),
              ),
            ),

            const SizedBox(height: 12),

            // ── Color picker ─────────────────────────────────
            Row(
              children: List.generate(_cardColors.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _cardColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColorIndex == i
                            ? const Color(0xFF7C4DFF)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ── Content field ─────────────────────────────────
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 15,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1A2E),
                height: 1.8,
              ),
              decoration: const InputDecoration(
                hintText: 'Write here...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}