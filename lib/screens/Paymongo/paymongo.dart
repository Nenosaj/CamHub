import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PayMongoService {
  static const String _apiKey =
      "sk_test_4VAEtfCEfXXyU2iqEM73gjtj"; // Replace with your PayMongo API key
  static const String _baseUrl = "https://api.paymongo.com/v1";
  static const String _paymentLinksUrl = "$_baseUrl/links";
  static const String _paymentIntentsUrl = "$_baseUrl/payment_intents";

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

  /// Verifies the payment status using the payment intent ID.
  /// Returns `true` if the payment is successful, otherwise `false`.
  static Future<bool> verifyPaymentStatus(String paymentIntentId) async {
    final url = Uri.parse('$_paymentIntentsUrl/$paymentIntentId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode(_apiKey))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final paymentStatus = responseData['data']['attributes']['status'];
        return paymentStatus == 'succeeded'; // Return true if payment succeeded
      } else {
        debugPrint('Failed to verify payment status: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error verifying payment status: $e');
      return false;
    }
  }

  Future<void> retrievePaymentLink(String linkId) async {
    final String apiKey = _apiKey; // Replace with your actual PayMongo API Key

    final String url =
        'https://api.paymongo.com/v1/payment_links/$linkId'; // Endpoint to retrieve a link

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$apiKey:')),
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String remark =
            data['data']['metadata']?['remark'] ?? 'No remark available';

        print('Remark: $remark'); // Print or use the remark as needed

        // Optionally, print the full response if you need more details
        print('Full Response: ${data['data']}');
      } else {
        print('Failed to retrieve payment link: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching payment link: $e');
    }
  }
}
