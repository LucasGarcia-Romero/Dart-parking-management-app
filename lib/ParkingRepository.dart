import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingRepository {
  static const String _url = "https://emel.city-platform.com/opendata/parking/lots";
  static const Map<String, String> _headers = {
    "accept": "application/json",
    "api_key": "93600bb4e7fee17750ae478c22182dda",
  };

  Future<List<dynamic>> fetchParkingLots() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
