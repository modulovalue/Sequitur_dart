
import 'package:Sequitor_dart/Sequitur_dart.dart';

class Terminal extends Symboll {

    Terminal(String theValue) {
        value = theValue;
        p = null;
        n = null;
    }

    @override
    Terminal clone() {
        Terminal sym = new Terminal(value);
        sym.p = p;
        sym.n = n;
        return sym;
    }

    void cleanUp() {
        Symboll.join(p, n);
        deleteDigram();
    }
}
