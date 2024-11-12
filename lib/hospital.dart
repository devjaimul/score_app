import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:score_app/entities.dart';


// HospitalScreen widget
class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  List<Hospital> hospitalList = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Fetch hospital list from Firestore
  Future<void> fetchHospitalList() async {
    try {
      final snapshot = await firebaseFirestore.collection('hospital').get();
      final List<Hospital> loadedHospitals = snapshot.docs.map((doc) {
        return Hospital(
          name: doc['name'] ?? 'Unknown Hospital',
          address: doc['address'] ?? 'Unknown Address',
          phone: doc['phone'] ?? 'Unknown Phone',
        );
      }).toList();

      setState(() {
        hospitalList = loadedHospitals;
      });
    } catch (error) {
      print('Error fetching hospital data: $error');
    }
  }

  // Add hospital data to Firestore (run this only once)
  Future<void> addHospitalData() async {
    List<Map<String, String>> hospitals = [
      {
        "name": "আরগ্যে সদন প্রাঃ হাসপাতাল লিঃ",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "01713-024800"
      },
      {
        "name": "ফরিদপুর এ্যাপোলো স্পেশালাইজ্‌ড হসপিটাল",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "কাউন্ডার-01708-852291, 01708-852290"
      },
      {
        "name": "ইসলামী ব্যাংক কমিউনিটি হাসপাতাল",
        "address": "",
        "phone": "01731848464,01923416383, 0631-66603"
      },
      {
        "name": "ডায়বেটিক এসোসিয়েসন মেডিকেল কলেজ ও হাসপাতাল",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "01711703913, 0631-61488, 0631-63496"
      },
      {
        "name": "হার্ট ফাউন্ডেশন হাসপাতাল",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "01708531770,0631-64798"
      },
      {
        "name": "ফরিদপুর সমরিতা জেনারেল হাসপাতাল লিঃ",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "0631-65813, 01712-122910"
      },
      {
        "name": "পরিচর্যা হাসপাতাল",
        "address": "গোয়ালচামট, ফরিদপুর সদর উপজেলা",
        "phone": "0631-63100,0631-64200, 01711468681"
      },
      {
        "name": "আহমাদ আই হসপিটাল এন্ড ফেকো সেন্টার",
        "address": "১১/১৬, লিলিয়ারা টাওয়ার, মুজিব সড়ক, ফরিদপুর",
        "phone": "০১৩৩৪৭১৭১১১"
      },
      {
        "name": "মালেকা চক্ষু হাসপাতাল",
        "address": "মধুখালী, ফরিদপুর",
        "phone": "০১৭২০০৮৩৫৫১"
      },
      {
        "name": "ফরিদপুর সেন্ট্রাল হসপিটাল",
        "address": "ফরিদপুর সদর উপজেলা",
        "phone": "01790008900"
      },
      // Add more hospitals here as needed
    ];

    for (var hospital in hospitals) {
      String hospitalName = hospital["name"] ?? "Unknown Hospital";

      // Use the hospital name as the document ID
      await firebaseFirestore
          .collection('hospital')
          .doc(hospitalName) // Sets the document ID to the hospital name
          .set({
        "name": hospitalName,
        "address": hospital["address"] ?? "Unknown Address",
        "phone": hospital["phone"] ?? "Unknown Phone",
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchHospitalList();
    // Uncomment the following line to add data to Firestore once
   //addHospitalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: hospitalList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: hospitalList.length,
              itemBuilder: (context, index) {
                final hospital = hospitalList[index];
                return ListTile(
                  title: Text(
                    hospital.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${hospital.address}'),
                      Text('Phone: ${hospital.phone}'),
                    ],
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
