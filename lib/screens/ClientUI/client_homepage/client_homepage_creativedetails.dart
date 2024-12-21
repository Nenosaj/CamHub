import 'package:example/screens/responsive_helper.dart';
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

  List<Map<String, dynamic>> packageDetails = [];
  List<String> imageDetails = [];
  List<String> videoDetails = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _fetchPackages();
    _fetchImages();
    _fetchVideos();
  }

  Future<void> _fetchPackages() async {
    String uid = widget.creative['uid']; // Get the creative ID
    List<Map<String, dynamic>> fetchedPackages =
        await _firestoreService.fetchPackageDetail(uid: uid);
    setState(() {
      packageDetails = fetchedPackages; // Store the entire package data
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

  Widget _buildImageGridView(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Center(
        child: Text(
          'No Images uploaded',
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
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        final url = imageUrls[index];
        return GestureDetector(
          onTap: () => _showFullMedia(context, url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
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

  Widget _buildPackageGridView(List<Map<String, dynamic>> packages) {
    if (packages.isEmpty) {
      return Center(
        child: Text(
          'No Packages uploaded',
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
        childAspectRatio: 3 / 4,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final name = package['title'] ?? 'Unknown Package';
        final price =
            package['price'] != null ? 'PHP${package['price']}' : 'Free';
        final description =
            package['description'] ?? 'No description available';
        final imageUrl = package['package'] ?? '';
        final uuid = package['uuid'] ?? 'unknown';
        final creativeuid = widget.creative['uid'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PackageDetailsPage(
                  uuid: uuid,
                  creativeuid: creativeuid, // Pass the specific package's UUID
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                size: 50, color: Colors.grey);
                          },
                        )
                      : Container(
                          height: 150,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoGridView(List<String> videoUrls) {
    if (videoUrls.isEmpty) {
      return Center(
        child: Text(
          'No Videos uploaded',
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
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        final url = videoUrls[index];
        return GestureDetector(
          onTap: () => _showFullVideo(context, url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildVideoThumbnail(url),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF662C2B),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.white), // Back button icon
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: Text(
            widget.creative['businessName'] ?? 'Creative Details',
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share,
                  color: Color.fromARGB(255, 255, 255, 255)),
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
                      widget.creative['profilePicture'] ?? '',
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
                        Text(
                          widget.creative['businessName'] ?? 'Business Name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat, color: Color(0xFF662C2B)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/MessagingScreen');
                        },
                      ),
                      const Text(
                        'Chat with Us',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF662C2B),
                        ),
                      ),
                    ],
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
                  _buildPackageGridView(packageDetails),
                  _buildImageGridView(imageDetails),
                  _buildVideoGridView(videoDetails),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
