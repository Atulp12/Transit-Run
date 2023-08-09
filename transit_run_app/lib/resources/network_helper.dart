import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_route_service/open_route_service.dart';

class NetworkHelper {
  NetworkHelper(
      {required this.startLng,
      required this.startLat,
      required this.endLng,
      required this.endLat});

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey =
      '5b3ce3597851110001cf62485e994842ce6f4f86b7120d4689cf5d24';
  final String journeyMode =
      'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        '$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print(
        "$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

//   Future<Map<String, dynamic>> fetchMatrixInfo() async {
//   final apiKey = '5b3ce3597851110001cf62485e994842ce6f4f86b7120d4689cf5d24'; // Replace with your OpenRouteService API key
//   final apiUrl = 'https://api.openrouteservice.org/v2/matrix/driving-car';

//     final Uri uri = Uri.parse(apiUrl).replace(queryParameters: {
//     'api_key': apiKey,
//     'locations': [
//       '$startLng,$startLat',
//       '$endLng,$endLat',
//     ],
//   });
//   final response = await http.get(uri);

//   if (response.statusCode == 200) {
//     final decodedResponse = json.decode(response.body);
//     return decodedResponse;
//   } else {
//     throw Exception('Failed to fetch matrix information');
//   }
// }

  Future calculateDistanceAndTime() async {
    try {
      Map<String, dynamic> jsonData = await getData();

      // Access the distance and duration values from the response
      double distance =
          jsonData['features'][0]['properties']['summary']['distance'];
      double duration =
          jsonData['features'][0]['properties']['summary']['duration'];

      print('Distance: $distance meters');
      print('Duration: $duration seconds');
    } catch (e) {
      print('Error: $e');
    }
  }

// Future getMatrixData() async {
//   String apiUrl = 'https://api.openrouteservice.org/v2/matrix/driving-car';

//   // Replace 'YOUR_API_KEY' with your actual API key
//   String apiKey = 'Y5b3ce3597851110001cf62485e994842ce6f4f86b7120d4689cf5d24';


//   String requestBody = '{"locations":[[$startLat,$startLng],[$endLat,$endLng]],"metrics":["distance","duration"]}';

//   Map<String, String> headers = {
//     'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
//     'Content-Type': 'application/json',
//     'Authorization': apiKey,
//   };

//   var response = await http.post(Uri.parse(apiUrl), headers: headers, body: requestBody);

//   if (response.statusCode == 200) {
//      String data = response.body;
//       return jsonDecode(data);
//   } else {
//     print('Request failed with status: ${response.statusCode}');
//   }
// }

}