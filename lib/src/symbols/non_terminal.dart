
import 'package:Sequitor_dart/Sequitur_dart.dart';

class NonTerminal extends Symboll {

    Rule r;

    NonTerminal(this.r) {
        r.countOfRules++;
        value = (Symboll.numTerminals + r.nonTerminalIdentificationRuleNumber).toString();
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
        Symboll.join(p, n);
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
        Symboll.join(p, r.first());
        Symboll.join(r.last(), n);

        // Bug fix (21.8.2012): digram consisting of the last element of
        // the inserted Rule and the first element after the inserted Rule
        // must be put into the hash table (Simon Schwarzer)

        Symboll.theDigrams[r.last()] = r.last();

        // Necessary so that garbage collector
        // can delete Rule and Guard.

        r.theGuard.r = null;
        r.theGuard = null;
    }
}