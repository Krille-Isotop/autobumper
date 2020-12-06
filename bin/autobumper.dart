import 'package:args/args.dart';
import 'package:autobumper/autobumper.dart' as autobumper;

void main(List<String> arguments) {
  final argParser = ArgParser()..addOption('type')..addOption('message');
  final argResults = argParser.parse(arguments);
  autobumper.bump(argResults['type'], argResults['message']);
}
