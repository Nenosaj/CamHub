import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PayMongoService {
  static const String _apiKey =
      "sk_test_4VAEtfCEfXXyU2iqEM73gjtj"; // Replace with your PayMongo API key
  static const String _baseUrl = "https://api.paymongo.com/v1";
  static const String _paymentLinksUrl = "$_baseUrl/links";

  /// Creates a payment link with the given amount and description (package name).
  /// Returns the payment link URL if successful or `null` if there’s an error.
  static Future<String?> createPaymentLink({
    required double amount,
    required String description,
    required String remarks,
  }) async {
    final url = Uri.parse(_paymentLinksUrl);

    // Convert amount to the smallest currency unit (e.g., cents for PHP)
    final int amountInCents = (amount * 100).toInt();

    // Build the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode(_apiKey))}',
    };

    // Build the request body
    final body = jsonEncode({
      'data': {
        'attributes': {
          'amount': amountInCents,
          'description': description,
          'remark': remarks,
        }
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final paymentLink = responseData['data']['attributes']['checkout_url'];
        return paymentLink;
      } else {
        debugPrint('Failed to create payment link: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating payment link: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchLinkByReferenceNumber(
      String referenceNumber) async {
    try {
      final url = '$_baseUrl/links?reference_number=$referenceNumber';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode("$_apiKey:"))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> links = data['data'];

        if (links.isNotEmpty) {
          // Return the first matching link's data
          return {
            'id': links.first['id'],
            'url': links.first['attributes']['checkout_url'],
            'reference_number': links.first['attributes']['reference_number'],
            'status': links.first['attributes']['status'],
          };
        } else {
          return null; // No matching links found
        }
      } else {
        print(
            'Failed to fetch payment link. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching payment link: $e');
      return null;
    }
  }
}
