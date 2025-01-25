import 'package:flutter/material.dart';

class BookingModel with ChangeNotifier {
  String? _selectedHospital;
  String? _selectedDepartment;
  String? _selectedDoctor;
  String? _doctorTime;

  List<Map<String, String>> _hospitals = [];
  List<Map<String, String>> _departments = [];
  List<Map<String, String>> _doctors = [];
  List<String> _doctorTimes = [];

  String? get selectedHospital => _selectedHospital;
  String? get selectedDepartment => _selectedDepartment;
  String? get selectedDoctor => _selectedDoctor;
  String? get doctorTime => _doctorTime;
  List<Map<String, String>> get hospitals => _hospitals;
  List<Map<String, String>> get departments => _departments;
  List<Map<String, String>> get doctors => _doctors;
  List<String> get doctorTimes => _doctorTimes;

  void setSelectedHospital(String? value) {
    _selectedHospital = value;
    _selectedDepartment = null;
    _selectedDoctor = null;
    _doctorTime = null;
    _doctorTimes = [];
    notifyListeners();
  }

  void setSelectedDepartment(String? value) {
    _selectedDepartment = value;
    _selectedDoctor = null;
    _doctorTime = null;
    _doctorTimes = [];
    notifyListeners();
  }

  void setSelectedDoctor(String? value) {
    _selectedDoctor = value;
    _doctorTime = null;
    _doctorTimes = [];
    notifyListeners();
  }

  void setDoctorTime(String? value) {
    _doctorTime = value;
    notifyListeners();
  }

  void setHospitals(List<Map<String, String>> hospitals) {
    _hospitals = hospitals;
    notifyListeners();
  }

  void setDepartments(List<Map<String, String>> departments) {
    _departments = departments;
    notifyListeners();
  }

  void setDoctors(List<Map<String, String>> doctors) {
    _doctors = doctors;
    notifyListeners();
  }

  void setDoctorTimes(List<String> doctorTimes) {
    _doctorTimes = doctorTimes;
    notifyListeners();
  }
}
