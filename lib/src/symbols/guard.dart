import 'package:sequitur_dart/sequitur_dart.dart';

class Guard extends SequiturSymbol {

    Rule r;

    Guard(Rule theRule) {
        r = theRule;
        value = "0";
        p = this;
        n = this;
    }

    @override
    void cleanUp() {
        SequiturSymbol.join(p, n);
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