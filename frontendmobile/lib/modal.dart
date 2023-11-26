import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Modal {
  Icon _setRatingStars(int index, String ratingStr) {
    IconData iconSymbol;
    double rating = double.parse(ratingStr);

    if (index < rating.floor() || rating % 1.0 > 0.7) {
      iconSymbol = Icons.star;
    }
    else if (rating % 1.0 > 0.4 && rating % 1.0 < 0.7) {
      iconSymbol = Icons.star_half_outlined;
    }
    else {
      iconSymbol = Icons.star_border;
    }
    return Icon(
        iconSymbol,
        color: Colors.amber,
    );
  }

  String _generatePlatformString(List platforms) {
    String platformStr = (platforms.length == 1) ? "Platform: " : "Platforms: ";

    for (int i = 0; i < platforms.length; i++) {
        platformStr += (i < platforms.length-1)
            ? '${platforms[i]}, '
            : '${platforms[i]}\n';
    }

    return platformStr;
  }

  String _generateGenreString(List genres) {
    String genreStr = (genres.length == 1) ? "Genre: " : "Genres: ";

    Map<int, String> genreMap = {
      2: 'Point-and-click',
      4: 'Fighting',
      5: 'Shooter',
      7: 'Music',
      8: 'Platform',
      9: 'Puzzle',
      10: 'Racing',
      11: 'Real Time Strategy (RTS)',
      12: 'Role-playing (RPG)',
      13: 'Simulator',
      14: 'Sport',
      15: 'Strategy',
      16: 'Turn-based strategy (TBS)',
      24: 'Tactical',
      25: 'Hack and slash/Beat \'em up',
      26: 'Quiz/Trivia',
      30: 'Pinball',
      31: 'Adventure',
      32: 'Indie',
      33: 'Arcade',
      34: 'Visual Novel',
      35: 'Card & Board Game',
      36: 'MOBA',
    };

    for (int i = 0; i < genres.length; i++) {
      genreStr += ((i < genres.length-1)
          ? '${genreMap[genres[i]]!}, '
          : '${genreMap[genres[i]]}\n')!;
    }

    return genreStr;
  }

  String _formatDate(String releaseDate) {
    DateTime dt = DateTime.parse(releaseDate);

    return "${dt.month}/${dt.day}/${dt.year}\n";
  }

  String _setESRBRating(dynamic ageRating) {
    if (ageRating.runtimeType != List ||
        ageRating.length == 0 ||
        !ageRating[0].containsKey('rating')) {
      return "ESRB: N/A";
    }

    Map<int, String> esrbRating = {
      6: 'RP',
      7: 'EC',
      8: 'E',
      9: 'E10',
      10: 'T',
      11: 'M',
      12: 'AO',
    };

    return "ESRB: ${esrbRating[ageRating[0]['rating']]!}";
  }

  void _addToLibrary(BuildContext context,
                    Map<String, dynamic> game,
                    Map<String, dynamic> userInfo) async {
    String userId = userInfo['id'];
    String gameId = game['_id'];

    final addData = {
      'userId': userId,
      'gameId': gameId
    };

    final checkData = {
      'userId': userId
    };

    final jsonAddData = jsonEncode(addData);
    final jsonCheckData = jsonEncode(checkData);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Cookie': 'jwt_access=${userInfo['accessToken']}'
    };

    final checkResponse = await http.post(
      Uri.parse('https://www.toptier.games/Progress/api/getusergame'),
      headers: headers,
      body: jsonCheckData,
    );

    if (checkResponse.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(checkResponse.body);

      for (int i = 0; i < jsonResponse['games'].length; i++) {
        if (jsonResponse['games'][i]['GameId'] == gameId) {
          Fluttertoast.showToast(
            msg: "Game already in library!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
      }

      final response = await http.post(
        Uri.parse('https://www.toptier.games/Progress/api/addusergame'),
        headers: headers,
        body: jsonAddData,
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Game added to library!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    else {
      Fluttertoast.showToast(
        msg: checkResponse.statusCode.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Dialog returnModal(BuildContext context,
                    Map<String, dynamic> game,
                    Map<String, dynamic> cover,
                    Map<String, dynamic> userInfo) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[900]!.withOpacity(0.85),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child:
                        Text(game['Name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 24.0
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 2.0, color: Colors.white),
                            image: DecorationImage(
                                image: NetworkImage("https:${cover!["image"]}"),
                                fit: BoxFit.fill
                            )
                        ),
                      constraints: BoxConstraints.expand(
                        height: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                                (index) => _setRatingStars(index, game['GameRanking']['\$numberDecimal']),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "${double.parse(game['GameRanking']['\$numberDecimal']).toStringAsFixed(2)}   ${game['ReviewCount']} Reviews",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),
                          )
                        ]
                    ),
                    Text(_generatePlatformString(game['Platforms']),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0
                          ),
                        textAlign: TextAlign.left,
                    ),
                    Text(_generateGenreString(game['Genre']),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                          ),
                        textAlign: TextAlign.left,
                    ),
                    Text("Release date: ${_formatDate(game['ReleaseDate'])}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),
                          textAlign: TextAlign.left,
                    ),
                    Text(_setESRBRating(game['AgeRating']),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Text("\nDescription:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18.0
                        ),
                        textAlign: TextAlign.left,
                    ),
                    Text((game['Summary'] != null)
                        ? "${game['Summary']}"
                        : "None",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0
                          ),
                        textAlign: TextAlign.left,
                    ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {
                              _addToLibrary(context, game, userInfo);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 75),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Add to Library', style: TextStyle(
                                color: Colors.white)
                            )
                        )
                      ),
                  ]
              )
          ),
          ])
        )
    );
  }
}