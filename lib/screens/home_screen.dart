import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';


import 'package:go_router/go_router.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<NoteModel> _shuffledNotes = [];

  final List<String> _filters = [
    'All',
    'Important',
    'Lecture Notes',
    'To-do Lists'
  ];

  final List<Color> cardColors = [
    const Color(0xFFFFF9C4),
    const Color(0xFFD4EDDA),
    const Color(0xFFFFE0B2),
    const Color(0xFFE3F2FD),
    const Color(0xFFF8BBD0),
    const Color(0xFFE8F5E9),
  ];

  DateTime _selectedDate = DateTime.now();

  List<DateTime> _getWeekDays() {
    final now = DateTime.now();
    return List.generate(4, (i) => now.add(Duration(days: i)));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

void _openAddNote() {
  context.push('/add-note');
}

void _openEditNote(NoteModel note) {
  context.push('/add-note', extra: note);
}

  // DELETE — direct, no dialog
  Future<void> _deleteNote(String id) async {
    await _service.deleteNote(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note deleted'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined,
                        color: Color(0xFF1A1A2E), size: 28),
                    onPressed: () {
context.push('/profile');
                    },
                  ),
                                    IconButton(
                    icon: const Icon(Icons.search,
                        color: Color(0xFF1A1A2E), size: 28),
                    onPressed: () {
context.push('/search-products');
                    },
                  ),
                  IconButton(
  icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1A1A2E)),
  onPressed: () => context.push( '/products'),
),
                ],
              ),
            ),

            // ── Search Bar ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search for notes',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // ── Calendar ─────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getWeekDays().map((date) {
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C4DFF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // ── Filter Chips ─────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (_, i) {
                  final selected = _selectedFilter == _filters[i];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedFilter = _filters[i]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1A1A2E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF1A1A2E)
                              : Colors.grey.shade300,
                        ),
                      ),
                      
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : Colors.grey.shade600,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ── Notes Grid ───────────────────────────────────
            Expanded(
              child: StreamBuilder<List<NoteModel>>(
  stream: _searchQuery.isNotEmpty
      ? _service.searchNotes(_searchQuery)
      : _service.getNotes(),
  builder: (context, snapshot) {
    // ── Loading ──────────────────────────────
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
      );
    }

    // ── Error ────────────────────────────────
    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red)),
      );
    }

    var notes = snapshot.data ?? [];

    // ── Shuffled list sync ───────────────────
    if (_shuffledNotes.length != notes.length) {
      _shuffledNotes = List.from(notes);
    }

    // ── Filter ───────────────────────────────
    final displayNotes = _selectedFilter != 'All'
        ? _shuffledNotes
            .where((n) => n.category == _selectedFilter)
            .toList()
        : _shuffledNotes;

    // ── Empty ────────────────────────────────
    if (displayNotes.isEmpty) {
      return const Center(
        child: Text(
          'No Any Notes.\n+ Press button to create note',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ReorderableGridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: displayNotes.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final item = _shuffledNotes.removeAt(oldIndex);
          _shuffledNotes.insert(newIndex, item);
        });
      },
      itemBuilder: (_, i) {
        final note = displayNotes[i];
        final color = cardColors[note.colorIndex % cardColors.length];
        return GestureDetector(
          key: ValueKey(note.id),
          onTap: () => _openEditNote(note),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deleteNote(note.id),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  note.category,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  },
),
            ),
          ],
        ),
      ),

      // ── FAB ────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddNote,
        backgroundColor: const Color(0xFF1A1A2E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}