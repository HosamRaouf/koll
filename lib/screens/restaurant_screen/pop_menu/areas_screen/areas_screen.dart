import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/core/models/area_model.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/areas_screen/area_widget.dart';
import 'package:kol/styles.dart';

import '../../../../map.dart';
import '../../../../permessions.dart';

class AreasScreen extends StatefulWidget {
  const AreasScreen({super.key});

  @override
  State<AreasScreen> createState() => _AreasScreenState();
}

class _AreasScreenState extends State<AreasScreen> {
  late LatLng currentPosition =
      LatLng(restaurantData.location.long, restaurantData.location.lat);

  late GoogleMapController _controller;

  List<Color> colors = [
    Colors.redAccent,
    Colors.blue,
    Colors.purple,
    Colors.yellow,
    Colors.cyanAccent,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
    Colors.pink,
    Colors.deepOrange,
  ];

  @override
  void initState() {
    fetchAreas();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final AsyncMemoizer _memorizer = AsyncMemoizer();

  fetchAreas() {
    _memorizer.runOnce(() => restaurantDocument.get().then((value) {
          Map<String, dynamic> data = value.data() as Map<String, dynamic>;
          setState(() {
            restaurantData.areas.clear();
            restaurant['areas'].clear();
            List areas = data['areas'];
            for (var element in areas) {
              restaurantData.areas.add(AreaModel.fromJson(element));
              restaurant['areas'].add(element);
            }
            saveMap();
          });
        }).whenComplete(() {
          AppPermissionProvider provider = AppPermissionProvider();
          provider.getLocationStatus();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: BlankScreen(
                  title: 'مناطق التوصيل',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 24.sp,
                      ),
                      Expanded(
                        child: MyScrollConfigurations(
                          horizontal: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                  restaurantData.areas.length,
                                  (index) => AreaWidget(
                                      area: restaurantData.areas[index],
                                      colors: colors,
                                      polygonId: index,
                                      areaIndex: index)).reversed.toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24.sp),
                        child: Container(
                          decoration: cardDecoration.copyWith(
                            borderRadius:
                                BorderRadius.circular((25.r + 40.sp) - 24.sp),
                          ),
                          height: 0.54.sh,
                          child: Padding(
                            padding: EdgeInsets.all(12.sp),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular((25.r + 40.sp) - 32.sp),
                              child: GoogleMap(
                                onTap: (latLong) {
                                  FocusScope.of(context).unfocus();
                                },
                                mapType: MapType.normal,
                                buildingsEnabled: true,
                                zoomControlsEnabled: true,
                                initialCameraPosition: CameraPosition(
                                    target: currentPosition, zoom: 12),
                                scrollGesturesEnabled: true,
                                polygons: List.generate(
                                    restaurantData.areas.length,
                                    (areaIndex) => Polygon(
                                        polygonId:
                                            PolygonId(areaIndex.toString()),
                                        points: List.generate(
                                            restaurantData.areas[areaIndex]
                                                .markers.length,
                                            (index) => LatLng(
                                                restaurantData.areas[areaIndex]
                                                    .markers[index].lat,
                                                restaurantData.areas[areaIndex]
                                                    .markers[index].long)),
                                        visible: true,
                                        fillColor:
                                            colors[areaIndex].withOpacity(0.2),
                                        strokeColor: colors[areaIndex],
                                        strokeWidth: 2)).reversed.toSet(),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId("source"),
                                    position: currentPosition,
                                  ),
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    _controller = controller;
                                  });
                                },
                                zoomGesturesEnabled: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
