import 'package:employee_data/ui/custom_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_data/bloc/employee_cubit.dart';

import '../utils/constants.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic>? employee;

  const AddEmployeeScreen({super.key, this.employee});

  @override
  AddEmployeeScreenState createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _role = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _name = widget.employee!['name'];
      _role = widget.employee!['role'];
      _startDate = DateTime.parse(widget.employee!['startDate']);
      _endDate = DateTime.parse(widget.employee!['endDate']);
    } else {
      _startDate = DateTime.now(); // Default to today's date
      _endDate = null; // "No date"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(29, 161, 242, 1),
        title: const Text('Add Employee Details',
            style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 16),
                initialValue: _name,
                decoration: InputDecoration(
                  hintText: employeeName,
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(148, 156, 158, 1),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showRoleSelection(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _role.isEmpty ? 'Select role' : _role,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              color: _role.isEmpty
                                  ? const Color.fromRGBO(148, 156, 158, 1)
                                  : const Color.fromRGBO(50, 50, 56, 1)),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomDateSelector(
                      date: _startDate,
                      onDateSelect: (selectedDate) {
                        setState(() {
                          _startDate = selectedDate;
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_right_alt,
                        size: 20, color: Color.fromRGBO(29, 161, 242, 1)),
                  ),
                  Expanded(
                    child: CustomDateSelector(
                      date: _endDate,
                      onDateSelect: (selectedDate) {
                        setState(() {
                          _endDate = selectedDate;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 1, // Thin line
            color: Colors.grey, // Light grey color
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 16),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    cancel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.employee == null) {
                        BlocProvider.of<EmployeeCubit>(context).addEmployee(
                          _name,
                          _role,
                          _startDate.toString(),
                          _endDate.toString(),
                        );
                      } else {
                        BlocProvider.of<EmployeeCubit>(context).updateEmployee(
                          widget.employee!['id'],
                          _name,
                          _role,
                          _startDate.toString(),
                          _endDate.toString(),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    save,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRoleSelection(BuildContext context) async {
    final selectedRole = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles.map((role) {
              return ListTile(
                title: Text(role),
                onTap: () {
                  Navigator.pop(context, role);
                },
              );
            }).toList(),
          ),
        );
      },
    );
    if (selectedRole != null) {
      setState(() {
        _role = selectedRole;
      });
    }
  }
}
