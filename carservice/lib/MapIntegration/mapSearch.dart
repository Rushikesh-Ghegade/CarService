import 'dart:convert';
import 'dart:developer';

import 'package:carservice/packages/packages.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MapSearch extends StatefulWidget {
  const MapSearch({super.key});

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  TextEditingController _searchController = TextEditingController();

  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placeList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(() {
      onChange();
    });
  }

  void convert() async {
    try {
      // List<Location> locations = await locationFromAddress(str);
      // String str =
      //     '${locations.last.longitude.toString()} ${locations.last.latitude.toString()}';

      // log("$str");
      // _searchController.clear();
    } catch (e) {
      log("Error");
    }
  }

  void onChange() {
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
    }

    //get response form server
    getSuggetion(_searchController.text);
    if (mounted) {
      setState(() {});
    }
  }

  bool flag = true;
  void getSuggetion(String input) async {
    // _placeList = [];
    // flag = false;
    // setState(() {});
    String kPLACES_API_KEY =
        "AlzaSyegdkl4NkJsGBEstr-TQfdSuW38GbUyiuA"; //"AIzaSyBnD7tCaKFSyfFGqk9oK07s5Rrhjc304Q8";
    String baseURL = 'https://maps.gomaps.pro/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    log("${response.body}");
    if (response.statusCode == 200) {
      log("sucessful");
      setState(() {
        _placeList = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception("Faild to load");
    }
    log("$_placeList");
    if (mounted) {
      setState(() {});
    }

    // await Future.delayed(Duration(seconds: 1));
    // flag = true;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  onSaved: (value) {
                    log("message");
                    // convert();
                  },
                  onFieldSubmitted: (value) {
                    log("message");
                    // convert(value);
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                      hintText: "Search place",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              (flag)
                  ? Expanded(
                      child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            log("get");
                            _searchController.clear();
                            _searchController = TextEditingController(
                                text: "${_placeList[index]['description']}");
                            // setState(() {});
                            log("${_placeList[index]['description']}");
                            // await Future.delayed(const Duration(seconds: 2));
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return MapScreen(
                                  search: "${_placeList[index]['description']}",
                                );
                              },
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4, top: 10),
                            // padding: const EdgeInsets.all(2),
                            // height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: ListTile(
                              leading: const Icon(Icons.location_on),
                              title:
                                  Text("${_placeList[index]['description']}"),
                            ),
                          ),
                        );
                      },
                    ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
