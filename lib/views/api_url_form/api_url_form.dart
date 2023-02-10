import 'package:comic_front/services/service_settings.dart';
import 'package:comic_front/views/library_selector/library_selector.dart';
import 'package:flutter/material.dart';

class ApiUrlForm extends StatefulWidget {
  const ApiUrlForm({super.key});

  @override
  ApiUrlFormState createState() => ApiUrlFormState();
}

class ApiUrlFormState extends State<ApiUrlForm> {
  final _formKey = GlobalKey<FormState>();
  String? _textFieldValue;
  String? lastValidatedUrl;
  String? lastRejectedUrl;

  Future<void> initiateAsyncUrlValidation(String url) async {
    if (await ServiceSettings.pingApiUrl(url)) {
      lastValidatedUrl = url;
    } else {
      lastRejectedUrl = url;
    }
    _formKey.currentState!.validate(); // Re-initiate validation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comic Back url',
                  hintText: 'xxx.xxx.xxx.xxx:8042',
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    _textFieldValue = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address of your comic back server';
                  } else {
                    if (lastValidatedUrl == value) {
                      ServiceSettings.apiUrl = _textFieldValue;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LibrarySelector()));
                      return null;
                    } else if (lastRejectedUrl == value) {
                      return 'Comic back url is invalid';
                    } else {
                      initiateAsyncUrlValidation(value);
                      return 'Url validation in progress';
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Execute action with the content of the text field
                    ServiceSettings.apiUrl = _textFieldValue;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LibrarySelector()));
                  }
                },
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
