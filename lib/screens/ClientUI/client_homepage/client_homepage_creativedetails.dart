import 'package:flutter/material.dart';
import 'package:example/screens/Firebase/firestoreservice.dart';
import 'package:example/screens/ClientUI/client_homepage/client_packagedetails.dart';

import 'package:example/screens/VideoPlayer/video_player_widget.dart'; // Adjust the path to where you saved it

class CreativesDetailPage extends StatefulWidget {
  final Map<String, dynamic> creative;

  const CreativesDetailPage({super.key, required this.creative});

  @override
  _CreativesDetailPageState createState() => _CreativesDetailPageState();
}

class _CreativesDetailPageState extends State<CreativesDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  List<String> packageDetails = [];
  List<String> imageDetails = [];
  List<String> videoDetails = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // ignore: avoid_print
    print("Passed Creative UID: ${widget.creative['uid']}");

    _fetchPackages();
    _fetchImages();
    _fetchVideos();
  }

  Future<void> _fetchPackages() async {
    String uid = widget.creative['uid']; // Get the creative ID
    List<String> fetchedPackages =
        await _firestoreService.fetchPackageDetails(uid: uid);
    setState(() {
      packageDetails = fetchedPackages;
    });
  }

  Future<void> _fetchImages() async {
    String uid = widget.creative['uid']; // Get the creative ID
    List<String> fetchedImages =
        await _firestoreService.fetchImageDetails(uid: uid);
    setState(() {
      imageDetails = fetchedImages;
    });
  }

  Future<void> _fetchVideos() async {
    String uid = widget.creative['uid']; // Get the creative ID
    List<String> fetchedVideos =
        await _firestoreService.fetchVideoDetails(uid: uid);
    setState(() {
      videoDetails = fetchedVideos;
    });
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
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 4 / 5,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        final url = urls[index];

        // Check if it's a video (based on file extension)
        bool isVideo = url.contains('.mp4') ||
            url.contains('.mov') ||
            url.contains('.avi');

        return GestureDetector(
          onTap: () {
            if (type == 'Packages') {
              print(
                  "Navigating to PackageDetailsPage with UUID: ${widget.creative['uid']}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PackageDetailsPage(uuid: widget.creative['uid']),
                ),
              );
            } else if (isVideo) {
              _showFullVideo(context, url); // Open video player for videos
            } else {
              _showFullMedia(context, url); // Open full image for photos
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? _buildVideoThumbnail(url) // Show play icon for videos
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                  ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.creative['businessName'] ?? 'Creative Details',
            style: const TextStyle(color: Color(0xFF302D2C)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Color(0xFF662C2B)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF662C2B)),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.creative['profilePicture'] ??
                          'https://via.placeholder.com/150',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.creative['businessName'] ?? 'Business Name',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Color(0xFF662C2B),
              labelColor: Color(0xFF662C2B),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Packages'),
                Tab(text: 'Images'),
                Tab(text: 'Videos'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGridView(packageDetails, 'Packages'),
                  _buildGridView(imageDetails, 'Photos'),
                  _buildGridView(videoDetails, 'Videos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
