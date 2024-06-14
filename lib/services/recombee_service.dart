import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class RecombeeService {
  final String baseUrl = 'https://rapi.recombee.com:443';
  final String apiId = 'tejwal2-tejwal';
  final String privateToken = 'XTgxc8Wi23cywmtpBG9hXr8OktqHpMbTwceTM6m8XHc2rDw84l9voSUxswJeUogi';

  String generateHmac(String message, String secret) {
    var key = utf8.encode(secret);
    var bytes = utf8.encode(message);

    var hmacSha1 = Hmac(sha1, key); // HMAC-SHA1
    var digest = hmacSha1.convert(bytes);

    return digest.toString();
  }

  Future<void> createUser(String userId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/users/$userId?hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/users/$userId?hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 201) {
      print('User created successfully');
    } else if (response.statusCode == 200) {
      print('User already exists');
    } else {
      print('Failed to create user: ${response.body}');
    }
  }

  Future<void> addUserData(String userId, String email, String city, List<String> interests) async {
    await createUser(userId);

    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/users/$userId?hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/users/$userId?hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'city': city,
          'interests': interests,
        }));

    if (response.statusCode == 200) {
      print('User data added successfully');
    } else {
      print('Failed to add user data: ${response.body}');
    }
  }

  Future<void> addInteraction(String userId, String itemId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/detailviews/?hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/detailviews/?hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'userId': userId,
      'itemId': itemId,
      'timestamp': timestamp,
      'cascadeCreate': true
    }));

    if (response.statusCode == 200) {
      print('Interaction added successfully');
    } else {
      print('Failed to add interaction: ${response.body}');
    }
  }

  Future<List<dynamic>> getUserRecommendations(String userId, int count) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/recomms/users/$userId/items/?count=$count&hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/recomms/users/$userId/items/?count=$count&hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('Recommendations: ${response.body}');
      return jsonDecode(response.body)['recomms'];
    } else {
      print('Failed to get recommendations: ${response.body}');
      return [];
    }
  }

  Future<List<dynamic>> getCityBasedRecommendations(String userId, int count) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=city_based_recommendation&hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=city_based_recommendation&hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('City-based Recommendations: ${response.body}');
      var decodedResponse = jsonDecode(response.body);
      print('Decoded Response: $decodedResponse');
      return decodedResponse['recomms'];
    } else {
      print('Failed to get city-based recommendations: ${response.body}');
      return [];
    }
  }

  Future<List<dynamic>> getInterestBasedRecommendations(String userId, int count) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=interest_based_recommendation&hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=interest_based_recommendation&hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('Interest-based Recommendations: ${response.body}');
      var decodedResponse = jsonDecode(response.body);
      print('Decoded Response: $decodedResponse');
      return decodedResponse['recomms'];
    } else {
      print('Failed to get interest-based recommendations: ${response.body}');
      return [];
    }
  }

  Future<List<dynamic>> getPropertyBasedRecommendations(String userId, int count) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final message = '/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=Property-Based_Recommendations&hmac_timestamp=$timestamp';
    final hmacSignature = generateHmac(message, privateToken);

    final url = Uri.parse('$baseUrl/$apiId/recomms/users/$userId/item-segments/?count=$count&scenario=Property-Based_Recommendations&hmac_timestamp=$timestamp&hmac_sign=$hmacSignature');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('Property-based Recommendations: ${response.body}');
      var decodedResponse = jsonDecode(response.body);
      print('Decoded Response: $decodedResponse');
      return decodedResponse['recomms'];
    } else {
      print('Failed to get property-based recommendations: ${response.body}');
      return [];
    }
  }

}
