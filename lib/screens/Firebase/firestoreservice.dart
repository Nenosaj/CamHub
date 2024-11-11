// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add general user information
  Future<void> addUser({
    required String uid,
    required String email,
    required String userType,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'userType': userType,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Function to add specific details for clients
  Future<void> addClientDetails({
    required String uid,
    required Map<String, dynamic> clientDetails,
  }) async {
    await _firestore.collection('clients').doc(uid).set(clientDetails);
  }

  // Function to add specific details for creatives
  Future<void> addCreativeDetails({
    required String uid,
    required Map<String, dynamic> creativeDetails,
  }) async {
    await _firestore.collection('creatives').doc(uid).set(creativeDetails);
  }

  Future<void> addImageDetails({
    required String uid,
    required Map <String, dynamic> imageDetails,
  }) async {
    await _firestore.collection('image').doc(uid).collection('uploads').add(imageDetails);
  }

  Future<void> addVideoDetails({
    required String uid,
    required Map <String, dynamic> videoDetails,
  }) async {
    await _firestore.collection('image').doc(uid).collection('uploads').add(videoDetails);
  }

  // Function to fetch user type
  Future<String> getUserType(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc['userType'];
  }

  Future<DocumentSnapshot> fetchUserData(String uid, String userType) async {
    String collection = userType == 'creative' ? 'creatives' : 'clients';
    return await _firestore.collection(collection).doc(uid).get();
  }

   Future<void> updateUserData(String uid, String userType, Map<String, dynamic> data) async {
    // Determine the collection based on userType
    String collection = userType == 'creative' ? 'creatives' : 'clients';
    
    await _firestore.collection(collection).doc(uid).update(data);
  }



  
}
