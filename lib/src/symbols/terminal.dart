import 'package:sequitur_dart/sequitur_dart.dart';

class Terminal extends SequiturSymbol {

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
        SequiturSymbol.join(p, n);
        deleteDigram();
    }
}
