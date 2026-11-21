
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Note model

class NoteItem {
  final String id;
  final String title;
  final String dateText;
  bool isCompleted;

  NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateText': dateText,
      'isCompleted': isCompleted,
    };
  }

  // Deserialization
  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      dateText: json['dateText'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

// Initialize storage before runApp()

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Load saved theme
  final isDarkMode =
      prefs.getBool('app_theme_dark_mode') ?? false;

  // Load saved username
  final username =
      prefs.getString('user_display_name') ?? 'Guest User';

  // Load saved notes
  final notesJson =
      prefs.getString('saved_notes') ?? '[]';

  final List<dynamic> decodedNotes = jsonDecode(notesJson);

  final List<NoteItem> notes = decodedNotes
      .map((item) => NoteItem.fromJson(
            item as Map<String, dynamic>,
          ))
      .toList();

  runApp(
    NotesVaultApp(
      prefs: prefs,
      initialDarkMode: isDarkMode,
      initialUsername: username,
      initialNotes: notes,
    ),
  );
}

// Main application

class NotesVaultApp extends StatefulWidget {
  final SharedPreferences prefs;
  final bool initialDarkMode;
  final String initialUsername;
  final List<NoteItem> initialNotes;

  const NotesVaultApp({
    super.key,
    required this.prefs,
    required this.initialDarkMode,
    required this.initialUsername,
    required this.initialNotes,
  });

  @override
  State<NotesVaultApp> createState() => _NotesVaultAppState();
}

class _NotesVaultAppState extends State<NotesVaultApp> {
  late bool isDarkMode;
  late String username;
  late List<NoteItem> notes;

  final usernameController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isDarkMode = widget.initialDarkMode;
    username = widget.initialUsername;
    notes = widget.initialNotes;

    usernameController.text = username;
  }

  // Task 1: Theme persistence

  Future<void> changeTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    await widget.prefs.setBool(
      'app_theme_dark_mode',
      value,
    );
  }

  // Task 2: Username persistence

  Future<void> saveUsername() async {
    final name = usernameController.text.trim();

    setState(() {
      username = name.isEmpty ? 'Guest User' : name;
      usernameController.text = username;
    });

    await widget.prefs.setString(
      'user_display_name',
      username,
    );
  }

  // Task 3: Save notes using JSON

  Future<void> saveNotes() async {
    final notesJson = jsonEncode(
      notes.map((note) => note.toJson()).toList(),
    );

    await widget.prefs.setString(
      'saved_notes',
      notesJson,
    );
  }

  // Add a note

  Future<void> addNote() async {
    final title = noteController.text.trim();

    if (title.isEmpty) return;

    final now = DateTime.now();

    final dateText =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year}';

    final newNote = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      dateText: dateText,
    );

    setState(() {
      notes.insert(0, newNote);
      noteController.clear();
    });

    await saveNotes();
  }

  // Toggle note completion

  Future<void> toggleNote(NoteItem note) async {
    setState(() {
      note.isCompleted = !note.isCompleted;
    });

    await saveNotes();
  }

  // Delete a note

  Future<void> deleteNote(String id) async {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });

    await saveNotes();
  }

  @override
  void dispose() {
    usernameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // User interface

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Vault',

      // Light theme
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      // Dark theme
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      themeMode:
          isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes Vault'),
          centerTitle: false,
          actions: [
            Icon(
              isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            Switch(
              value: isDarkMode,
              onChanged: changeTheme,
            ),
            const SizedBox(width: 12),
          ],
        ),

        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 650,
              ),

              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Screen header

                  Text(
                    'Hello, $username!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your notes and settings are saved locally.',
                  ),

                  const SizedBox(height: 24),

                  // User profile section

                  const Text(
                    'User Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => saveUsername(),
                  ),

                  const SizedBox(height: 10),

                  FilledButton(
                    onPressed: saveUsername,
                    child: const Text('Save Username'),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Notes section

                  const Text(
                    'My Notes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: noteController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a new note',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => addNote(),
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton.filled(
                        onPressed: addNote,
                        icon: const Icon(Icons.add),
                        tooltip: 'Add note',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Completion counter

                  Text(
                    '${notes.where((n) => n.isCompleted).length}'
                    ' of ${notes.length} notes completed',
                  ),

                  const SizedBox(height: 12),

                  // Empty state

                  if (notes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 60,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No notes yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text('Add your first note above.'),
                        ],
                      ),
                    ),

                  // Notes list

                  ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },

                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        key: ValueKey(note.id),

                        child: ListTile(
                          // Completion checkbox

                          leading: Checkbox(
                            value: note.isCompleted,
                            onChanged: (_) {
                              toggleNote(note);
                            },
                          ),

                          // Note title

                          title: Text(
                            note.title,
                            style: TextStyle(
                              decoration: note.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          // Creation date

                          subtitle: Text(note.dateText),

                          // Delete button

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            tooltip: 'Delete note',
                            onPressed: () {
                              deleteNote(note.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
