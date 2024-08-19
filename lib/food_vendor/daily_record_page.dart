import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class DailyRecordPage extends StatefulWidget {
  @override
  _DailyRecordPageState createState() => _DailyRecordPageState();
}

class _DailyRecordPageState extends State<DailyRecordPage> {
  DateTime? _selectedDate;
  int _totalScans = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Default to today's date
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020), // Adjust as needed
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Scan Records'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_distributions')
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)))
            .where('timestamp', isLessThan: Timestamp.fromDate(DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day + 1)))
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data?.docs ?? [];
          _totalScans = records.length;

          if (records.isEmpty) {
            return Center(child: Text('No records found.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Scans: $_totalScans',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    var record = records[index];
                    var userName = record['name'] ?? 'N/A';
                    var timestamp = record['timestamp'] as Timestamp;
                    var dateTime = timestamp.toDate();
                    var formattedTime = DateFormat('hh:mm a').format(dateTime);

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('Scan Time: $formattedTime'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
