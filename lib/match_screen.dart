

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:score_app/custom_card.dart';
import 'package:score_app/entities.dart';


class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  List<Cricket> matchList = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final snapshot = await firebaseFireStore.collection('cricket').get();
      final List<Cricket> loadedMatches = snapshot.docs.map((doc) {
        // Access the document ID if needed
        String documentId = doc.id;

        return Cricket(
          team1Name: doc['team1Name'].toString(),
          team2Name: doc['team2Name'].toString(),
          team1: doc['team1'].toString(),
          team2: doc['team2'].toString(),
          matchName: doc.id,
        );
      }).toList();


      setState(() {
        matchList = loadedMatches;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: matchList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: matchList.length,
        itemBuilder: (context, index) {
          return CustomCard(cricket: matchList[index]);
        },
      ),
    );
  }
}