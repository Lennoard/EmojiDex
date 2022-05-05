import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GetResponseUseCase {
  Future<Response> execute(String endpoint) async {
    var response = await http.get(Uri.parse(endpoint));
    if (response.statusCode != 200) {
      throw Exception('Failed to load emojis!');
    }
    return response;
  }
}
