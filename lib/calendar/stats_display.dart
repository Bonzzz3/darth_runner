import 'package:darth_runner/database/rundata.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StatsDisplay extends StatefulWidget {
  const StatsDisplay({super.key});

  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var runDataBox = Hive.box<Rundata>('runDataBox');
  double _dailyTarget = 5.0; // Example daily target in kilometers

  double _getCumulativeDistanceForDate(DateTime date) {
    double totalDistanceCalendar = 0.0;
    for (var runData in runDataBox.values) {
      if (runData.hiveDate.year == date.year &&
          runData.hiveDate.month == date.month &&
          runData.hiveDate.day == date.day) {
        totalDistanceCalendar += runData.hiveDistance;
      }
    }
    return totalDistanceCalendar;
  }

  Color _getCellColour(double distance) {
    const double maxDist = 10.0;
    double opacity = (distance / maxDist).clamp(0.0, 0.5);
    return const Color.fromARGB(255, 255, 23, 6).withOpacity(opacity);
  }

  BoxDecoration _getCellDecoration(double distance) {
    return BoxDecoration(
      color: _getCellColour(distance),
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    double _selectedDayDistance = _selectedDay != null
        ? _getCumulativeDistanceForDate(_selectedDay!)
        : 0.0;
    int _numRuns = _selectedDay != null
        ? runDataBox.values
            .where((runData) =>
                runData.hiveDate.year == _selectedDay!.year &&
                runData.hiveDate.month == _selectedDay!.month &&
                runData.hiveDate.day == _selectedDay!.day)
            .length
        : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "YOUR STATS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 25,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SlidingUpPanel(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24.0)),
            panel: _buildPanel(_selectedDayDistance, _numRuns),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.black),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: const TextStyle(color: Colors.white),
                      formatButtonTextStyle:
                          const TextStyle(color: Colors.black),
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        double distance = _getCumulativeDistanceForDate(date);
                        return Container(
                          decoration: _getCellDecoration(distance),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(double distance, int numRuns) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCircularIndicator(distance),
          const SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Day's Summary",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Total Distance: ${distance.toStringAsFixed(2)} km",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Number of Runs: $numRuns",
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(double distance) {
    double progress = (distance / _dailyTarget).clamp(0.0, 1.0);
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12.0,
                backgroundColor: Colors.grey[300],
              ),
            ),
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        const Text(
          "Daily Target",
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
