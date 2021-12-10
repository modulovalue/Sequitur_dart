// @dart = 2.9

import 'dart:collection';

// TODO migrate to null safe dart.
// TODO guard & non guard, terminal & non terminal.
// TODO no as and no is.
/// https://en.wikipedia.org/wiki/Sequitur_algorithm
/// http://www.sequitur.info
/// https://arxiv.org/pdf/cs/9709102.pdf
String runSequitur({
  final String input,
}) {
  final context = () {
    final digrams = LinkedHashMap<Symboll, Symboll>(
      equals: (final self, final obj) => self.value == obj.value && self.next.value == obj.next.value,
      hashCode: (final self) => self.value.hashCode,
    );
    int i = 0;
    return SequiturContext(
      setDigram: (final a, final b) => digrams[a] = b,
      getDigram: (final a) => digrams[a],
      removeDigram: digrams.remove,
      containsDigram: digrams.containsKey,
      ruleFactory: () => Rule(i++),
    );
  }();
  final rootRule = fillRule(
    context: context,
    input: input,
  );
  return ruleDebugOutput(
    rule: rootRule,
  );
}

Rule fillRule({
  final SequiturContext context,
  final String input,
}) {
  final rootRule = context.ruleFactory();
  int i;
  for (i = 0; i < input.length; i++) {
    rootRule.theGuard.previous.insertAfter(context, Terminal(input[i]));
    rootRule.theGuard.previous.previous.check(context);
  }
  return rootRule;
}

String ruleDebugOutput({
  final Rule rule,
}) {
  final rules = <Rule>[rule];
  Rule currentRule;
  Rule referredTo;
  Symboll sym;
  int index;
  int processedRules = 0;
  final text = StringBuffer();
  text.write("Usage\tRule\n");
  while (processedRules < rules.length) {
    currentRule = rules.elementAt(processedRules);
    text.write(processedRules);
    text.write(" -> ");
    for (sym = currentRule.theGuard.next; sym is! Guard; sym = sym.next) {
      if (sym is NonTerminal) {
        referredTo = sym.r;
        if ((rules.length > referredTo.index) && (rules.elementAt(referredTo.index) == referredTo)) {
          index = referredTo.index;
        } else {
          index = rules.length;
          referredTo.index = index;
          rules.add(referredTo);
        }
        text.write(index);
      } else {
        if (sym.value == ' ') {
          text.write('_');
        } else {
          if (sym.value == '\n') {
            text.write("\\n");
          } else {
            text.write(sym.value);
          }
        }
      }
      text.write(' ');
    }
    text.write('\n');
    processedRules++;
  }
  return text.toString();
}

class SequiturContext {
  final Rule Function() ruleFactory;
  final Symboll Function(Symboll, Symboll) setDigram;
  final Symboll Function(Symboll) getDigram;
  final bool Function(Symboll) containsDigram;
  final void Function(Symboll) removeDigram;

  const SequiturContext({
    final this.setDigram,
    final this.getDigram,
    final this.removeDigram,
    final this.containsDigram,
    final this.ruleFactory,
  });
}

class Rule {
  /// Guard symbol to mark beginning
  /// and end of rule.
  Guard theGuard;

  /// Counter keeps track of how many
  /// times the Rule is used in the
  /// grammar.
  int count;

  /// The rule's number.
  /// Used for identification of
  /// non-terminals.
  final int number;

  /// Index used for printing.
  int index;

  Rule(
    final this.number,
  )   : count = 0,
        index = 0 {
    theGuard = Guard(this);
  }
}

/// Links two symbols together, removing any old
/// digram from the hash table.
void join(
  final SequiturContext context,
  final Symboll left,
  final Symboll right,
) {
  if (left.next != null) {
    left.deleteDigram(context);
    if ((right.previous != null) &&
        (right.next != null) &&
        right.value == right.previous.value &&
        right.value == right.next.value) {
      context.setDigram(right, right);
    }
    if ((left.previous != null) &&
        (left.next != null) &&
        left.value == left.next.value &&
        left.value == left.previous.value) {
      context.setDigram(left.previous, left.previous);
    }
  }
  left.next = right;
  right.previous = left;
}

class Terminal with Symboll {
  Terminal(
    final String theValue,
  ) {
    value = theValue;
  }

  @override
  Terminal clone() {
    final sym = Terminal(value);
    sym.previous = previous;
    sym.next = next;
    return sym;
  }

  @override
  void cleanUp(
    final SequiturContext digrams,
  ) {
    join(digrams, previous, next);
    deleteDigram(digrams);
  }

  @override
  R match<R>({
    final R Function(Guard guard) guard,
    final R Function(NonTerminal guard) nonTerminal,
    final R Function(Terminal guard) terminal,
  }) =>
      terminal(this);
}

