import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PartyPalaceView extends StatelessWidget {
  final List<Map<String, dynamic>> palaces = [
    {
      "name": "Imperial Palace",
      "image": "assets/images/imperial.png",
      "location": "Kalanki, Kathmandu",
      "rating": 4.8,
      "seats": 300,
      "price": "Rs. 65,000",  
    },
    {
      "name": "Smart Palace",
      "image": "assets/images/smart.png",
      "location": "Baneshwor, Kathmandu",
      "rating": 4.5,
      "seats": 250,
      "price": "Rs. 60,000",  
    },
    {
      "name": "Taaj Banquet",
      "image": "assets/images/taaj.png",
      "location": "Pulchowk, Lalitpur",
      "rating": 4.9,
      "seats": 350,
      "price": "Rs. 95,000",  
    },
    {
      "name": "Sundhara Party Palace",
      "image": "assets/images/bestparty.png",
      "location": "Sundhara, Kathmandu",
      "rating": 4.6,
      "seats": 200,
      "price": "Rs. 55,000",  
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Top Party Palaces 🎉",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade600,  // changed to orange
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: palaces.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final palace = palaces[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade50, Colors.white],  // updated gradient start to light orange tint
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      palace["image"],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          palace["name"],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade700,  // match orange tone
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.deepOrangeAccent),
                            const SizedBox(width: 5),
                            Text(
                              palace["location"],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: palace["rating"],
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBadge(
                                icon: Icons.event_seat,
                                label: '${palace["seats"]} Seats'),
                            InfoBadge(
                                icon: Icons.attach_money,
                                label: palace["price"]),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,  // changed button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // handle action
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 10),
                              child: Text(
                                "Book Now",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepOrange),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
