import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:example/screens/ClientUI/client_homepage/client_requestsummary.dart'; // Adjust import path for the next screen

class PackageBookingdetails extends StatefulWidget {
  final Map<String, bool> addOns; // Add-ons passed from the previous screen
  final int addOnCost; // Add-ons total cost

  const PackageBookingdetails({
    super.key,
    required this.addOns,
    required this.addOnCost,
  });

  @override
  PackageBookingPageState createState() => PackageBookingPageState();
}

class PackageBookingPageState extends State<PackageBookingdetails> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? selectedEventType;
  int _totalCost = 5000; // Initial package cost

  // Add-ons with prices
  Map<String, String> addOnPrices = {
    'Drone Shot': '₱3,000',
    '5 more pictures': '₱500',
    '1-minute video': '₱1,000',
    '2-minutes video': '₱2,000',
    '3-minutes video': '₱3,000',
  };

  @override
  void initState() {
    super.initState();
    // Set initial date in the text field
    _dateController.text = DateFormat('MM-dd-yyyy').format(selectedDate);
    _totalCost += widget.addOnCost; // Add add-on costs to total
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize time input in didChangeDependencies, where context is available
    _timeController.text = selectedTime.format(context);
  }

  // Function to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context); // Update time controller
      });
    }
  }

  // Function to display selected add-ons in the selection part
  List<TableRow> _buildSelectedAddOns() {
    List<TableRow> addOnRows = [];
    widget.addOns.forEach((key, value) {
      if (value) {
        addOnRows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(key),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(addOnPrices[key] ?? ''),
          ),
        ]));
      }
    });
    return addOnRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Higala Films | Booking',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/higala_logo.png', // Use your logo asset here
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Package 1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Do nothing for now
                          },
                          child: const Text(
                            'See more',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(), // Divider between Higala Films and Selection Summary
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Text(
              'Selection',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Box with inner shadow effect
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Package 1'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('₱5,000'),
                      ),
                    ]),
                    ..._buildSelectedAddOns(), // Reflect selected add-ons here
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₱$_totalCost',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Add functionality for voucher
              },
              child: const Text(
                '📄 Apply a Voucher',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Calendar and Form
            _buildBookingForm(),

            // Separate Container for "Next" button
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors
                  .grey.shade200, // Light background color for "Next" container
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestSummary(
                              selectedDate: selectedDate,
                              selectedTime: selectedTime,
                              address: _addressController.text,
                              eventType: selectedEventType ?? 'No Event',
                              totalCost: _totalCost,
                              selectedAddOns: widget.addOns,
                              addOnPrices: const {
                                'Drone Shot': '₱3,000',
                                '5 more pictures': '₱500',
                                '1-minute video': '₱1,000',
                                '2-minutes video': '₱2,000',
                                '3-minutes video': '₱3,000',
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662C2B),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 15),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Higala Films will need to approve your requested date, time, and address in order to confirm your appointment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF662C2B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF662C2B),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking | Higala Films',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Event', // This text will appear above the input field
                style: TextStyle(
                  color: Color.fromARGB(
                      255, 255, 255, 255), // Set the label text color
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors
                      .white, // Set the input field background color to white
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: Colors.black, // Set the dropdown text color to black
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Wedding',
                    child:
                        Text('Wedding', style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: 'Birthday',
                    child:
                        Text('Birthday', style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: 'Anniversary',
                    child: Text('Anniversary',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedEventType = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Date & Time',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate,
                  day); // Ensures only the selected day is highlighted
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: Colors.white), // Weekday labels color
              weekendStyle:
                  TextStyle(color: Colors.white), // Weekend labels color
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle:
                  const TextStyle(color: Colors.white), // Dates text color
              weekendTextStyle:
                  const TextStyle(color: Colors.white), // Weekend dates color
              selectedDecoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.2), // Subtle highlight for selected date
                shape: BoxShape.circle, // Keeps the selected date circular
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, // Text color for the selected date
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, // Hides the "2 weeks" format button
              titleCentered: true,
              titleTextStyle:
                  TextStyle(color: Colors.white), // Month title color
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white, // Chevron color
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white, // Chevron color
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                _dateController.text = DateFormat('MM-dd-yyyy').format(
                    selectedDay); // Updates the text field with the selected date
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date:',
                      style: TextStyle(
                        color: Colors.white, // You can change this if needed
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 0),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time:',
                      style: TextStyle(
                        color: Colors.white, // You can change this if needed
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 0),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Address:',
                style: TextStyle(
                  color: Colors.white, // You can change this if needed
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Lumbia, Cagayan de Oro, Philippines',
                  hintStyle: TextStyle(
                    color: Color(0xFF959595),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
