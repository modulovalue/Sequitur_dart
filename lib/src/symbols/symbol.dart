import 'dart:collection';

import 'package:Sequitor_dart/Sequitur_dart.dart';
import 'package:Sequitor_dart/src/Clonable.dart';

abstract class Symboll implements Clonable {

    static const int numTerminals = 100000;

    static const int prime = 2265539;
    static HashMap theDigrams = new HashMap();

    String value;
    Symboll p;
    Symboll n;

    /**
     * Links two symbols together, removing any old
     * digram from the hash table.
     */
    static void join(Symboll left, Symboll right) {
        if (left.n != null) {
            left.deleteDigram();

            // Bug fix (21.8.2012): included two if statements, adapted from
            // sequitur_simple.cc, to deal with triples

            if ((right.p != null) && (right.n != null) &&
                right.value == right.p.value &&
                right.value == right.n.value) {
                theDigrams[right] = right;
            }

            if ((left.p != null) && (left.n != null) &&
                left.value == left.n.value &&
                left.value == left.p.value) {
                theDigrams[left.p] = left.p;
            }
        }

        left.n = right;
        right.p = left;
    }

    /**
     * Abstract method: cleans up for Symboll deletion.
     */
    void cleanUp();

    /**
     * Inserts a Symboll after this one.
     */
    void insertAfter(Symboll toInsert) {
        join(toInsert, n);
        join(this, toInsert);
    }

    /**
     * Removes the digram from the hash table.
     * Overwritten in sub class Guard.
     */
    void deleteDigram() {
        Symboll dummy;

        if (n.isGuard())
            return;
        dummy = theDigrams[this];

        // Only delete digram if its exactly
        // the stored one.

        if (dummy == this)
            theDigrams.remove(this);
    }

    /**
     * Returns true if this is the Guard Symboll.
     * Overwritten in subclass Guard.
     */
    bool isGuard() {
        return false;
    }

    /**
     * Returns true if this is a non-Terminal.
     * Overwritten in subclass NonTerminal.
     */
    bool isNonTerminal() {
        return false;
    }


    /**
     * Checks a new digram. If it appears
     * elsewhere, deals with it by calling
     * match(), otherwise inserts it into the
     * hash table.
     * Overwritten in subclass Guard.
     */
    bool check() {
        Symboll found;

        if (n.isGuard())
            return false;
        if (!theDigrams.containsKey(this)) {
            found = theDigrams[this] = this;
            return false;
        }
        found = theDigrams[this];
        if (found.n != this)
            match(this, found);
        return true;
    }

    /**
     * Replace a digram with a non-Terminal.
     */
    void substitute(Rule r) {
        cleanUp();
        n.cleanUp();
        p.insertAfter(new NonTerminal(r));
        if (!p.check())
            p.n.check();
    }

    /**
     * Deal with a matching digram.
     */
    void match(Symboll newD, Symboll matching) {
        Rule r;
        Symboll first;
        Symboll second;
//        Symboll dummy;

        if (matching.p.isGuard() &&
            matching.n.n.isGuard()) {
            // reuse an existing Rule

            r = (matching.p as Guard).r;
            newD.substitute(r);
        } else {
            // create a new Rule

            r = new Rule();
            try {
                first = newD.clone();
                second = newD.n.clone();
                r.theGuard.n = first;
                first.p = r.theGuard;
                first.n = second;
                second.p = first;
                second.n = r.theGuard;
                r.theGuard.p = second;

                matching.substitute(r);
                newD.substitute(r);

                // Bug fix (21.8.2012): moved the following line
                // to occur after substitutions (see sequitur_simple.cc)

                theDigrams[first] = first;
            } catch (c) {
                c.printStackTrace();
            }
        }

        // Check for an underused Rule.

        if (r.first().isNonTerminal() &&
            ((r.first() as NonTerminal).r.countOfRules == 1))
            (r.first() as NonTerminal).expand();
    }

    /**
     * Produce the hashcode for a digram.
     */
    @override
    int get hashCode {
        int code;

        // Values in linear combination with two
        // prime numbers.

        code = 21599 * value.hashCode + (20507 * n.value.hashCode);
        code = code % Symboll.prime;
        return code;
    }

    /**
     * Test if two digrams are equal.
     * WARNING: don't use to compare two symbols.
     */
    @override
    bool operator ==(Object obj) {
        Symboll other = obj;
        return ((value == (other).value) &&
            (n.value == (other).n.value));
    }
}