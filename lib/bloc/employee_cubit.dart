import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeCubit extends Cubit<List<Map<String, dynamic>>> {
  EmployeeCubit() : super([]) {
    loadEmployees();
  }

  void loadEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeData = prefs.getString('employees');
    if (employeeData != null) {
      emit(List<Map<String, dynamic>>.from(json.decode(employeeData)));
    } else {
      emit([]);
    }
  }

  void addEmployee(
      String name, String role, String startDate, String endDate) async {
    final employee = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
    };
    final updatedList = [...state, employee];
    emit(updatedList);
    await _saveEmployees(updatedList);
  }

  void updateEmployee(int id, String name, String role, String startDate,
      String endDate) async {
    final updatedList = state.map((employee) {
      if (employee['id'] == id) {
        return {
          'id': id,
          'name': name,
          'role': role,
          'startDate': startDate,
          'endDate': endDate,
        };
      }
      return employee;
    }).toList();
    emit(updatedList);
    await _saveEmployees(updatedList);
  }

  void deleteEmployee(int id) async {
    final updatedList =
        state.where((employee) => employee['id'] != id).toList();
    emit(updatedList);
    await _saveEmployees(updatedList);
  }

  Future<void> _saveEmployees(List<Map<String, dynamic>> employees) async {
    final prefs = await SharedPreferences.getInstance();
    final employeeData = json.encode(employees);
    prefs.setString('employees', employeeData);
  }
}
