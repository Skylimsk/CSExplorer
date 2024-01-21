import "dart:io";

import "package:csexplorer/data/model/scholarship.dart";
import "package:csexplorer/data/repositories/scholarship_repo.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class EditScholarshipPage extends StatefulWidget {
  final Scholarship scholarship;

  EditScholarshipPage({required this.scholarship});

  @override
  _EditScholarshipPageState createState() => _EditScholarshipPageState();
}

class _EditScholarshipPageState extends State<EditScholarshipPage> {
  final TextEditingController editProviderNameController = TextEditingController();
  final TextEditingController editDescriptionController = TextEditingController();
  final TextEditingController editApplicationRequirementController = TextEditingController();
  final TextEditingController editlinkController = TextEditingController();
  final TextEditingController editImageController = TextEditingController();
  final ScholarshipRepo scholarshipRepo = ScholarshipRepo();

  List<TextEditingController> _shcolarshipControllers = [];
  
  XFile? _image;
    String imagePathAsString = "";
    Future<void> _getImage() async {
      // ignore: no_leading_underscores_for_local_identifiers
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _image = image;
          imagePathAsString = _image?.path ?? '';
        });
      }
    }
  @override
  void initState() {
    super.initState();
    editProviderNameController.text = widget.scholarship.providerName;
    editDescriptionController.text = widget.scholarship.description;
    editApplicationRequirementController.text = widget.scholarship.applicationRequirement;
    editlinkController.text = widget.scholarship.link;  
    editImageController.text = widget.scholarship.image;
  }

  Future<void> _updateScholarship() async {
    String editedProviderName = editProviderNameController.text;
    String editedDescription = editDescriptionController.text;
    String editedApplicationRequirement = editApplicationRequirementController.text;
    String editedlink = editlinkController.text;
    String editedImage = editImageController.text;

    if (editedProviderName.isNotEmpty) {
      Scholarship editedScholarship = Scholarship(
        providerName: editedProviderName,
        description: editedDescription,
        applicationRequirement: editedApplicationRequirement,
        link: editedlink,
        image: editedImage,  
      );

      await scholarshipRepo.editScholarship(
          widget.scholarship.id, editedScholarship);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit a scholarship"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Provider Name",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextField(
                controller: editProviderNameController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextFormField(
                  controller: editDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Description of the scholarship')),
              const SizedBox(height: 20),
              Text("Application Requirements",
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                  controller: editApplicationRequirementController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Any specific academic or financial requirements')),
              const SizedBox(height: 20),
              Text(
                "Link to official or reference website",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextField(
                controller: editlinkController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            const SizedBox(height: 20),
            Text("Update image of the scholarship",
                style: TextStyle(color: Colors.grey[600]
                ),
             ),
             const SizedBox(height: 5),
              Container(
                height: 100,
                width: double.infinity, // Make the button full width
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      )
                    : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade600, 
                          width: 1.0, 
                        ),
                      ),
                      child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          child: InkWell(
                            onTap: _getImage,
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.indigo.shade700
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Select Image",
                                    style: TextStyle(
                                      color: Colors.indigo.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
              ),              
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateScholarship();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  
  }
}
