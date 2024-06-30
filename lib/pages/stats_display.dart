import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatsDisplay extends StatefulWidget {
  const StatsDisplay({super.key});

  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          "YOUR STATS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        //centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 25,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(children: [
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
                    defaultTextStyle: TextStyle(
                        color: Colors.white), // Set text color to white
                    weekendTextStyle: TextStyle(
                        color: Colors.white), // Set weekend text color to white
                    todayTextStyle: TextStyle(
                        color: Colors
                            .black), // Set today text color to black for contrast
                    todayDecoration: BoxDecoration(
                      color: Colors
                          .white, // Set today background color to white for contrast
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                        color: Colors
                            .black), // Set selected day text color to black for contrast
                    selectedDecoration: BoxDecoration(
                      color: Colors
                          .white, // Set selected day background color to white for contrast
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: const TextStyle(
                        color: Colors.white), // Set header text color to white
                    formatButtonTextStyle: const TextStyle(
                        color: Colors
                            .black), // Set format button text color to black for contrast
                    formatButtonDecoration: BoxDecoration(
                      color: Colors
                          .white, // Set format button background color to white for contrast
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color:
                          Colors.white, // Set left chevron icon color to white
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color:
                          Colors.white, // Set right chevron icon color to white
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
