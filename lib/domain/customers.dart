import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Customer {
  Future<http.Response> registerCustomer(
    String name,
    String email,
    String address,
    String phoneNumber,
  ) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/nasabah');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<dynamic>> getCustomer() async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/nasabah');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<dynamic>> getBalance() async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/saldo');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> deleteCustomer(String id) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/nasabah/$id');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }

  Future<http.Response> updateCustomer(
    String id,
    String name,
    String email,
    String address,
    String phoneNumber,
  ) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/nasabah/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<List<dynamic>> getHistory() async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/tabung');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<dynamic>> getLiquidity() async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/saldokeluar');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<http.Response> liquidityCustomer(
    String name,
    double amount,
    String note,
  ) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/tariksaldo');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'amount': amount,
      'note': note,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception(response.body);
    }
  }
}
