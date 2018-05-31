
import 'package:Sequitor_dart/Sequitur_dart.dart';

class Guard extends Symboll {

    Rule r;

    Guard(Rule theRule) {
        r = theRule;
        value = "0";
        p = this;
        n = this;
    }

    @override
    void cleanUp() {
        Symboll.join(p, n);
    }

    @override
    bool isGuard() {
        return true;
    }

    @override
    void deleteDigram() {
        // Do nothing
    }

    @override
    bool check() {
        return false;
    }

    @override
    Guard clone() {
        Guard sym = new Guard(r);
        sym.p = p;
        sym.n = n;
        return sym;
    }
}