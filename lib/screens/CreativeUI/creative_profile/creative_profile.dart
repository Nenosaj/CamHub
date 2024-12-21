import 'package:example/screens/CreativeUI/creative_profile/creative_profile_reviews.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'creative_profile_booking/creative_profile_booking.dart';
import '../creative_model/creative_model.dart'; // Import the creative model
import 'package:example/screens/Firebase/firestoreservice.dart';
import 'package:example/screens/VideoPlayer/video_player_widget.dart'; // Adjust the path to where you saved it

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreativeProfilePage(),
    );
  }
}

class CreativeProfilePage extends StatefulWidget {
  const CreativeProfilePage({super.key});

  @override
  ProfilePages createState() => ProfilePages();
}

class ProfilePages extends State<CreativeProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Creative? creative;
  List<String> imageDetails = [];
  List<String> videoDetails = [];
  List<String> packageDetails = [];
  final FirestoreService _firestoreService =
      FirestoreService(); // Initialize _firestoreService
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchCreativeData(); // Fetch creative data on init
    _fetchImages(); // Fetch images on init
    _fetchVideos(); // Fetch videos on init
    _fetchPackages(); // Fetch packages on init
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch the currently signed-in creative
  Future<void> _fetchCreativeData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String businessEmail = FirebaseAuth.instance.currentUser!.email!;

      if (user != null) {
        DocumentSnapshot creativeDoc = await FirebaseFirestore.instance
            .collection('creatives')
            .doc(user.uid)
            .get();

        if (creativeDoc.exists) {
          setState(() {
            creative = Creative.fromFirestore(creativeDoc, businessEmail);
          });
        } else {
          // ignore: avoid_print
          print("No creative data found.");
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching creative data: $e");
    }
  }

  Future<void> _fetchImages() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> fetchedImages =
            await _firestoreService.fetchImageDetails(uid: user.uid);

        setState(() {
          imageDetails = fetchedImages;
        });

        // ignore: avoid_print
        print("Fetched Images: $imageDetails");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching images: $e");
    }
  }

  Future<void> _fetchVideos() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> fetchedVideos =
            await _firestoreService.fetchVideoDetails(uid: user.uid);

        setState(() {
          videoDetails = fetchedVideos;
        });

        // ignore: avoid_print
        print("Fetched Videos: $videoDetails");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching videos: $e");
    }
  }

  Future<void> _fetchPackages() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // ignore: avoid_print
        print("Fetching Packages for UID: ${user.uid}");
        List<String> fetchedPackages =
            await _firestoreService.fetchPackageDetails(uid: user.uid);

        setState(() {
          packageDetails = fetchedPackages; // Update packageDetails state
        });

        // ignore: avoid_print
        print("Fetched Packages: $packageDetails");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching packages: $e");
    }
  }

  void _enlargeProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pop(); // Close the enlarged image when tapped
            },
            child: Center(
              child: CircleAvatar(
                radius: 150, // Larger radius for the profile image
                backgroundColor: Colors.grey[300],
                backgroundImage: creative?.profilePictureUrl != null
                    ? NetworkImage(creative!.profilePictureUrl!)
                    : null,
                child: creative?.profilePictureUrl == null
                    ? Icon(Icons.person, size: 150, color: Colors.grey[600])
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<String> urls, String type) {
    if (urls.isEmpty) {
      return Center(
        child: Text(
          'No $type uploaded',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 4, // Adjust aspect ratio for better visuals
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        final url = urls[index];
        final documentId = _extractDocumentId(url);

        bool isVideo = url.contains('.mp4') ||
            url.contains('.mov') ||
            url.contains('.avi');

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (isVideo) {
                  _showFullVideo(context, url); // Open full video
                } else {
                  _showFullMedia(context, url); // Open full image
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isVideo
                      ? _buildVideoThumbnail(url) // Show play icon for videos
                      : Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                size: 50, color: Colors.grey);
                          },
                        ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _confirmAndDelete(context, documentId, type),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.delete, color: Colors.red, size: 24),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoThumbnail(String videoUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.black12, // Placeholder for video thumbnail
        ),
        const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
      ],
    );
  }

  void _showFullVideo(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(videoUrl: videoUrl),
      ),
    );
  }

  void _showFullMedia(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(
      BuildContext context, String documentId, String type) async {
    final uid =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's UID

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete $type'),
          content: Text('Are you sure you want to delete this $type?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        if (type == 'Image') {
          await _firestoreService.removeImage(uid: uid, documentId: documentId);
          setState(() {
            imageDetails.removeWhere(
                (image) => _extractDocumentId(image) == documentId);
          });
        } else if (type == 'Video') {
          await _firestoreService.removeVideo(uid: uid, documentId: documentId);
          setState(() {
            videoDetails.removeWhere(
                (video) => _extractDocumentId(video) == documentId);
          });
        } else if (type == 'Package') {
          await _firestoreService.removePackage(
              uid: uid, documentId: documentId);
          setState(() {
            packageDetails.removeWhere(
                (package) => _extractDocumentId(package) == documentId);
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$type removed successfully.')),
        );
      } catch (e) {
        print('Error removing $type: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove $type.')),
        );
      }
    }
  }

  String _extractDocumentId(String url) {
    // Assuming the document ID is part of the URL structure
    final uri = Uri.parse(url);
    return uri.pathSegments.last.split('.').first; // Example: "docId.extension"
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF662C2B), // Dark red background color
        title: const Text('Profile',
            style: TextStyle(color: Color.fromARGB(255, 252, 252, 252))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.transparent, // Set the color to white
          ),
          onPressed: () {
            // Implement back navigation if necessary
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Info Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _enlargeProfileImage(
                          context); // Enlarge the profile image when tapped
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: creative?.profilePictureUrl != null
                          ? NetworkImage(creative!.profilePictureUrl!)
                          : null,
                      child: creative?.profilePictureUrl == null
                          ? Icon(Icons.person,
                              size: 55, color: Colors.grey[600])
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creative?.businessName ?? 'Business Name',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        creative?.city ?? 'Location',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.grey[600], size: 16),
                          Text(creative?.city ?? 'Location',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookings Button (half width and aligned left)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.3, // Half width of the screen
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to BookingPage when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF7B3A3F), // Dark red color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Adjust button height
                      ),
                      child: const Text(
                        "Bookings",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Tab Bar (Photos, Videos, Packages, Review)
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF7B3A3F),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF7B3A3F),
              tabs: const [
                Tab(text: 'Photos'),
                Tab(text: 'Videos'),
                Tab(text: 'Packages'),
                Tab(text: 'Review'),
              ],
            ),
            // Tab View
            SizedBox(
              height: 300, // Set height for the TabBarView
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Photos Tab: Grid of Images
                  _buildGridView(imageDetails, 'Image'),

                  // Videos Tab: Grid of Videos
                  _buildGridView(videoDetails, 'Video'),

                  // Packages Tab: Grid of Packages
                  _buildGridView(packageDetails, 'Package'),

                  // Review Tab
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreativeReviews(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'No reviews yet. Tap to view details.',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
