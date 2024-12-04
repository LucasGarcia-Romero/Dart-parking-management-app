import 'DatabaseHelper.dart';

class IncidentRepository {
  final DatabaseHelper _databaseHelper;

  IncidentRepository(this._databaseHelper);

  Future<List<Map<String, dynamic>>> getAllIncidents() async {
    return await _databaseHelper.getIncidents();
  }
  Future<List<Map<String, dynamic>>> getParkingIncidents(String parkingName) async {
    final List<Map<String, dynamic>> incidents = await _databaseHelper.getIncidents();
    return incidents.where((incident) => incident['parkingName'] == parkingName).toList();
  }

  Future<Map<String, dynamic>?> getParkingDetails(String parkingName) async {
    final List<Map<String, dynamic>> incidents = await _databaseHelper.getIncidents();
    final parkingDetails = incidents.firstWhere(
          (incident) => incident['parkingName'] == parkingName,
      orElse: () => {},
    );

    if (parkingDetails.isNotEmpty) {
      return parkingDetails;
    } else {
      return null;
    }
  }
}
