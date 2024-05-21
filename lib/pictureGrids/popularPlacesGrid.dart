import 'package:amigos_ver1/destination/sampleDestinationDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/destinationTabs.dart';
import '../services/map_services.dart';

class PopularPlacesGrid extends StatefulWidget {
  const PopularPlacesGrid({super.key});

  @override
  State<PopularPlacesGrid> createState() => _PopularPlacesGridState();
}


class _PopularPlacesGridState extends State<PopularPlacesGrid> {
  List<Map<String, dynamic>> popularDestinations = [];
  bool isLoading = false;
  TextEditingController placesEntry = TextEditingController();

  @override
  void initState(){
    super.initState();
    gridLoadingTasks();
  }

  void gridLoadingTasks() async{
    setState(() {
      isLoading = true;
    });
    popularDestinations = await MapServices().getPopularDestinationsUK();
    setState(() {
      isLoading = false;
    });
  }

  void retrieveSearch()async{
    setState(() {
      isLoading = true;
    });

    popularDestinations = await MapServices().destinationSearch(placesEntry.text.trim());

    // Hide loading indicator
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
          elevation: 0,
          title: const Text("POPULAR DESTINATIONS",style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0
          )),
        ),
      body: isLoading
      ?const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator( // Circular progress indicator with a dashed appearance
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(24, 22, 106, 1)),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 15.0,),
            Text("Fetching locations...",
              style: TextStyle(
                  color: Color.fromRGBO(24, 22, 106, 1),
                  fontSize: 15.0
              ),),
          ],
        ),
      )
      :SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.0,20.0,25.0,50.0),
        child: Column(
          children: [
            TextFormField(
              controller: placesEntry,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5.0),
                  hintText: "Discover Destinations",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none),
                  fillColor: const Color.fromRGBO(236, 236, 237, 1),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: (){
                      retrieveSearch();
                    },
                    color: Colors.black,
                    icon: Icon(Icons.search, size: 25.0,),
                  )),
              autocorrect: true,
              enableSuggestions: true,
            ),
            SizedBox(height: 15.0,),
            Text(
              "${popularDestinations.length} entries have been retrieved",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(24, 22, 106, 1)
              ),
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              height: 650,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: popularDestinations.length,
                itemBuilder: (BuildContext context, int index) {
                  final destination = popularDestinations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: destination['placeId'], placeName: destination['name'],)));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 330,
                            height: 270,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(destination['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            destination['name'] ?? 'Unknown',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Color.fromRGBO(24, 22, 106, 1)
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20.0,)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
