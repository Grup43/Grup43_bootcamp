import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../services/task_service.dart';

class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['Günlük', 'Haftalık', 'Aylık'];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addTask(String taskTitle) {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      TaskService.dailyTasks.putIfAbsent(key, () => []);
      TaskService.dailyTasks[key]!.add(Task(taskTitle));
    });
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görev Ekle'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Görev adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) _addTask(text);
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showGeminiPlanningDialog(BuildContext context) {
    DateTimeRange? selectedRange;
    double dailyHours = 2;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Akıllı Planlama"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (range != null) {
                        setState(() => selectedRange = range);
                      }
                    },
                    child: Text(
                      selectedRange == null
                          ? "Tarih aralığı seç"
                          : "${DateFormat('dd MMM yyyy').format(selectedRange!.start)} → ${DateFormat('dd MMM yyyy').format(selectedRange!.end)}",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Her gün kaç saat çalışmak istiyorsun?"),
                  Slider(
                    value: dailyHours,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: "${dailyHours.toInt()} saat",
                    onChanged: (val) => setState(() => dailyHours = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal"),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedRange != null) {
                      Navigator.pop(context);
                      _generateGeminiPlan(selectedRange!, dailyHours.toInt());
                    }
                  },
                  child: const Text("Planla"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Planlayıcı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: "Akıllı Planla",
            onPressed: () => _showGeminiPlanningDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((label) => Tab(text: label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildDailyView(),
          buildWeeklyView(),
          buildMonthlyView(),
        ],
      ),
    );
  }

  Widget buildDailyView() {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    final tasks = TaskService.dailyTasks[key] ?? [];
    final todo = tasks.where((t) => !t.isDone).toList();
    final done = tasks.where((t) => t.isDone).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1))),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'tr_TR').format(selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => setState(() => selectedDate = selectedDate.add(const Duration(days: 1))),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Yapılacaklar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ...todo.map((task) => ListTile(
                    leading: const Icon(Icons.radio_button_unchecked),
                    title: Text(task.title),
                    onTap: () => setState(() => task.isDone = true),
                  )),
              if (done.isNotEmpty) const Divider(),
              if (done.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Yapıldı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ...done.map((task) => ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
                    onTap: () => setState(() => task.isDone = false),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            onPressed: _showAddTaskDialog,
            icon: const Icon(Icons.add),
            label: const Text('Görev Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWeeklyView() {
    final firstDay = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final weekDays = List.generate(7, (i) => firstDay.add(Duration(days: i)));

    return Column(
      children: [
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDays.length,
            itemBuilder: (context, idx) {
              final day = weekDays[idx];
              final key = DateFormat('yyyy-MM-dd').format(day);
              final tasks = TaskService.dailyTasks[key] ?? [];
              final isSelected = DateFormat('yyyy-MM-dd').format(day) == DateFormat('yyyy-MM-dd').format(selectedDate);

              return GestureDetector(
                onTap: () => setState(() => selectedDate = day),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[800] : Colors.white54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE', 'tr_TR').format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),
        Expanded(child: buildDailyView()),
      ],
    );
  }

  Widget buildMonthlyView() {
    return Column(
      children: [
        TableCalendar(
          locale: 'tr_TR',
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: selectedDate,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selectedDay, focusedDay) => setState(() => selectedDate = selectedDay),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
        const Divider(),
        Expanded(child: buildDailyView()),
      ],
    );
  }

  void _generateGeminiPlan(DateTimeRange dateRange, int dailyHours) async {
    final allTasks = TaskService.dailyTasks.values.expand((tasks) => tasks).toList();
    final todoTitles = allTasks.where((task) => !task.isDone).map((task) => task.title).toList();

    if (todoTitles.isEmpty) {
      _showPlanSuggestionDialog("Hiç yapılacak görev bulunamadı. Lütfen önce görev ekleyin.");
      return;
    }

    final prompt = """
Kullanıcının yapılacaklar listesi:

${todoTitles.map((t) => "- $t").join("\n")}

Kullanıcı bu görevleri aşağıdaki tarih aralığında ve her gün belirli saat çalışarak tamamlamak istiyor:

- Başlangıç tarihi: ${DateFormat('yyyy-MM-dd').format(dateRange.start)}
- Bitiş tarihi: ${DateFormat('yyyy-MM-dd').format(dateRange.end)}
- Günlük çalışma süresi: $dailyHours saat

Lütfen her gün hangi görevleri çalışması gerektiğini ve yaklaşık hangi sırayla çalışacağını gösteren bir günlük plan öner.
Yanıt Türkçe ve açık anlaşılır biçimde olmalı.
""";

    final apiKey = 'AIzaSyAuQNZ2-9h8OURjs132E3OUljwPoczzpv8'; // ← Buraya doğrudan API key'i yaz

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final result = response.text ?? "Cevap alınamadı.";
      _showPlanSuggestionDialog(result);
    } catch (e) {
      _showPlanSuggestionDialog("Bir hata oluştu: $e");
    }
  }

  void _showPlanSuggestionDialog(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gemini Planlama Önerisi"),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }
}
