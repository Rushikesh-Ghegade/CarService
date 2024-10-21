import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:carservice/packages/packages.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final String search;
  const MapScreen({super.key, required this.search});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    _marker.addAll(_list);
    loadData();
    getpolyPoints();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {});
    });
  }

  List<Marker> _marker = [];
  Set<Polyline> line = {};

  Uint8List? markerimage;

  List<String> images = ["lib/images/car.png", "lib/images/motorbike.png"];
  List<LatLng> latlng = const [
    LatLng(18.6924, 74.1323),
    LatLng(18.5808, 73.9787)
  ];

  Future<Uint8List> getByteFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<LatLng> getsearchloc() async {
    List<Location> locations = await locationFromAddress(widget.search);

    return LatLng(locations.last.latitude, locations.last.longitude);
    // String str ='${locations.last.longitude.toString()} ${locations.last.latitude.toString()}';
  }

  Future<void> loadData() async {
    (widget.search == 'Search Place')
        ? getUserCurrentLocation().then((value) async {
            log("My Current Loc : latitude${value.latitude.toString()}longitude${value.longitude.toString()}");
            _marker.add(Marker(
                markerId: const MarkerId("4"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: const InfoWindow(
                  title: "My Current Location",
                )));

            CameraPosition _camerapos = CameraPosition(
                target: LatLng(value.latitude, value.longitude), zoom: 14);
            // Future.delayed(const Duration(seconds: 1));
            GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(_camerapos));
            setState(() {});
          })
        : await getsearchloc().then((value) async {
            _marker.add(Marker(
                markerId: const MarkerId("4"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(
                  title: widget.search,
                )));

            CameraPosition _camerapos = (widget.search == 'Search Place')
                ? CameraPosition(
                    target: LatLng(value.latitude, value.longitude), zoom: 14)
                : CameraPosition(
                    target: LatLng(value.latitude, value.longitude), zoom: 14);
            // Future.delayed(const Duration(seconds: 1));
            GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(_camerapos));
            setState(() {});
          });

    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getByteFromAssets(images[i], 100);

      _marker.add(
        Marker(
          markerId: MarkerId('${i + 5}'),
          icon: BitmapDescriptor
              .defaultMarker, //BitmapDescriptor.fromBytes(markerIcon),
          position: latlng[i],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://t3.ftcdn.net/jpg/06/41/73/20/360_F_641732036_if4Eq4gHSoPiDmmxIcim0FDPkjWGYlOq.jpg"),
                            fit: BoxFit.fill),
                      ),
                    )
                  ],
                ),
              ),
              latlng[i],
            );
          },
        ),
      );
    }
    line.add(Polyline(
      polylineId: PolylineId("1"),
      points: latlng,
    ));
  }

  final List<Marker> _list = const [
    // Marker(
    //     markerId: MarkerId("1"),
    //     position: LatLng(18.44785, 73.82418),
    //     infoWindow: InfoWindow(
    //       title: "My Current Location",
    //     )),
    // Marker(
    //     markerId: MarkerId("2"),
    //     position: LatLng(18.51957, 73.85535),
    //     infoWindow: InfoWindow(
    //       title: "Pune",
    //     )),
    // Marker(
    //     markerId: MarkerId("3"),
    //     position: LatLng(18.44874, 73.82614),
    //     infoWindow: InfoWindow(
    //       title: "My Collage",
    //     )),
    // Marker(
    //     markerId: MarkerId("4"),
    //     position: LatLng(20.5937, 78.9629),
    //     infoWindow: InfoWindow(
    //       title: "India",
    //     )),
  ];
  Completer<GoogleMapController> _controller = Completer();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      log("$error");
    });

    return await Geolocator.getCurrentPosition();
  }

  static const LatLng sourceloc = LatLng(18.6924, 74.1323);
  static const LatLng destloc = LatLng(18.5808, 73.9787);

  List<LatLng> polylinecoordinates = [];

  void getpolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();

    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyBnD7tCaKFSyfFGqk9oK07s5Rrhjc304Q8',
      request: PolylineRequest(
          origin: PointLatLng(sourceloc.latitude, sourceloc.longitude),
          destination: PointLatLng(destloc.latitude, destloc.longitude),
          mode: TravelMode.bicycling),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((element) =>
          polylinecoordinates.add(LatLng(element.latitude, element.longitude)));
    }
    setState(() {});
  }

  static const CameraPosition _cameraPos =
      CameraPosition(target: LatLng(18.44785, 73.82418), zoom: 14.4746);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
            height: 45,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const MapSearch();
                  },
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 206, 198, 198),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.search,
                      size: 31,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    (widget.search.length < 30)
                        ? Text(
                            widget.search,
                            style: const TextStyle(
                              fontSize: 21,
                            ),
                          )
                        : Text(
                            '${widget.search.substring(0, 30)} ...',
                            style: const TextStyle(
                              fontSize: 21,
                            ),
                          ),
                  ],
                ),
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPos,
            markers: Set<Marker>.of(_marker),
            compassEnabled: true,
            mapType: MapType.normal,
            polylines: {
              Polyline(
                polylineId: const PolylineId("1"),
                points: polylinecoordinates,
              )
            },
            myLocationEnabled: true,
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 300,
            offset: 35,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await loadData();
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
