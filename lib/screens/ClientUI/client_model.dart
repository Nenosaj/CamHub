import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String uid; // Add uid field
  final String email; // Email from FirebaseAuth
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthday;
  final String unitNumber;
  final String street;
  final String village;
  final String barangay;
  final String city;
  final String province;
  final String phoneNumber;
  final String? profilePictureUrl; // Add profile picture URL

  // Constructor
  Client({
    required this.uid, // Include uid in the constructor
    required this.email, // Fetch this from FirebaseAuth
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthday,
    required this.unitNumber,
    required this.street,
    required this.village,
    required this.barangay,
    required this.city,
    required this.province,
    required this.phoneNumber,
    this.profilePictureUrl, // Optional profile picture URL
  });
  
  // Factory method to create a Client object from Firestore data
  factory Client.fromFirestore(DocumentSnapshot doc, String email) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Client(
      uid: doc.id, // Set the uid from the document ID
      email: email, // Set email from FirebaseAuth
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'] ?? '',
      lastName: data['lastName'] ?? '',
      birthday: data['birthday'] ?? '',
      unitNumber: data['unitNumber'] ?? '',
      street: data['street'] ?? '',
      village: data['village'] ?? '',
      barangay: data['barangay'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePictureUrl: data['profilePicture'], // Ensure case matches exactly
    );
  }

  // Convert Client object to JSON (for updating Firestore or other purposes)
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthday': birthday,
      'unitNumber': unitNumber,
      'street': street,
      'village': village,
      'barangay': barangay,
      'city': city,
      'province': province,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl, // Include profile picture URL
    };
  }

  // Static method to fetch Client data for the currently signed-in user
  static Future<Client?> fetchCurrentClient() async {
    try {
      // Get the currently signed-in user's uid and email
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        String email = user.email!; // Get email from FirebaseAuth

        // Fetch the client's data from Firestore using the uid
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('clients').doc(uid).get();

        if (doc.exists) {
          return Client.fromFirestore(doc, email); // Pass email to the constructor
        } else {
          print('No client data found for uid: $uid');
          return null;
        } 
      } else {
        print('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      print('Error fetching client data: $e');
      return null;
    }
  }
}
