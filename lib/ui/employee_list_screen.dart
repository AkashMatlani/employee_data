import 'package:employee_data/bloc/employee_cubit.dart';
import 'package:employee_data/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'add_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(29, 161, 242, 1),
        title: const Text(employeeList,
            style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
      ),
      body: BlocBuilder<EmployeeCubit, List<Map<String, dynamic>>>(
        builder: (context, employeeList) {
          if (employeeList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/no_employee_found.png', width: 150),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  color: const Color(0XFFf2f2f2),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      currentEmployees,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromRGBO(29, 161, 242, 1),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: employeeList.length,
                        itemBuilder: (context, index) {
                          final employee = employeeList[index];
                          return Dismissible(
                            key: Key(employee['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              BlocProvider.of<EmployeeCubit>(context)
                                  .deleteEmployee(employee['id']);
                            },
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddEmployeeScreen(employee: employee),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                // Adjust padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee['name'],
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromRGBO(50, 50, 56, 1),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      employee['role'],
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        color: Color.fromRGBO(148, 156, 158, 1),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "From ${DateFormat('d MMM yyyy').format(DateTime.parse(employee['startDate']))}",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        color: Color.fromRGBO(148, 156, 158, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            // Add padding to match design
                            child: Divider(
                              thickness: 1,
                              color: Color.fromRGBO(230, 230, 230,
                                  1), // Adjust color to match screenshot
                            ),
                          );
                        }))
              ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(29, 161, 242, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
