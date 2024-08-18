import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DailyRecordPage extends StatefulWidget {
  final String? scanResult;

  DailyRecordPage({this.scanResult});

  @override
  _DailyRecordPageState createState() => _DailyRecordPageState();
}

class _DailyRecordPageState extends State<DailyRecordPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _loading = true;
  List<Map<String, dynamic>> _foodRecords = [];
  int _totalScans = 0; // Variable to store total number of scans

  @override
  void initState() {
    super.initState();
    _fetchDailyRecords();
  }

  Future<void> _fetchDailyRecords() async {
    setState(() {
      _loading = true;
    });

    try {
      print("Fetching records for date: $_selectedDate");
      final querySnapshot = await _firestore
          .collection('food_distributions')
          .where('date', isEqualTo: _selectedDate)
          .orderBy('timestamp', descending: true)
          .get();

      print("Number of records fetched: ${querySnapshot.docs.length}");

      setState(() {
        _foodRecords = querySnapshot.docs
            .map((doc) => {
          'user_id': doc['user_id'],
          'timestamp': (doc['timestamp'] as Timestamp).toDate(),
        })
            .toList();
        _totalScans = _foodRecords.length; // Update total number of scans
        _loading = false;
      });

      if (widget.scanResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan result: ${widget.scanResult}')),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching records: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch records: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_selectedDate),
      firstDate: DateTime(2023, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.parse(_selectedDate)) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        _fetchDailyRecords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Food Distribution Records'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Scans: $_totalScans',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _foodRecords.isEmpty
              ? Expanded(
            child: Center(
              child: Text(
                'No records found for $_selectedDate',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: _foodRecords.length,
              itemBuilder: (context, index) {
                final record = _foodRecords[index];
                return ListTile(
                  title: Text('User ID: ${record['user_id']}'),
                  subtitle: Text(
                      'Time: ${DateFormat('hh:mm a').format(record['timestamp'])}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
