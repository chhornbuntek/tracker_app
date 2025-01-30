import 'dart:convert';

import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tracker_app/auth/login.dart';
import 'package:tracker_app/service/api_server.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Server _server = Server();
  bool isTodaySelected = true;
  final _storage = const FlutterSecureStorage();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _notedController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> categories = [
    {"name": "Groceries", "icon": Icons.shopping_cart},
    {"name": "Transportation", "icon": Icons.directions_car},
    {"name": "Utilities", "icon": Icons.lightbulb},
    {"name": "Entertainment", "icon": Icons.movie},
    {"name": "Health", "icon": Icons.health_and_safety},
    {"name": "Education", "icon": Icons.school},
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Others", "icon": Icons.more_horiz},
  ];
  IconData? _categoryIcon = Icons.category;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1ace99),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close),
                              ),
                              const Text(
                                'Add Expense',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff1ace99),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'USD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _amountController,
                                    decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      border: InputBorder.none,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  builder: (context) => FractionallySizedBox(
                                    heightFactor: 0.5,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: categories.map((category) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                _categoryController.text =
                                                    category["name"];
                                                _categoryIcon =
                                                    category["icon"];
                                              });
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(category["icon"]),
                                            title: Text(category["name"]),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1ace99),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      _categoryIcon ?? Icons.category,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _categoryController,
                                      decoration: const InputDecoration(
                                        labelText: 'Category',
                                        border: InputBorder.none,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        suffixIcon: Icon(Icons
                                            .keyboard_arrow_right_outlined),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: InkWell(
                              onTap: () {
                                BottomPicker.date(
                                  pickerTitle: const Text(
                                    'Pick Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xff1ace99),
                                    ),
                                  ),
                                  dateOrder: DatePickerDateOrder.dmy,
                                  initialDateTime: _selectedDate,
                                  maxDateTime: DateTime.now(),
                                  minDateTime: DateTime(2022),
                                  pickerTextStyle: const TextStyle(
                                    color: Color(0xff1ace99),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  onChange: (index) {
                                    print(index);
                                  },
                                  onSubmit: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                      _dateController.text = date
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0];
                                    });
                                    print(date);
                                  },
                                  bottomPickerTheme: BottomPickerTheme.blue,
                                ).show(context);
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1ace99),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _dateController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Date'),
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff1ace99),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.note,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _notedController,
                                    decoration: const InputDecoration(
                                      labelText: 'Noted',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await addExpense();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1ace99),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Add Expense',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        backgroundColor: const Color(0xff1ace99),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        desc: 'Do you want to sign out?',
                        btnCancelOnPress: () {
                          Get.back();
                        },
                        btnOkOnPress: () async {
                          logout(context);
                        },
                        btnOkColor: Colors.red,
                        btnCancelColor: Colors.black,
                        buttonsTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ).show();
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.white,
                    )),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/tek.jpg'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35),
            child: Text(
              'My Budget',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35),
            child: Text(
              '\$5,438.50',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 630,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isTodaySelected = true;
                          });
                        },
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 175,
                          height: 50,
                          decoration: BoxDecoration(
                              color: isTodaySelected
                                  ? const Color(0xff1ace99)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: isTodaySelected
                                    ? Colors.white
                                    : const Color(0xff1ace99),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isTodaySelected = false;
                          });
                        },
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 175,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isTodaySelected
                                ? Colors.transparent
                                : const Color(0xff1ace99),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Month',
                              style: TextStyle(
                                color: isTodaySelected
                                    ? const Color(0xff1ace99)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: fetchExpenses(
                        filter: isTodaySelected ? 'today' : 'month'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!['expenses'].isEmpty) {
                        return const Center(child: Text('No expenses found'));
                      }

                      List<Map<String, dynamic>> expenses =
                          snapshot.data!['expenses'];
                      String totalAmount = snapshot.data!['total'];

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isTodaySelected
                                    ? DateFormat('dd MMM yyyy')
                                        .format(DateTime.now())
                                    : 'This Month',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total: \$${totalAmount}',
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 468,
                            child: SingleChildScrollView(
                              child: Column(
                                children: expenses.map((expense) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffdfd1d1),
                                              ),
                                              child: const Icon(
                                                Icons.star,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              expense['category'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '\$${expense['amount']}',
                                          style: const TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _server.checkAutoLogin(() {
      Get.off(() => const HomeScreen());
    }, () {
      Get.offAll(() => const LoginScreen());
    });
  }

  Future<Map<String, dynamic>> fetchExpenses({required String filter}) async {
    final accessToken = await _storage.read(key: 'accessToken');
    const url = 'http://192.168.0.65:3000/api/get_expenses';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Map<String, dynamic>> expenses = data
          .map((item) => {
                'category': item['CATEGORY']?.toString() ?? 'Unknown',
                'amount':
                    double.tryParse(item['AMOUNT']?.toString() ?? '0') ?? 0.0,
                'date': item['DATE']?.toString() ?? 'No Date',
              })
          .toList();

      DateTime now = DateTime.now();
      String todayDate = DateFormat('yyyy-MM-dd').format(now);
      String currentMonth = DateFormat('yyyy-MM').format(now);

      // Apply filtering
      if (filter == 'today') {
        expenses = expenses
            .where(
                (expense) => expense['date'].toString().startsWith(todayDate))
            .toList();
      } else if (filter == 'month') {
        expenses = expenses
            .where((expense) =>
                expense['date'].toString().startsWith(currentMonth))
            .toList();
      }

      double totalAmount =
          expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));

      return {
        'expenses': expenses,
        'total': totalAmount.toStringAsFixed(2),
      };
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  void logout(BuildContext context) async {
    try {
      await _server.logout();
      Get.offAll(() => const LoginScreen());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $error')),
      );
    }
  }

  Future<void> addExpense() async {
    final body = {
      'amount': _amountController.text,
      'category': _categoryController.text,
      'date': _dateController.text,
      'notes': _notedController.text,
    };

    try {
      await _server.addExpense(body);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success!',
        desc: 'Expense added successfully!',
        btnOkText: 'Okay',
        btnOkColor: const Color(0xFF0D6EFD),
        btnOkOnPress: () {
          Future.delayed(const Duration(milliseconds: 100), () {
            FocusScope.of(context).unfocus();
            _clearFields();
          });
          Get.offAll(() => const HomeScreen());
        },
      ).show();
    } catch (error) {
      print('Error: $error');
    }
  }

  void _clearFields() {
    _amountController.clear();
    _categoryController.clear();
    _dateController.clear();
    _notedController.clear();
  }
}
