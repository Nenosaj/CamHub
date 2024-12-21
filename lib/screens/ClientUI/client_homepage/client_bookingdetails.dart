import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/ClientUI/client_homepage/client_requestsummary.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class PackageBookingdetails extends StatefulWidget {
  final String creativeuid;
  final String uuid;
  final String packageName;
  final String packagePrice;
  final Map<String, bool> addOns;
  final Map<String, String> addOnPrices;
  final int totalAddOnCost;

  const PackageBookingdetails({
    super.key,
    required this.creativeuid,
    required this.uuid,
    required this.packageName,
    required this.packagePrice,
    required this.addOns,
    required this.addOnPrices,
    required this.totalAddOnCost,
  });

  @override
  State<PackageBookingdetails> createState() => _PackageBookingdetailsState();
}

class _PackageBookingdetailsState extends State<PackageBookingdetails> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Function to calculate total cost
  int _calculateTotalCost() {
    int packageCost =
        int.parse(widget.packagePrice.replaceAll(RegExp(r'[^\d]'), ''));
    return packageCost + widget.totalAddOnCost;
  }

  // Function to display time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  // Function to display date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          'Booking',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPackageInfo(),
            const SizedBox(height: 20),
            _buildCalendarContainer(),
            const SizedBox(height: 20),
            _buildDateTimeInputContainer(),
            const SizedBox(height: 20),
            _buildAddressInput(),
            const SizedBox(height: 20),
            const Text(
              'Selected Add-ons:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildAddOns(),
            const SizedBox(height: 20),
            _buildTotalCost(),
            const SizedBox(height: 20),
            _buildConfirmButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Package Name: ${widget.packageName}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Price: ${widget.packagePrice}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          'Package ID: ${widget.uuid}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCalendarContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF662C2B), // Container color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: selectedDate ?? DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
            _dateController.text = DateFormat('MM-dd-yyyy').format(selectedDay);
          });
        },
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white), // White text
          weekendTextStyle: const TextStyle(color: Colors.white),
          outsideDaysVisible: false, // Hide outside days
          selectedDecoration: BoxDecoration(
            color: Colors.white, // Highlighted selected day
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Color(0xFF662C2B), // Text color of the selected day
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: const TextStyle(
            color: Colors.white, // White month and year
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Colors.white, // White arrows
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white, // White arrows
          ),
          formatButtonVisible: false, // Hide the format toggle button
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: const TextStyle(color: Colors.white), // White weekdays
          weekendStyle: const TextStyle(color: Colors.white), // White weekends
        ),
      ),
    );
  }

  Widget _buildDateTimeInputContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF662C2B), // Container color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  style:
                      const TextStyle(color: Color(0xFF662C2B)), // White text
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle:
                        TextStyle(color: Color(0xFF662C2B)), // White label
                    filled: true,
                    fillColor: Color.fromARGB(
                        255, 253, 253, 253), // Same color as container
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF662C2B)), // White border
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _timeController,
                  style:
                      const TextStyle(color: Color(0xFF662C2B)), // White text
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    labelStyle:
                        TextStyle(color: Color(0xFF662C2B)), // White label
                    filled: true,
                    fillColor: Color.fromARGB(
                        255, 255, 255, 255), // Same color as container
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF662C2B)), // White border
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Address:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _addressController,
          style:
              const TextStyle(color: Colors.black), // Black text for contrast
          decoration: const InputDecoration(
            hintText: 'Enter your full address',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF662C2B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOns() {
    final selectedAddOns = widget.addOns.entries.where((e) => e.value).toList();

    if (selectedAddOns.isEmpty) {
      return const Text(
        'No add-ons selected.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Column(
      children: selectedAddOns.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                widget.addOnPrices[entry.key] ?? '₱0',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalCost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Cost:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '₱${_calculateTotalCost()}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (selectedDate == null || _addressController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a date and enter your address.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          Map<String, bool> selectedAddOns = widget.addOns
            ..removeWhere((key, value) => !value);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestSummary(
                creativeuid: widget.creativeuid,
                uuid: widget.uuid,
                selectedDate: selectedDate!,
                selectedTime: selectedTime!,
                address: _addressController.text.trim(),
                selectedAddOns: selectedAddOns,
                addOnPrices: widget.addOnPrices,
                totalCost: _calculateTotalCost(),
                eventType: widget.packageName,
                packageName: widget.packageName,
                packagePrice: widget.packagePrice,
              ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF662C2B),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Center(
        child: Text(
          'Confirm Booking',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
