import 'package:sequitur_dart/sequitur_dart.dart';

class Rule {

    static int beginningAndEndGuardSymbolRule = 0;

    /// Counter keeps track of how many
    /// times the Rule is used in the
    /// grammar.
    Guard theGuard;
    int countOfRules;
    int nonTerminalIdentificationRuleNumber;
    int printingIndex;

    Rule() {
        nonTerminalIdentificationRuleNumber = beginningAndEndGuardSymbolRule;
        beginningAndEndGuardSymbolRule++;
        theGuard = new Guard(this);
        countOfRules = 0;
        printingIndex = 0;
    }

    SequiturSymbol first() {
        return theGuard.n;
    }

    SequiturSymbol last() {
        return theGuard.p;
    }

    String getRules() {
        List<Rule> rules = new List<Rule>();
        Rule currentRule;
        Rule referedTo;
        SequiturSymbol sym;
        int index;
        int processedRules = 0;
        StringBuffer text = new StringBuffer();
//        int charCounter = 0;

        text.write("Usage\tRule\n");
        rules.add(this);
        while (processedRules < rules.length) {
            currentRule = rules.elementAt(processedRules);
            text.write(" ");
            text.write(currentRule.countOfRules);
            text.write("\tR");
            text.write(processedRules);
            text.write(" -> ");
            for (sym = currentRule.first(); (!sym.isGuard()); sym = sym.n) {
                if (sym.isNonTerminal()) {
                    referedTo = (sym as NonTerminal).r;
                    if ((rules.length > referedTo.printingIndex) &&
                        ((rules.elementAt(referedTo.printingIndex) as Rule) ==
                            referedTo)) {
                        index = referedTo.printingIndex;
                    } else {
                        index = rules.length;
                        referedTo.printingIndex = index;
                        rules.add(referedTo);
                    }
                    text.write('R');
                    text.write(index);
                } else {
                    if (sym.value == ' ') {
                        text.write('_');
                    } else {
                        if (sym.value == '\n') {
                            text.write("\\n");
                        } else
                            text.write(sym.value);
                    }
                }
                text.write(' ');
            }
            text.write('\n');
            processedRules++;
        }
        return text.toString();
    }
}