import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testlab/controllers/auth_service.dart';
import 'package:testlab/models/product_model.dart';
import 'package:testlab/providers/usar_providers.dart';
import 'package:http/http.dart' as http;
import 'package:testlab/varbles.dart';

class ProductController {
  final _AuthService = AuthService();

  Future<List<ProductModel>> getProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/product/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${accessToken}", // ใส่ accessToken ใน header
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Decode the response and map it to ProductModel objects
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception(
            'Refresh token expired. Please login again.'); // เพิ่ม throw Exception
      } else if (response.statusCode == 403) {
        // Refresh token and retry
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getProducts(context);
      } else {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }
    } catch (err) {
      // If the request failed, throw an error
      print(err);
      throw Exception('Failed to load products');
    }
  }

  Future<http.Response> InsertProduct(BuildContext context, String productName,
      String productType, double price, String unit) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> InsertData = {
      "product_name": productName,
      "product_type": productType,
      "price": price,
      "unit": unit,
    };
    try {
      // Make POST request to insert the product
      final response = await http.post(
        Uri.parse(
            "$apiURL/api/product"), // Replace with the correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(InsertData),
      );

      // Handle successful product insertion
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
        return response; // ส่งคืน response เมื่อเพิ่มสินค้าสำเร็จ
      } else if (response.statusCode == 403) {
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await InsertProduct(
            context, productName, productType, price, unit);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      // Catch and print any errors during the request
      throw Exception('Failed to insert product');
    }
  }

  Future<http.Response> updateProduct(BuildContext context, String productId,
      String productName, String productType, double price, String unit) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "product_name": productName,
      "product_type": productType,
      "price": price,
      "unit": unit,
    };

    try {
      // Make PUT request to update the product
      final response = await http.put(
        Uri.parse(
            "$apiURL/api/product/$productId"), // Replace with the correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(updateData),
      );
      // Handle successful product update
      if (response.statusCode == 200) {
        print("Product updated successfully!");
        return response; // ส่งคืน response
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken =
            userProvider.accessToken; // Update the accessToken after refresh

        return await updateProduct(
            context, productId, productName, productType, price, unit);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      throw Exception('Failed to update product');
    }
  }

  Future<http.Response> deleteProduct(
      BuildContext context, String productId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/product/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("Product deleted successfully!");
        return response; // ส่งคืน response
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await deleteProduct(context, productId);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}
