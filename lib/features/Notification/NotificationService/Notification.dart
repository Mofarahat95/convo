import 'dart:convert';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    final Map<String,String> serviceAccountJson =<String,String>{
      "type": "service_account",
      "project_id": "convo-2b935",
      "private_key_id": "68b40c4edf2b338a3444eadbd2802c4958791303",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOc4eCEggTsebE\ngc577FuBr/um3iVFqoiu8EhbFrd0a1CEvOgeslqVfJPR+8GA0DetDq8BCp3YZVY0\n0LDb3KvU+PW3+waOoOaZYxOJmwzPw6P/2yfrlTYsMObIG/4o+wrmkKXll/prmhQu\n2Fci+EVhpBccRRbrMfnT83KXKDn/bPBoHFPP75BGUmozRx3CVWt/vlelr/aR3iqO\nyLkTaoJoQag6+8u0IJPdNeSYI8b27/9bQKIs9rtnzk93HWAxv+uChn5Foafh6t/P\nVfoJfWTIBAsfuAF71gHn+ES5SpnP1tVLaLo3tgwpSEtNWrH/Itn0PPgU+dNK6/JF\nklmQS3R9AgMBAAECggEAFtas/PSltBgQIVkC0K67CMPBIRqeIPDWohOuzXTb4qMk\niyqiuxKb9sGLUMV7CJcAMcLYFVNpVtEPElSr3Aazc6H+/NVmSkz+daWCOczPRASu\nldVWuzcMgSL/xM9j9IChGhSSZa3EZDbtWKlSKmowsraGX/g8qtQigRIDcTlgASOH\nK26Xj34V0lK7BjKO6HszxCIuDNr8PBiOW8xaLMQgJsuT4eAIADdcPVeQLCaRaTWU\neiwvBBDIplF7RzRzbAYivZHvl02uN7z7mC08tdCvGish/jVu3DpQxzzdXThDTtgp\nliUjCVuVQZR+pjYjc2yiwWQyjSprvjytza7oKo3vQQKBgQDrtNNZH3m6QG6bFhBv\nJ7ZfK9MzlZwpNWzOG7dcZUj06GWHLIqQf/U70xyPKn6c8rFHD1HbRHaeOeHeqCkp\n13of8s9N2i37b/IgsoVbDrfrc99AoDIQp29pnF+0aIB+PHyIOR1LxWnMP13rwzun\n8+kyyrzkdUaplhkaDl6MBoZwCQKBgQDgOeWCoZJkGPAevdHeBj5KAMzEefjJXkBD\nggOpngTZLB0BcAsMKWMMKwPh1RQN2Mc9oyA9eLcIGHNFEel0saVjehTusuAFzQer\nysuBSB9XeKV0ybH4ZeiScxXk6os8lkRSo79rZG8vawTZDYS+tP6JgB5E3nKDTP8N\nPS4WgiOV1QKBgFCwN0WkK8Sht/tpQzj6DElqNEPNbIcC3ft0q4F6vs3wHIl4qvqq\ngyX2sCkmb++EeUGNMgVw23Zw9CyHvoevVwRG18ab8O/JM8cTteklEbsNkJiL/neL\nCe3KdUzKFWqhhDQR8UB2FTCxZJKH5A0rx2H221EOAKGfW3p6/szKkw0ZAoGAfodt\nQdfW+fEwnshSw00WnT/yTPTfNRKghPe7BV4MMli4TXViZox8PgOP/0H0PRQU6m1A\n5i9WaZUShuliqd0NDSN46HG8BMn8CC85w0xlk0CbbVnbueYX5XxX4IOR6rCJAXEx\ntXJJY6Kqa6k7PTp5YDIR4p78U6eBTYE2nrD1T7kCgYEA0t2Xf8xjnSvAkj85p7tj\n3c/7AVonyeQ0Yv+fyNZ61HtVP2y5DcRgkgR925f7lrIYDcLGKeWQgt6aNfshhP/Y\nvdAnG+XTQEkLuLAHkWOJ4RQFO1RDblre8vPraGoT7rJth241XFvzuoDUJmP8Ujvj\n2gqqvthGc14sBJODnLY6JDA=\n-----END PRIVATE KEY-----\n",
      "client_email": "convo-572@convo-2b935.iam.gserviceaccount.com",
      "client_id": "101289107107872461282",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/convo-572%40convo-2b935.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    } ;


    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/convo-2b935/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": AppRoutes.chatRoute,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }
}