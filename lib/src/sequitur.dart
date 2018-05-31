import 'package:Sequitor_dart/Sequitur_dart.dart';

class Sequitur {

    Rule rootRule;
    String outputString;

    void run(String input) {

        Rule firstRule = new Rule();
        int i;
        // Reset number of rules and Hashtable.
        Rule.beginningAndEndGuardSymbolRule = 0;
        Symboll.theDigrams.clear();
        for (i = 0; i < input.length; i++) {
            firstRule
                .last()
                .insertAfter(
                new Terminal(input[i])
            );
            firstRule
                .last()
                .p
                .check();
        }

        rootRule = firstRule;
        outputString = firstRule.getRules();
    }
}