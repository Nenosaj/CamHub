import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests

// Function to fetch address suggestions from Geoapify API
Future<List<String>> fetchAddressSuggestions(String query) async {
  if (query.isEmpty) return []; // Return empty list if query is empty

  const String apiKey = '64044b7ab3664061aa730dc45c26ae3c'; // Geoapify API Key
  final url = Uri.parse(
      'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&filter=countrycode:PH&apiKey=$apiKey');

  try {
    final response = await http.get(url);

    print('API Response: ${response.body}'); // Debugging the API response

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Parse the JSON response
      final features = data['features'] as List;

      // Extract and return formatted address suggestions
      return features
          .map((feature) => feature['properties']['formatted'] as String)
          .toList();
    } else {
      throw Exception(
          'Failed to load suggestions. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching address suggestions: $e');
    return [];
  }
}
