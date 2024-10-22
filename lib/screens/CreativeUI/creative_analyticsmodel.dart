class CreativeAnalytics {
  final String creativeName;
  final double rating;
  final int monthlyRevenue; // Monthly revenue in currency units
  final int totalOrders; // Total number of orders
  final int totalCustomers; // Total unique customers
  final int totalImpressions; // Total impressions or views

  CreativeAnalytics({
    required this.creativeName,
    required this.rating,
    required this.monthlyRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalImpressions,
  });

  // Factory method to create a CreativeAnalytics object from Firestore data
  factory CreativeAnalytics.fromFirestore(Map<String, dynamic> data) {
    return CreativeAnalytics(
      creativeName: data['creativeName'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      monthlyRevenue: data['monthlyRevenue'] ?? 0,
      totalOrders: data['totalOrders'] ?? 0,
      totalCustomers: data['totalCustomers'] ?? 0,
      totalImpressions: data['totalImpressions'] ?? 0,
    );
  }

  // Method to convert CreativeAnalytics object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'creativeName': creativeName,
      'rating': rating,
      'monthlyRevenue': monthlyRevenue,
      'totalOrders': totalOrders,
      'totalCustomers': totalCustomers,
      'totalImpressions': totalImpressions,
    };
  }
}
