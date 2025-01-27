import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class mAddress extends StatefulWidget {
  final String userId;

  const mAddress({super.key, required this.userId});

  @override
  State<mAddress> createState() => _mAddressState();
}

class _mAddressState extends State<mAddress> {
  final TextEditingController _textController = TextEditingController();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission(Permission.location); // Pass the permission argument
  }

  @override
  void dispose() {
    _textController.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _requestPermission(Permission permission) async {
    if (await permission.request().isGranted) {
      print('Permission granted');
    } else if (await permission.isDenied) {
      _requestPermission(permission); // Recursive call
    } else if (await permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getLocation() async {
    try {
      final loc.LocationData locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(widget.userId).set({
        'latitude': locationResult.latitude,
        'longitude': locationResult.longitude,
        'name': 'John Doe', // Update dynamically if needed
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while adding location: $e')),
      );
    }
  }




  void _showChangeAddressSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheetContent();
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchField(),
              _buildUseCurrentLocationOption(),
              _buildAddAddressOption(),
              const SizedBox(height: 16),
              const Text("Recent Locations", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("No recent locations available.", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Search Location", style: TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search for restaurants or places...",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 26.0),
        ),
      ),
    );
  }

  Widget _buildUseCurrentLocationOption() {
    return GestureDetector(
      onTap: _getLocation,
      child: Row(
        children: const [
          Icon(Icons.my_location, color: Colors.blue, size: 18),
          SizedBox(width: 8),
          Text("Use Current Location", style: TextStyle(color: Colors.blue, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAddAddressOption() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add address functionality is not implemented.")),
      ),
      child: Row(
        children: const [
          Icon(Icons.add, color: Colors.blue, size: 18),
          SizedBox(width: 8),
          Text("Add Address", style: TextStyle(color: Colors.blue, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showChangeAddressSheet(context),
          child: const Text("Change Address"),
        ),
      ),
    );
  }
}
