import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smag_app/core/extensions/context_utils.dart';
import 'package:smag_app/core/utils/app_colors.dart';
import 'package:smag_app/core/utils/assets.dart';
import 'package:smag_app/features/map_selection/presentation/components/map_tool_divider.dart';

class MapDrawingScreen extends StatefulWidget {
  const MapDrawingScreen({super.key});

  @override
  _MapDrawingScreenState createState() => _MapDrawingScreenState();
}

class _MapDrawingScreenState extends State<MapDrawingScreen> {
  GoogleMapController? _controller;

  // Drawing state
  bool _isDrawingPolygon = false;
  bool _isDrawingPolyline = false;
  final List<LatLng> _polygonPoints = [];
  final List<LatLng> _polylinePoints = [];

  // Map data
  final Set<Polygon> _polygons = {};
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  // Current drawing color
  final Color _currentColor = AppColors.statusYellow;

  // Camera position (you can adjust this to your desired location)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo, Egypt coordinates
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            initialCameraPosition: _initialPosition,
            polygons: _polygons,
            polylines: _polylines,
            markers: _markers,
            onTap: _onMapTapped,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Left side drawing tools
          Positioned(
            left: 20,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Polyline tool
                      _buildToolButton(
                        isUseDecoration: false,
                        svgPath: Assets.genIconsPolyline,
                        isActive: _isDrawingPolyline,
                        onPressed: _togglePolylineDrawing,
                      ),
                      const MapToolDivider(),
                      // Polygon tool
                      _buildToolButton(
                        isUseDecoration: false,
                        svgPath: Assets.genIconsPolygon,
                        isActive: _isDrawingPolygon,
                        onPressed: _togglePolygonDrawing,
                      ),

                      const MapToolDivider(),
                      // Clear tool
                      _buildToolButton(
                        isUseDecoration: false,
                        icon: Icons.clear,
                        isActive: false,
                        onPressed: _clearDrawing,
                      ),

                      const MapToolDivider(),
                      // Undo tool
                      _buildToolButton(
                        isUseDecoration: false,
                        icon: Icons.undo,
                        isActive: false,
                        onPressed: _undoLastPoint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right side zoom controls
          Positioned(
            right: 20,
            bottom: 200,
            child: Column(
              children: [
                _buildToolButton(
                  svgPath: Assets.genIconsGps,
                  isActive: false,
                  onPressed: _goToCurrentLocation,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildToolButton(
                        isUseDecoration: false,
                        svgPath: Assets.genIconsPlus,
                        isActive: false,
                        onPressed: _zoomIn,
                      ),
                      const MapToolDivider(),
                      _buildToolButton(
                        isUseDecoration: false,
                        svgPath: Assets.genIconsMinus,
                        isActive: false,
                        onPressed: _zoomOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom action buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Add Coordinates button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addCoordinates,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add Coordinates',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmDrawing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      context.trans.confirm,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Drawing mode indicator
          if (_isDrawingPolygon || _isDrawingPolyline)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isDrawingPolygon ? 'Drawing Polygon' : 'Drawing Polyline',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required bool isActive,
    required VoidCallback onPressed,
    IconData? icon,
    String? svgPath,
    bool isUseDecoration = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: !isUseDecoration
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
      child: InkWell(
        overlayColor: const WidgetStatePropertyAll(AppColors.secondary),
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: svgPath != null
            ? SvgPicture.asset(
                svgPath,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : AppColors.black,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.black,
                size: 20,
              ),
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    if (_isDrawingPolygon) {
      setState(() {
        _polygonPoints.add(position);
        _updatePolygonPreview();
      });
    } else if (_isDrawingPolyline) {
      setState(() {
        _polylinePoints.add(position);
        _updatePolylinePreview();
      });
    }
  }

  void _togglePolygonDrawing() {
    setState(() {
      _isDrawingPolygon = !_isDrawingPolygon;
      if (_isDrawingPolygon) {
        _isDrawingPolyline = false;
        _polygonPoints.clear();
        _polylinePoints.clear();
        _clearPreview();
      } else {
        _clearPreview();
      }
    });
  }

  void _togglePolylineDrawing() {
    setState(() {
      _isDrawingPolyline = !_isDrawingPolyline;
      if (_isDrawingPolyline) {
        _isDrawingPolygon = false;
        _polygonPoints.clear();
        _polylinePoints.clear();
        _clearPreview();
      } else {
        _clearPreview();
      }
    });
  }

  void _updatePolygonPreview() {
    if (_polygonPoints.length > 2) {
      _polygons
        ..removeWhere((p) => p.polygonId.value == 'preview')
        ..add(
          Polygon(
            polygonId: const PolygonId('preview'),
            points: _polygonPoints,
            strokeColor: _currentColor,
            strokeWidth: 2,
            fillColor: _currentColor.withOpacity(0.3),
          ),
        );
    }

    // Add markers for points
    _updatePointMarkers(_polygonPoints);
  }

  void _updatePolylinePreview() {
    if (_polylinePoints.length > 1) {
      _polylines
        ..removeWhere((p) => p.polylineId.value == 'preview')
        ..add(
          Polyline(
            polylineId: const PolylineId('preview'),
            points: _polylinePoints,
            color: _currentColor,
            width: 3,
          ),
        );
    }

    // Add markers for points
    _updatePointMarkers(_polylinePoints);
  }

  void _updatePointMarkers(List<LatLng> points) {
    // Clear existing point markers
    _markers.removeWhere((m) => m.markerId.value.startsWith('point_'));

    // Add new point markers
    for (var i = 0; i < points.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('point_$i'),
          position: points[i],
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(title: 'Point ${i + 1}'),
        ),
      );
    }
  }

  void _clearPreview() {
    setState(() {
      _polygons.removeWhere((p) => p.polygonId.value == 'preview');
      _polylines.removeWhere((p) => p.polylineId.value == 'preview');
      _markers.removeWhere((m) => m.markerId.value.startsWith('point_'));
    });
  }

  void _clearDrawing() {
    setState(() {
      _polygonPoints.clear();
      _polylinePoints.clear();
      _polygons.clear();
      _polylines.clear();
      _markers.clear();
      _isDrawingPolygon = false;
      _isDrawingPolyline = false;
    });
  }

  void _undoLastPoint() {
    setState(() {
      if (_isDrawingPolygon && _polygonPoints.isNotEmpty) {
        _polygonPoints.removeLast();
        _updatePolygonPreview();
      } else if (_isDrawingPolyline && _polylinePoints.isNotEmpty) {
        _polylinePoints.removeLast();
        _updatePolylinePreview();
      }
    });
  }

  void _confirmDrawing() {
    if (_isDrawingPolygon && _polygonPoints.length > 2) {
      setState(() {
        _polygons.add(
          Polygon(
            polygonId:
                PolygonId('polygon_${DateTime.now().millisecondsSinceEpoch}'),
            points: List.from(_polygonPoints),
            strokeColor: _currentColor,
            strokeWidth: 2,
            fillColor: _currentColor.withOpacity(0.3),
          ),
        );
        _polygonPoints.clear();
        _isDrawingPolygon = false;
        _clearPreview();
      });
    } else if (_isDrawingPolyline && _polylinePoints.length > 1) {
      setState(() {
        _polylines.add(
          Polyline(
            polylineId:
                PolylineId('polyline_${DateTime.now().millisecondsSinceEpoch}'),
            points: List.from(_polylinePoints),
            color: _currentColor,
            width: 3,
          ),
        );
        _polylinePoints.clear();
        _isDrawingPolyline = false;
        _clearPreview();
      });
    }

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Drawing confirmed!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addCoordinates() {
    // This method can be used to manually add coordinates
    // You can implement a dialog to input coordinates manually
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Coordinates'),
        content: const Text(
          'Feature to manually add coordinates can be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    // Implement location service to get current position
    // For now, just center on a default location
    if (_controller != null) {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(_initialPosition),
      );
    }
  }

  Future<void> _zoomIn() async {
    if (_controller != null) {
      await _controller!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  Future<void> _zoomOut() async {
    if (_controller != null) {
      await _controller!.animateCamera(CameraUpdate.zoomOut());
    }
  }
}
