import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition _posicaoCamera = const CameraPosition(
    target: LatLng(-20.17242854899768, -44.87074784952123),
    zoom: 20,
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    // _carregarPoligonos();
    // _carregarPolylines();
    // _recuperarLocalizacaoAtual();
    // _movimentarCamera();
    _adicionarListenerLocalizacao();
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _adicionarListenerLocalizacao() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        print(
            'Position is ${position.latitude.toString()}, ${position.longitude.toString()}');
        setState(() {
          _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          );
        });
        _movimentarCamera();
      } else {
        print("Position is null");
      }
    });
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );
    setState(() {
      _posicaoCamera = CameraPosition(
        // target: LatLng(-20.17242854899768, -44.87074784952123),
        target: LatLng(position.latitude, position.longitude),
        zoom: 20,
      );
    });
    // print("Localização atual: $position");
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_posicaoCamera),
    );
  }

  _irParaLocalizacaoAtual() {
    _recuperarLocalizacaoAtual();
    _movimentarCamera();
  }

  _carregarPolylines() {
    Set<Polyline> listaPolylines = {};
    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyline"),
      color: Colors.red,
      width: 20,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: const [
        LatLng(-23.561816, -46.652044),
        LatLng(-23.563625, -46.653642),
        LatLng(-23.564786, -46.652226),
      ],
      consumeTapEvents: true,
      onTap: () {
        print("clicado na área");
      },
    );
    listaPolylines.add(polyline);

    setState(() {
      _polylines = listaPolylines;
    });
  }

  _carregarPoligonos() {
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
      polygonId: const PolygonId("polygon1"),
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

  _carregarMarcadores() {
    Set<Marker> marcadoresLocais = {};
    Marker marcadorShopping = Marker(
      markerId: const MarkerId("marcador-shopping"),
      position: const LatLng(-23.563370, -46.652923),
      infoWindow: const InfoWindow(title: "Shopping Cidade São Paulo"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      onTap: () {
        print("Shopping clicado");
      },
    );
    Marker marcadorCartorio = Marker(
      markerId: const MarkerId("marcador-cartorio"),
      position: const LatLng(-23.562868, -46.655874),
      infoWindow: const InfoWindow(title: "Cartório de Notas"),
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
        onPressed: _irParaLocalizacaoAtual,
        child: const Icon(Icons.account_circle_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _polygons,
          polylines: _polylines,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
