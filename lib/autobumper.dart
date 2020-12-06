import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

ArgResults argResults;

void bump(String bumpType, String message) {
  final pubspecFile = File('pubspec.yaml');
  final changelogFile = File('CHANGELOG.md');
  pubspecFile
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .forEach((line) {
    if (line.contains('version: ')) {
      final version = line.substring(9);
      final newVersion = increment(version, bumpType);

      changelogFile.readAsString().then((content) {
        final newContent = '# $newVersion \n\n - $message \n\n $content';
        changelogFile.writeAsStringSync(newContent, mode: FileMode.write);
      });

      pubspecFile.readAsString().then((content) {
        pubspecFile
            .writeAsStringSync(content.replaceFirst(version, newVersion));
        print('Bumped from $version to $newVersion');
      });
    }
  });
}

String increment(String version, String bumpType) {
  final semverSections = version.split('.');

  switch (bumpType) {
    case 'patch':
      semverSections[2] = (int.parse(semverSections[2]) + 1).toString();
      version = semverSections.join('.');
      break;
    case 'minor':
      semverSections[1] = (int.parse(semverSections[1]) + 1).toString();
      semverSections[2] = '0';
      version = semverSections.join('.');
      break;
    case 'major':
      semverSections[0] = (int.parse(semverSections[0]) + 1).toString();
      semverSections[1] = '0';
      semverSections[2] = '0';
      version = semverSections.join('.');
      break;
  }

  return version;
}
