// lib/services/task_service.dart
import 'package:intl/intl.dart';
import '../pages/planner_page.dart'; // Task modelinin bulunduğu sayfanın yolu

class TaskService {
  /// Tüm görevler burada saklanır: tarih anahtarı -> görev listesi
  static final Map<String, List<Task>> dailyTasks = {};

  /// Bugünün anahtarı: "2025-07-05" gibi
  static String todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Bugünün tüm görevleri
  static List<Task> todayTasks() => dailyTasks[todayKey()] ?? [];

  /// Tamamlanan görev sayısı
  static int completedToday() =>
      todayTasks().where((t) => t.isDone).length;

  /// Toplam görev sayısı
  static int totalToday() => todayTasks().length;

  /// İlerleme yüzdesi (0.0 – 1.0)
  static double progressToday() {
    final total = totalToday();
    return total == 0 ? 0 : (completedToday() / total);
  }
}
