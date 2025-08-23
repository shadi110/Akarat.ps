import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Create
  Future<dynamic> create(String url, Map<String, dynamic> data) async {
    print('url is ${url} and data is ${data}');
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Read (Get all or by ID)
  Future<dynamic> read(String url, {String? id}) async {
    final fullUrl = id != null ? "$url/$id" : url;
    print('Get request url ${fullUrl}');
    final response = await http.get(Uri.parse(fullUrl));
    return _handleResponse(response);
  }

  // Update
  Future<dynamic> update(String url, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Delete
  Future<dynamic> delete(String url, String id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return _handleResponse(response);
  }

  Future<dynamic> uploadFile(String url, File file, {String fieldName = "file"}) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('response is ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception("Failed to upload file: ${response.statusCode}");
    }
  }

  Future<List<String>> uploadFiles(
      String url,
      List<File> files, {
        String fieldName = "files",
      }) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('response is ${response.body} status ${response.statusCode} ');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('entered here in success');

      // Parse the JSON response - it's directly an array of strings
      final parsedResponse = json.decode(response.body);

      // Since we know it's a List, cast it to List<String>
      if (parsedResponse is List) {
        return parsedResponse.cast<String>();
      } else {
        throw Exception("Unexpected response format. Expected List, got: ${parsedResponse.runtimeType}");
      }
    } else {
      print('entered here in not success');
      throw Exception("Failed to upload files: ${response.statusCode}");
    }
  }

  // Handle API Response
  dynamic _handleResponse(http.Response response) {
    print('Response status ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.statusCode}, ${response.body}");
    }
  }
}
