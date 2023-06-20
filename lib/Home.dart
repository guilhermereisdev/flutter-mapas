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

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
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
  void initState() {
    super.initState();
    _carregarMarcadores();
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
        ),
      ),
    );
  }
}