class NonTerminal with Symboll {
  Rule r;

  NonTerminal(
    final this.r,
  ) {
    r.count++;
    value = (10000000 + r.number).toString();
    previous = null;
    next = null;
  }

  /// Extra cloning method necessary so that
  /// count in the corresponding Rule is
  /// increased.
  @override
  NonTerminal clone() {
    final sym = NonTerminal(r);
    sym.previous = previous;
    sym.next = next;
    return sym;
  }

  @override
  void cleanUp(
    final SequiturContext context,
  ) {
    join(context, previous, next);
    deleteDigram(context);
    r.count--;
  }

  /// This Symbol is the last reference to
  /// its Rule. The contents of the Rule
  /// are substituted in its place.
  void expand(
    final SequiturContext context,
  ) {
    join(context, previous, r.theGuard.next);
    join(context, r.theGuard.previous, next);
    context.setDigram(r.theGuard.previous, r.theGuard.previous);
    r.theGuard.r = null;
    r.theGuard = null;
  }

  @override
  R match<R>({
    final R Function(Guard guard) guard,
    final R Function(NonTerminal guard) nonTerminal,
    final R Function(Terminal guard) terminal,
  }) =>
      nonTerminal(this);
}

class Guard with Symboll {
  Rule r;

  Guard(
    final this.r,
  ) {
    value = "0";
    previous = this;
    next = this;
  }

  @override
  void cleanUp(
    final SequiturContext digrams,
  ) =>
      join(
        digrams,
        previous,
        next,
      );

  @override
  void deleteDigram(
    final SequiturContext digrams,
  ) {}

  @override
  bool check(
    final SequiturContext digrams,
  ) =>
      false;

  @override
  Guard clone() {
    final sym = Guard(r);
    sym.previous = previous;
    sym.next = next;
    return sym;
  }

  @override
  R match<R>({
    final R Function(Guard guard) guard,
    final R Function(NonTerminal guard) nonTerminal,
    final R Function(Terminal guard) terminal,
  }) =>
      guard(this);
}

mixin Symboll {
  String value;
  Symboll previous;
  Symboll next;

  /// Cleans up for Symboll deletion.
  void cleanUp(
    SequiturContext context,
  );

  Symboll clone();

  /// Inserts a Symboll after this one.
  void insertAfter(
    final SequiturContext context,
    final Symboll toInsert,
  ) {
    join(context, toInsert, next);
    join(context, this, toInsert);
  }

  /// Removes the digram from the hash table.
  /// Overwritten in sub class Guard.
  void deleteDigram(
    final SequiturContext context,
  ) {
    if (next is! Guard) {
      if (context.getDigram(this) == this) {
        context.removeDigram(this);
      }
    }
  }

  /// Checks a new digram. If it appears
  /// elsewhere, deals with it by calling
  /// match(), otherwise inserts it into the
  /// hash table.
  /// Overwritten in subclass Guard.
  bool check(
    final SequiturContext context,
  ) {
    if (next is Guard) {
      return false;
    } else {
      if (!context.containsDigram(this)) {
        context.setDigram(this, this);
        return false;
      } else {
        final found = context.getDigram(this);
        if (found.next != this) {
          sequiturMatch(
            context,
            this,
            found,
          );
        }
        return true;
      }
    }
  }

  /// Replace a digram with a non-Terminal.
  void substitute(
    final SequiturContext context,
    final Rule r,
  ) {
    cleanUp(context);
    next.cleanUp(context);
    previous.insertAfter(context, NonTerminal(r));
    if (!previous.check(context)) {
      previous.next.check(context);
    }
  }

  /// Deal with a matching digram.
  void sequiturMatch(
    final SequiturContext context,
    final Symboll newD,
    final Symboll matching,
  ) {
    Rule r;
    Symboll first;
    Symboll second;
    if (matching.previous is Guard && matching.next.next is Guard) {
      r = (matching.previous as Guard).r;
      newD.substitute(context, r);
    } else {
      r = context.ruleFactory();
      first = newD.clone();
      second = newD.next.clone();
      r.theGuard.next = first;
      first.previous = r.theGuard;
      first.next = second;
      second.previous = first;
      second.next = r.theGuard;
      r.theGuard.previous = second;
      matching.substitute(context, r);
      newD.substitute(context, r);
      context.setDigram(first, first);
    }
    // Check for an underused Rule.
    if (r.theGuard.next is NonTerminal && ((r.theGuard.next as NonTerminal).r.count == 1)) {
      (r.theGuard.next as NonTerminal).expand(context);
    }
  }

  R match<R>({
    final R Function(Guard guard) guard,
    final R Function(NonTerminal guard) nonTerminal,
    final R Function(Terminal guard) terminal,
  });
}
