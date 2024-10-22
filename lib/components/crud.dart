import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String _basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'mahmoud:mahmoud123456'));

Map<String, String> myHeaders = {
  'authorization': _basicAuth
};




class Crud {




  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data  ,headers:myHeaders );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    request.headers.addAll(myHeaders) ;
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value ;
    });
    var myrequest = await request.send();

    var response = await http.Response.fromStream(myrequest) ;
    if (myrequest.statusCode == 200){
      return jsonDecode(response.body) ;
    }else {
      print("Error ${myrequest.statusCode}") ;
    }
  }

}