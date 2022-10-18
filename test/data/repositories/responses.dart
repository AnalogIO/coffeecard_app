import 'package:http/http.dart';

class Responses {
  static Response succeeding() => Response('', 200);

  static Response failing() => Response('', 400);

  static Response unauthorized({String msg = ''}) => Response(msg, 404);
}
