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
    required Map<String, dynamic> imageDetails,
  }) async {
    await _firestore
        .collection('image')
        .doc(uid)
        .collection('uploads')
        .add(imageDetails);
  }

  Future<void> addVideoDetails({
    required String uid,
    required Map<String, dynamic> videoDetails,
  }) async {
    await _firestore
        .collection('video')
        .doc(uid)
        .collection('uploads')
        .add(videoDetails);
  }

  Future<void> addPackageDetails({
    required String uid,
    required Map<String, dynamic> packageDetails,
  }) async {
    await _firestore
        .collection('package')
        .doc(uid)
        .collection('uploads')
        .add(packageDetails);
  }

  Future<List<String>> fetchImageDetails({required String uid}) async {
    try {
      // Fetch the documents from the 'uploads' subcollection in the 'image' collection
      QuerySnapshot snapshot = await _firestore
          .collection('image')
          .doc(uid)
          .collection('uploads')
          .get();

      // Extract the 'images' field (list of URLs) from each document
      List<String> imageUrls = [];

      for (var doc in snapshot.docs) {
        List<dynamic>? images =
            doc['images'] as List<dynamic>?; // Extract images field
        if (images != null) {
          imageUrls.addAll(images.map((e) => e.toString()));
        }
      }

      return imageUrls;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching image details: $e');
      return [];
    }
  }

  Future<List<String>> fetchVideoDetails({required String uid}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('video')
          .doc(uid)
          .collection('uploads')
          .get();

      List<String> videoUrls = [];

      for (var doc in snapshot.docs) {
        List<dynamic>? videos = doc['videos'] as List<dynamic>?;
        if (videos != null) {
          videoUrls.addAll(videos.map((e) => e.toString()));
        }
      }

      return videoUrls;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching video details: $e');
      return [];
    }
  }

  Future<List<String>> fetchPackageDetails({required String uid}) async {
    try {
      // Fetch the documents from the 'uploads' subcollection in the 'package' collection
      QuerySnapshot snapshot = await _firestore
          .collection('package')
          .doc(uid)
          .collection('uploads')
          .get();

      List<String> packageUrls = [];

      for (var doc in snapshot.docs) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('package')) {
            packageUrls
                .add(data['package'] as String); // Add single package URL
          }
        }
      }

      // ignore: avoid_print
      print("Fetched Package URLs: $packageUrls");
      return packageUrls;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching package details: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPackageDetail(
      {required String uid}) async {
    try {
      // Fetch all documents from the 'uploads' subcollection
      QuerySnapshot snapshot = await _firestore
          .collection('package')
          .doc(uid)
          .collection('uploads')
          .get();

      List<Map<String, dynamic>> packageDetails = [];

      for (var doc in snapshot.docs) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          data['uuid'] = doc.id;

          packageDetails.add(data); // Add the entire document data as a map
        }
      }

      // Print fetched package details for debugging
      print("Fetched Package Details: $packageDetails");
      return packageDetails;
    } catch (e) {
      // Handle errors
      print('Error fetching package details: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookingDetails(
      {required String creativeId}) async {
    try {
      // Fetch the documents from the 'uploads' subcollection in the 'bookings' collection
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .doc(creativeId)
          .collection('uploads')
          .get();

      List<Map<String, dynamic>> bookingDetailsList = [];

      for (var doc in snapshot.docs) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('bookingDetails')) {
            bookingDetailsList.add({
              'id': doc.id, // Add document ID
              ...data['bookingDetails']
                  as Map<String, dynamic>, // Merge booking details
            });
          }
        }
      }

      print("Fetched Booking Details: $bookingDetailsList");
      return bookingDetailsList;
    } catch (e) {
      print('Error fetching booking details: $e');
      return [];
    }
  }

  // Function to fetch user type
  Future<String> getUserType(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc['userType'];
  }

  Future<DocumentSnapshot> fetchUserData(String uid, String userType) async {
    String collection = userType == 'creative' ? 'creatives' : 'clients';
    return await _firestore.collection(collection).doc(uid).get();
  }

  Future<void> updateUserData(
      String uid, String userType, Map<String, dynamic> data) async {
    // Determine the collection based on userType
    String collection = userType == 'creative' ? 'creatives' : 'clients';

    await _firestore.collection(collection).doc(uid).update(data);
  }

  Future<List<Map<String, dynamic>>> fetchAllAppointments() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('appointments').get();

      // Convert documents into a list of maps
      List<Map<String, dynamic>> appointments = snapshot.docs
          .map((doc) => {
                'id': doc.id, // Include the document ID
                ...doc.data() as Map<String, dynamic>
              })
          .toList();

      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Fetch a single appointment by UUID
  Future<Map<String, dynamic>?> fetchAppointmentById(String uuid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('appointments').doc(uuid).get();

      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      } else {
        print('Appointment not found');
        return null;
      }
    } catch (e) {
      print('Error fetching appointment by ID: $e');
      return null;
    }
  }
}
