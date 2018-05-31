import 'package:Sequitor_dart/Sequitur_dart.dart';

void main() {
    Sequitur sequitur = new Sequitur()
        ..run('''I am Sam I am Sam Sam I am''');
    print(sequitur.outputString);
}
