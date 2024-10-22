import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Creative {
  final String uid; // Add uid field
  final String businessEmail; // Email from FirebaseAuth
  final String businessName; // Business Name
  final String unitNumber;
  final String street;
  final String village;
  final String barangay;
  final String city;
  final String province;
  final String businessPhoneNumber;
  final String? profilePictureUrl; // Add profile picture URL
  final double rating; // Rating for the creative
  final List<Map<String, dynamic>> reviews; // List of reviews for the creative

  // Constructor
  Creative({
    required this.uid, // Include uid in the constructor
    required this.businessEmail, // Fetch this from FirebaseAuth
    required this.businessName,
    required this.unitNumber,
    required this.street,
    required this.village,
    required this.barangay,
    required this.city,
    required this.province,
    required this.businessPhoneNumber,
    this.profilePictureUrl, // Optional profile picture URL
    required this.rating, // Rating
    required this.reviews, // Reviews for the creative
  });

  // Factory method to create a Creative object from Firestore data
  factory Creative.fromFirestore(DocumentSnapshot doc, String businessEmail) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Creative(
      uid: doc.id, // Set the uid from the document ID
      businessEmail: businessEmail, // Set business email from FirebaseAuth
      businessName: data['businessName'] ?? '',
      unitNumber: data['unitNumber'] ?? '',
      street: data['street'] ?? '',
      village: data['village'] ?? '',
      barangay: data['barangay'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      businessPhoneNumber: data['businessPhoneNumber'] ?? '',
      profilePictureUrl: data['profilePicture'], // Ensure case matches exactly
      rating: (data['rating']?.toDouble()) ?? 0.0, // Parse rating
      reviews: (data['reviews'] as List<dynamic>?)
              ?.map((review) => Map<String, dynamic>.from(review))
              .toList() ??
          [], // Handle reviews, if available
    );
  }

  // Convert Creative object to JSON (for updating Firestore or other purposes)
  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'unitNumber': unitNumber,
      'street': street,
      'village': village,
      'barangay': barangay,
      'city': city,
      'province': province,
      'businessPhoneNumber': businessPhoneNumber,
      'profilePictureUrl': profilePictureUrl, // Include profile picture URL
      'rating': rating, // Include rating
      'reviews': reviews, // Include reviews
    };
  }

  // Static method to fetch Creative data for the currently signed-in user
  static Future<Creative?> fetchCurrentCreative() async {
    try {
      // Get the currently signed-in user's uid and email
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        String businessEmail = user.email!; // Get email from FirebaseAuth

        // Fetch the creative's data from Firestore using the uid
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('creatives').doc(uid).get();

        if (doc.exists) {
          return Creative.fromFirestore(doc, businessEmail); // Pass business email to the constructor
        } else {
          print('No creative data found for uid: $uid');
          return null;
        }
      } else {
        print('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      print('Error fetching creative data: $e');
      return null;
    }
  }
}
