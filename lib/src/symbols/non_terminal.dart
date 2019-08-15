import 'package:sequitur_dart/sequitur_dart.dart';

class NonTerminal extends SequiturSymbol {

    Rule r;

    NonTerminal(this.r) {
        r.countOfRules++;
        value = (SequiturSymbol.numTerminals + r.nonTerminalIdentificationRuleNumber).toString();
        p = null;
        n = null;
    }

    /**
     * Extra cloning method necessary so that
     * count in the corresponding Rule is
     * increased.
     */

    NonTerminal clone() {
        NonTerminal sym = new NonTerminal(r);
        sym.p = p;
        sym.n = n;
        return sym;
    }

    @override
    void cleanUp() {
        SequiturSymbol.join(p, n);
        deleteDigram();
        r.countOfRules--;
    }

    bool isNonTerminal() {
        return true;
    }

    /**
     * This Symbol is the last reference to
     * its Rule. The contents of the Rule
     * are substituted in its place.
     */

    void expand() {
        SequiturSymbol.join(p, r.first());
        SequiturSymbol.join(r.last(), n);

        // Bug fix (21.8.2012): digram consisting of the last element of
        // the inserted Rule and the first element after the inserted Rule
        // must be put into the hash table (Simon Schwarzer)

        SequiturSymbol.theDigrams[r.last()] = r.last();

        // Necessary so that garbage collector
        // can delete Rule and Guard.

        r.theGuard.r = null;
        r.theGuard = null;
    }
}