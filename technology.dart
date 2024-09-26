import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class technology extends StatefulWidget {
  const technology({super.key});

  @override
  State<technology> createState() => _technologyState();
}

class _technologyState extends State<technology> {
  String? _selectedValue; // Store selected value
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];
  String? _selectedField;
  String? _selectecTechField;
  List<String> fields = [
    "Software Development",
    "Networking",
    "CyberSecurity",
    "Data Science",
    "Artificial intelligence",
  ];
  Map<String, List<String>> techfieldMapping = {
    "Software Development": [
      "Web Development",
      "Mobile App Development",
      "Game Development",
      "Database Management",
      "Cloud Computing",
    ],
  "Networking": [
      'Network Engineering',
      'Network security',
      'wireless Networking',
    ],
    "CyberSecurity": [
      "Ethical Hacking",
      "Penetration Testing",
      "Incident Response",
      "Digital Forensics",
    ],
  "Data Science" : [
      'Data Analysis',
      'Data Mining',
      'Machine Learning',
    ],
    "Artificial intelligence": [
      'Application of AI',
      'History of AI',
      'Types of AI',
    ]
  };

  final List<String> _fileNames = [];
  final List<Uint8List?> _fileBytes = [];
  final List<html.File?> _htmlFiles = [];
  bool _isUploading = false;
  bool _selecting = false;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null) {
      setState(() {
        _fileNames.clear();
        _fileBytes.clear();
        _htmlFiles.clear();
        _selecting = true;

        for (var file in result.files) {
          _fileNames.add(file.name);
          if (html.window.navigator.userAgent.contains('Chrome') ||
              html.window.navigator.userAgent.contains('Firefox')) {
            _fileBytes.add(file.bytes);
            _htmlFiles.add(html.File(file.bytes!, file.name));
          }
        }
        _selecting = false;
      });
    }
  }

  Future<void> _uploadFiles() async {
    if (_fileBytes.isEmpty) return;

    setState(() {
      _isUploading = true; // Start uploading
    });

    try {
      for (int i = 0; i < _fileBytes.length; i++) {
        final fileName = _fileNames[i];
        final blob = html.Blob([_htmlFiles[i]!]);
        final storageRef =
            FirebaseStorage.instance.ref('uploads/').child(fileName);
        await storageRef.putBlob(blob);
      }

      // Reset the state
      if (mounted) {
        setState(() {
          _fileNames.clear();
          _fileBytes.clear();
          _htmlFiles.clear();
          _isUploading = false; // Reset upload state
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload successful!')));
    } catch (e) {
      print('Error uploading files: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload failed!')));
      if (mounted) {
        setState(() {
          _isUploading = false; // Reset upload state on error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technology PDFs')),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(40),
                          value: _selectedField,
                          hint: const Text('Select Collection of Upload'),
                          items: fields.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedField =
                                  newValue; // Update the selected value
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(40),
                          value: _selectedValue,
                          hint: const Text('Select Collection of Upload'),
                          items: techfieldMapping[_selectedField]?.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue =
                                  newValue; // Update the selected value
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(40),
                          value: _selectedValue,
                          hint: const Text('Select Collection of Upload'),
                          items: _items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue =
                                  newValue; // Update the selected value
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Selected Files'),
                  controller:
                      TextEditingController(text: _fileNames.join(', ')),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: const Text('Select PDF Files'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadFiles,
                  child: const Text('Upload PDFs'),
                ),
                // Show progress indicator if uploading
                if (_isUploading || _selecting)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
