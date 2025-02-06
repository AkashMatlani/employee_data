import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class CustomDateSelector extends StatefulWidget {
  final DateTime? date;
  final Function(DateTime?) onDateSelect;

  const CustomDateSelector({super.key, this.date, required this.onDateSelect});

  @override
  CustomDateSelectorState createState() => CustomDateSelectorState();
}

class CustomDateSelectorState extends State<CustomDateSelector> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                    _selectedDate != null
                        ? (_selectedDate!.year == DateTime.now().year &&
                                _selectedDate!.month == DateTime.now().month &&
                                _selectedDate!.day == DateTime.now().day
                            ? today
                            : DateFormat('d MMM yyyy').format(_selectedDate!))
                        : noDate,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStyledButton(
                            today, DateTime.now(), setStateDialog),
                        _buildStyledButton(nextMonday,
                            _getNextWeekday(DateTime.monday), setStateDialog),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStyledButton(nextTuesday,
                            _getNextWeekday(DateTime.tuesday), setStateDialog),
                        _buildStyledButton(
                            afterOneWeek,
                            DateTime.now().add(const Duration(days: 7)),
                            setStateDialog),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: CalendarDatePicker(
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setStateDialog(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month,
                                  color: Colors.blue),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  _selectedDate == null
                                      ? noDateSelected
                                      : DateFormat('d MMM yyyy')
                                          .format(_selectedDate!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(50, 50, 56, 1),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Prevents text overflow
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Cancel and go back
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                cancel,
                                style: TextStyle(
                                    color: Color.fromRGBO(29, 161, 242, 1)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // Reduce width for spacing
                            ElevatedButton(
                              onPressed: () {
                                if (_selectedDate != null) {
                                  widget.onDateSelect(_selectedDate!);
                                }
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(
                                save,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStyledButton(
      String label, DateTime date, Function setStateDialog) {
    bool isSelected = _selectedDate != null &&
        _selectedDate!.year == date.year &&
        _selectedDate!.month == date.month &&
        _selectedDate!.day == date.day;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDate = date;
        });
        setStateDialog(() {
          _selectedDate = date;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.blue.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  DateTime _getNextWeekday(int weekday) {
    DateTime now = DateTime.now();
    int daysUntilNext = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilNext == 0 ? 7 : daysUntilNext));
  }
}
