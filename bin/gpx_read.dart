import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';

class NullAttributeException implements Exception {
  String message;
  NullAttributeException(this.message);
}

class GpxPoint {
  late final double lat;
  late final double lon;
  late final double ele;

  GpxPoint(double lat, double lon, double ele)
      : this.lat = lat,
        this.lon = lon,
        this.ele = ele;
  static double distanceBetweenPoints(GpxPoint a, GpxPoint b) {
    return 1;
  }

  void printGpxPoint() {
    print("lat = $lat, lon = $lon, ele = $lon");
  }
}

class GpxRoute {
  List<GpxPoint> points = [];
  double length = 0;
  double eleGain = 0;
  double avgSpeed = 0;
  double estimatedTime = 0;

  GpxRoute();

  Future<void> loadFromGpxFile(String gpxPath) async {
    String gpxString = "";
    try {
      File gpxFile = File(gpxPath);
      gpxString = await gpxFile.readAsString(encoding: utf8);
    } catch (err) {
      print("Could not open file: ${err.toString()} ");
    }
    XmlDocument gpx = XmlDocument.parse(gpxString);
    Iterable<XmlElement> trkpts = gpx.findAllElements('trkpt');
    for (XmlElement trkpt in trkpts) {
      String? latS = trkpt.getAttribute('lat');
      String? lonS = trkpt.getAttribute('lon');
      String? eleS = trkpt.firstElementChild?.innerXml;

      if (latS == null || lonS == null || eleS == null) {
        throw NullAttributeException("attribute is null");
      } else {
        double lat = double.parse(latS);
        double lon = double.parse(lonS);
        double ele = double.parse(eleS);

        points.add(GpxPoint(lat, lon, ele));
      }
    }
  }
}

void main(List<String> args) {
  GpxRoute route = GpxRoute();
  route.loadFromGpxFile("data.gpx");
}
