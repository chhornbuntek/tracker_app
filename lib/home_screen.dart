import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTodaySelected = true;

  final List<String> categories = [
    "Groceries",
    "Transportation",
    "Utilities",
    "Entertainment",
    "Health",
    "Education",
    "Food",
    "Others"
  ];
  String? selectedCategory;
  final TextEditingController categoryController =
      TextEditingController(); // Controller for category field

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
                                        child: _buildCategoryList()),
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
                                    child: const Icon(
                                      Icons.category,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: categoryController,
                                      decoration: const InputDecoration(
                                          labelText: 'Category',
                                          border: InputBorder.none,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          suffixIcon: const Icon(Icons
                                              .keyboard_arrow_right_outlined)),
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                    )),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/bby.jpg'),
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
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35),
            child: Text(
              '\$5400,50',
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
            height: 624,
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
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: isTodaySelected
                                    ? Colors.white
                                    : Colors.black,
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
                                : Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Month',
                              style: TextStyle(
                                color: isTodaySelected
                                    ? Colors.black
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
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '18 May 2025',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 468,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
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
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(Icons.lightbulb),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        'Electricity',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '120.00',
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
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
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(Icons.lightbulb),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        'Electricity',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '120.00',
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: List.generate(categories.length, (index) {
                return ListTile(
                  leading: const Icon(Icons.label, color: Colors.grey),
                  title: Text(
                    categories[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                      categoryController.text = selectedCategory ?? '';
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
