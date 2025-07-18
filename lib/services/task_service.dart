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

  static int streak = 0; // Arka arkaya gün sayısı
  static DateTime? lastStudyDate;
  static bool didStudyToday() {
    return lastStudyDate != null && DateFormat('yyyy-MM-dd').format(lastStudyDate!) == todayKey();
  }
  static void markStudyToday() {
    final today = DateTime.now();
    if (lastStudyDate == null) {
      streak = 1;
    } else {
      final diff = today.difference(lastStudyDate!).inDays;
      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        streak = 1;
      }
    }
    lastStudyDate = today;
  }
  static bool completedDailyGoal() {
    // Örnek: 1 saatlik görev tamamlandıysa
    return todayTasks().any((t) => t.isDone);
  }
}
