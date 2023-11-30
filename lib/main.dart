import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric Authentication Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _authStatus = 'No autenticado';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      bool isBiometricAvailable = await _localAuthentication.canCheckBiometrics;

      if (isBiometricAvailable) {
        authenticated = await _localAuthentication.authenticate(
          localizedReason: 'Autenticación biométrica requerida',
        );
      } else {
        print('Hardware biométrico no disponible');
      }
    } on PlatformException catch (e) {
      print('Error en la autenticación biométrica: $e');
    } catch (e) {
      print('Error general: $e');
    }

    if (authenticated) {
      setState(() {
        _authStatus = 'Autenticado exitosamente';
      });
    } else {
      setState(() {
        _authStatus = 'Autenticación fallida';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Authentication Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Estado de la autenticación:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              _authStatus,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Autenticar con Huella Dactilar'),
            ),
          ],
        ),
      ),
    );
  }
}
