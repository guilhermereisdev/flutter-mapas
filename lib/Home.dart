import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    _carregarPoligonos();
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _carregarPoligonos() {
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
      polygonId: PolygonId("polygon1"),
      fillColor: Colors.transparent,
      strokeColor: Colors.red,
      strokeWidth: 10,
      points: const [
        LatLng(-23.561816, -46.652044),
        LatLng(-23.563625, -46.653642),
        LatLng(-23.564786, -46.652226),
        LatLng(-23.563085, -46.650531),
      ],
      consumeTapEvents: true,
      onTap: () {
        print("clicado na área");
      },
    );
    listaPolygons.add(polygon1);

    setState(() {
      _polygons = listaPolygons;
    });
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(-23.502436, -46.655005),
          zoom: 16,
          tilt: 0,
          bearing: 30,
        ),
      ),
    );
  }

  _carregarMarcadores() {
    Set<Marker> marcadoresLocais = {};
    Marker marcadorShopping = Marker(
      markerId: MarkerId("marcador-shopping"),
      position: LatLng(-23.563370, -46.652923),
      infoWindow: InfoWindow(title: "Shopping Cidade São Paulo"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      onTap: () {
        print("Shopping clicado");
      },
    );
    Marker marcadorCartorio = Marker(
      markerId: MarkerId("marcador-cartorio"),
      position: LatLng(-23.562868, -46.655874),
      infoWindow: InfoWindow(title: "Cartório de Notas"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      onTap: () {
        print("Cartório clicado");
      },
    );
    marcadoresLocais.add(marcadorShopping);
    marcadoresLocais.add(marcadorCartorio);

    setState(() {
      _marcadores = marcadoresLocais;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapas e Geolocalização"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: const Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-23.563370, -46.652923),
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _polygons,
        ),
      ),
    );
  }
}
