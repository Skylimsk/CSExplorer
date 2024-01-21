import "dart:io";

import "package:csexplorer/customWidget/CustomAppBar.dart";
import "package:csexplorer/data/model/university.dart";
import "package:csexplorer/data/repositories/university_repo.dart";
import "package:csexplorer/presentation/screens/Universities/university_details.dart";
import "package:flutter/material.dart";
class UniversityMain extends StatefulWidget {
  const UniversityMain({super.key});
  @override
  State<UniversityMain> createState() => _UniversityMainState();
}
class _UniversityMainState extends State<UniversityMain> {
  final UniversityRepo _universityRepo = UniversityRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Tertiary Institution",
          description: "Public and Private University/College/Vocational",
          colour: Colors.indigo.shade700,),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<University>>(
          future: _universityRepo.fetchUniList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No university found'),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  University university = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UniversityDetails(
                                  universityArguments: university)));
                    },
                    child: Container(
                      width: 240,
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _buildImageWidget(
                                    university.image)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: SizedBox(
                              height: 100,
                              width: 230,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      university.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(university.description)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

Widget _buildImageWidget(String imagePath) {
    // ignore: unnecessary_null_comparison
    if (imagePath == null || imagePath.isEmpty) {
      return Container();
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
  }