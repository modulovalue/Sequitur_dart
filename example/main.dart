import 'package:sequitur_dart/sequitur_dart.dart';

void main() {
    Sequitur sequitur = new Sequitur()
        ..run('''I am Sam I am Sam Sam I am''');
    print(sequitur.outputString);
    Sequitur sequitur2 = new Sequitur()
        ..run('''pease porridge hot,\npease porridge cold,\npease porridge in the pot,\nnine days old.\n\nsome like it hot,\nsome like it cold,\nsome like it in the pot,\nnine days old.\n''');
    print(sequitur2.outputString);
    Sequitur sequitur3 = new Sequitur()
        ..run("okokokokokokokokokokokokok");
    print(sequitur3.outputString);
}
