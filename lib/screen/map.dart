// lib/screen/map.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  static const LatLng _initialPosition = LatLng(37.5665, 126.9780);
  static const double _defaultZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    setState(() {}); // Refresh to reflect permission status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동물병원 지도'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '동물병원 검색',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => _search(),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: _defaultZoom,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapType:
                  MapType.normal, // 변경 가능: normal, satellite, terrain, hybrid
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    print('Google Map created');
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('검색어를 입력해주세요.')),
      );
      return;
    }

    try {
      final results = await _searchAnimalHospitals(query);
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('검색 결과가 없습니다.')),
        );
        return;
      }

      setState(() {
        _markers.clear();
        for (var result in results) {
          final marker = Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(
              result['geometry']['location']['lat'],
              result['geometry']['location']['lng'],
            ),
            infoWindow: InfoWindow(
              title: result['name'],
              snippet: result['formatted_address'],
            ),
          );
          _markers.add(marker);
        }

        // 첫 번째 결과로 카메라 이동
        final firstResult = results.first;
        _controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              firstResult['geometry']['location']['lat'],
              firstResult['geometry']['location']['lng'],
            ),
            16.0,
          ),
        );
      });
    } catch (e) {
      print('검색 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('검색 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<List<dynamic>> _searchAnimalHospitals(String query) async {
    final apiKey = 'AIzaSyBVI41IWtw_gCJunfv3IkyRJKgngGRVBfU'; // 실제 API 키로 교체하세요
    final encodedQuery = Uri.encodeComponent('$query animal hospital');
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedQuery&key=$apiKey&location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=5000&type=veterinary_care';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['results'];
      } else {
        print('API 오류: ${data['status']}');
        return [];
      }
    } else {
      throw Exception('동물병원 정보를 불러오는 데 실패했습니다.');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('initial'),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: '초기 위치'),
        ),
      );
    });
  }
}
