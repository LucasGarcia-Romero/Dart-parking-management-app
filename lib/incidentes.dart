import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'DatabaseHelper.dart';

class Incidentes extends StatefulWidget {
  const Incidentes({Key? key}) : super(key: key);

  @override
  _IncidentesState createState() => _IncidentesState();
}

class _IncidentesState extends State<Incidentes> {
  String? _selectedParking;
  int _dangerLevel = 1;
  DateTime _date = DateTime.now();
  String _comments = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _parkingNames = [];

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_date);
    fetchData();
  }

  // Using the parking data on emel
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse("https://emel.city-platform.com/opendata/parking/lots"),
      headers: {
        "accept": "application/json",
        "api_key": "93600bb4e7fee17750ae478c22182dda",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        parkingLots = jsonData ?? [];
        _parkingNames = parkingLots.map<String>((parkingLot) => parkingLot['nome']).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<dynamic> parkingLots = [];

  // New incident - incident form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedParking,
                  hint: const Text('Select a parking'),
                  items: _parkingNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedParking = newValue;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Danger Level (1-10)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final level = int.tryParse(value);
                    if (level != null && level >= 1 && level <= 10) {
                      setState(() {
                        _dangerLevel = level;
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Comments'),
                  onChanged: (value) {
                    _comments = value;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedParking != null &&
                        _dangerLevel >= 1 && _dangerLevel <= 10 &&
                        _comments.isNotEmpty) {
                      await _saveIncident();
                      _showConfirmationSnackBar(context, 'Incident reported successfully!');
                      print('Selected Parking: $_selectedParking');
                      print('Danger Level: $_dangerLevel');
                      print('Date: $_date');
                      print('Comments: $_comments');
                    } else {
                      _showErrorSnackBar(context, 'Please fill in all fields.');
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Save new incident on db
  Future<void> _saveIncident() async {
    Map<String, dynamic> incident = {
      'parkingName': _selectedParking,
      'dangerLevel': _dangerLevel,
      'date': DateFormat('yyyy-MM-dd').format(_date),
      'comments': _comments,
    };
    await context.read<DatabaseHelper>().insertIncident(incident);
  }

  // Select date - date form
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_date);
      });
    }
  }

  //Show error when fields aren't completed
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Showo confirmation when everything ok
  void _showConfirmationSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
