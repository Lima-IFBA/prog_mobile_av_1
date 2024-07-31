import 'package:aula/estado.dart';
import 'package:flutter/material.dart';

class BuildsDestinyCard extends StatelessWidget {
  final dynamic buildDestiny;

  const BuildsDestinyCard({super.key, required this.buildDestiny});

  @override
  Widget build(BuildContext context) {
    String imagePath =
        "lib/recursos/imagens/${buildDestiny["buildDestiny"]["blobs"][0]["file"].toString()}";
    String avatarPath =
        "lib/recursos/imagens/${buildDestiny["class"]["avatar"]}";

    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(buildDestiny["_id"]);
      },
      child: Card(
        child: Column(children: [
          Image.asset(imagePath),
          Row(children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(avatarPath)),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(buildDestiny["class"]["name"],
                    style: const TextStyle(fontSize: 15))),
          ]),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(buildDestiny["buildDestiny"]["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
              child: Text(buildDestiny["buildDestiny"]["description"])),
          const Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                    "Popularidade: ${buildDestiny["popularity"].toString()}")),
            Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 5),
                child: Row(children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  Text(buildDestiny["likes"].toString())
                ])),
          ])
        ]),
      ),
    );
  }
}
