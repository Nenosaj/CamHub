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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
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
            // Package Info Section
            _buildPackageInfo(),
            const SizedBox(height: 20),

            // Date Selection
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildDateTimeFields(),
            const SizedBox(height: 20),

            // Address Input
            _buildAddressInput(),
            const SizedBox(height: 20),

            // Add-ons Section
            const Text(
              'Selected Add-ons:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildAddOns(),
            const SizedBox(height: 20),

            // Total Cost Section
            _buildTotalCost(),
            const SizedBox(height: 20),

            // Confirm Booking Button
            _buildConfirmButton(context),

            // Add bottom padding for better scrolling experience
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget for Package Information
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

  // Widget for Date Selection
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: selectedDate ?? DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
          _dateController.text = DateFormat('MM-dd-yyyy').format(selectedDay);
        });
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.black),
        selectedDecoration: BoxDecoration(
          color: const Color(0xFF662C2B),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget for Date-Time Picker Fields
  Widget _buildDateTimeFields() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Time',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget for Address Input
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

  // Widget for displaying selected Add-ons
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

  // Widget for displaying Total Cost
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

  // Widget for Confirm Booking Button
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
          // Prepare selected add-ons
          Map<String, bool> selectedAddOns = widget.addOns
            ..removeWhere((key, value) => !value);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestSummary(
                creativeuid: widget.creativeuid,
                uuid: widget.uuid,
                selectedDate: selectedDate!, // Pass selected date
                selectedTime: selectedTime!, // Placeholder for current time
                address:
                    _addressController.text.trim(), // Pass user-entered address
                selectedAddOns: selectedAddOns, // Pass selected add-ons
                addOnPrices: widget.addOnPrices, // Pass add-on prices
                totalCost: _calculateTotalCost(), // Pass total cost
                eventType: widget.packageName, // Use package name as event type
                packageName: widget.packageName, // Pass package name
                packagePrice: widget.packagePrice, // Pass package price
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
