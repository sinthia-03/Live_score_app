import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/football_match.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _footballCollectionName = 'football';

  // bool _getMatchesInProgress = false;
  // List<FootballScore> _footballMatchesList = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getFootballMatches();
  // }
  //
  // // One time get operation
  // Future<void> _getFootballMatches() async {
  //   _footballMatchesList.clear();
  //   _getMatchesInProgress = true;
  //   setState(() {});
  //
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //       .instance
  //       .collection('football')
  //       .get();
  //   for (QueryDocumentSnapshot doc in snapshot.docs) {
  //     _footballMatchesList.add(
  //       FootballScore.fromJson(doc.id, doc.data() as Map<String, dynamic>),
  //     );
  //   }
  //   _getMatchesInProgress = false;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: _onTapLogout, icon: Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(_footballCollectionName)
            .snapshots(),
        builder:
            (
            context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> asyncSnapshot,
            ) {
          if (asyncSnapshot.connectionState == .waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }

          if (asyncSnapshot.hasData == false) {
            return Center(child: Text('No data available'));
          }

          List<FootballMatch> footballMatchesList = [];
          for (QueryDocumentSnapshot doc in asyncSnapshot.data!.docs) {
            footballMatchesList.add(
              FootballMatch.fromJson(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            );
          }

          return ListView.separated(
            itemCount: footballMatchesList.length,
            itemBuilder: (context, index) {
              final FootballMatch match = footballMatchesList[index];

              return Dismissible(
                key: Key(match.id),
                onDismissed: (_) {
                  _deleteMatchItem(match.id);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: match.isRunning
                        ? Colors.green
                        : Colors.grey,
                    radius: 8,
                  ),
                  title: Text('${match.team1Name} vs ${match.team2Name}'),
                  subtitle: Text('Winner team: ${match.winnerTeam}'),
                  trailing: Text(
                    '${match.team1Score} - ${match.team2Score}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
            separatorBuilder: (_, _) => Divider(height: 8),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddButton() {
    try {
      FootballMatch newFootballMatch = FootballMatch(
          id: 'argvsuru',
          team1Name: 'Argentina',
          team2Name: 'Uruguay',
          winnerTeam: 'Argentina',
          team1Score: 1,
          team2Score: 1,
          isRunning: false
      );

      // Creates new item every time
      // FirebaseFirestore.instance
      //     .collection(_footballCollectionName)
      //     .add(newFootballMatch.toJson());
      // FirebaseFirestore.instance
      //     .collection(_footballCollectionName)
      //     .doc(newFootballMatch.id) // Because of this id
      //     .update(newFootballMatch.toJson());
      FirebaseFirestore.instance
          .collection(_footballCollectionName)
          .doc(newFootballMatch.id) // Because of this id
          .set(newFootballMatch.toJson());
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }
  }

  Future<void> _deleteMatchItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(_footballCollectionName)
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match deleted!'))
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }
  }

  void _onTapLogout() {
    FirebaseAuth.instance.signOut();
  }
}