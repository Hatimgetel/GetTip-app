import 'package:shared_preferences/shared_preferences.dart';

const List<double> kDefaultQuickAddValues = <double>[10, 20, 50];
const List<String> kDefaultQuickAddNotes = <String>[
  'quick add \$10',
  'quick add \$20',
  'quick add \$50',
];

const String _quickAdd1Key = 'quick_add_value_1';
const String _quickAdd2Key = 'quick_add_value_2';
const String _quickAdd3Key = 'quick_add_value_3';
const String _quickAddNote1Key = 'quick_add_note_1';
const String _quickAddNote2Key = 'quick_add_note_2';
const String _quickAddNote3Key = 'quick_add_note_3';
const String _legacyQuickAddNoteKey = 'quick_add_note';

class QuickAddSettingsService {
  Future<List<double>> loadValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double v1 = prefs.getDouble(_quickAdd1Key) ?? kDefaultQuickAddValues[0];
    final double v2 = prefs.getDouble(_quickAdd2Key) ?? kDefaultQuickAddValues[1];
    final double v3 = prefs.getDouble(_quickAdd3Key) ?? kDefaultQuickAddValues[2];
    return <double>[v1, v2, v3];
  }

  Future<void> saveValues(List<double> values) async {
    if (values.length != 3) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_quickAdd1Key, values[0]);
    await prefs.setDouble(_quickAdd2Key, values[1]);
    await prefs.setDouble(_quickAdd3Key, values[2]);
  }

  Future<List<String>> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? legacyNote = prefs.getString(_legacyQuickAddNoteKey);
    final String n1 = prefs.getString(_quickAddNote1Key) ??
        legacyNote ??
        kDefaultQuickAddNotes[0];
    // Keep legacy migration only for button 1 so buttons 2/3 can keep distinct notes.
    final String n2 = prefs.getString(_quickAddNote2Key) ?? kDefaultQuickAddNotes[1];
    final String n3 = prefs.getString(_quickAddNote3Key) ?? kDefaultQuickAddNotes[2];
    return <String>[n1, n2, n3];
  }

  Future<void> saveNotes(List<String> notes) async {
    if (notes.length != 3) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quickAddNote1Key, notes[0].trim());
    await prefs.setString(_quickAddNote2Key, notes[1].trim());
    await prefs.setString(_quickAddNote3Key, notes[2].trim());
  }

  Future<void> resetToDefaults() async {
    await saveValues(kDefaultQuickAddValues);
    await saveNotes(kDefaultQuickAddNotes);
  }
}
