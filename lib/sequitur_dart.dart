import 'dart:collection';

abstract class Sequitur {
  static Rule run(String input) {
    final firstRule = Rule();
    int i;
    // Reset number of rules and Hashtable.
    Rule.beginningAndEndGuardSymbolRule = 0;
    SequiturSymbol.theDigrams.clear();
    for (i = 0; i < input.length; i++) {
      SequiturSymbol.insertAfter(firstRule.last()!, Terminal(input[i], null, null));
      checkSymbol(firstRule.last()!.last!);
    }
    return firstRule;
  }

  /// Links two symbols together, removing any old digram from the hash table.
  static void join(SequiturSymbol left, SequiturSymbol right) {
    if (left.first != null) {
      left.deleteDigram();
      if (right.last != null && right.first != null && right.value == right.last!.value && right.value == right.first!.value) {
        SequiturSymbol.theDigrams[right] = right;
      }
      if (left.last != null && left.first != null && left.value == left.first!.value && left.value == left.last!.value) {
        SequiturSymbol.theDigrams[left.last!] = left.last!;
      }
    }

    left.first = right;
    right.last = left;
  }
}

class Rule {
  static int beginningAndEndGuardSymbolRule = 0;

  late Guard? theGuard = Guard.self(this);
  late int nonTerminalIdentificationRuleNumber = beginningAndEndGuardSymbolRule++;
  int countOfRules = 0;
  int printingIndex = 0;

  Rule();

  SequiturSymbol? first() => theGuard!.first;

  SequiturSymbol? last() => theGuard!.last;

  String description() {
    final rules = <Rule>[];
    Rule currentRule;
    Rule referredTo;
    SequiturSymbol sym;
    int index;
    int processedRules = 0;
    final text = StringBuffer();
    text.write("Usage\tRule\n");
    rules.add(this);
    while (processedRules < rules.length) {
      currentRule = rules.elementAt(processedRules);
      text.write(" ");
      text.write(currentRule.countOfRules);
      text.write("\tR");
      text.write(processedRules);
      text.write(" -> ");
      for (sym = currentRule.first()!; sym is! Guard; sym = sym.first!) {
        if (sym is NonTerminal) {
          referredTo = sym.r;
          if ((rules.length > referredTo.printingIndex) && (rules.elementAt(referredTo.printingIndex) == referredTo)) {
            index = referredTo.printingIndex;
          } else {
            index = rules.length;
            referredTo.printingIndex = index;
            rules.add(referredTo);
          }
          text.write('R');
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
}

abstract class SequiturSymbol {
  static HashMap<SequiturSymbol, SequiturSymbol> theDigrams = HashMap();

  static void insertAfter(SequiturSymbol self, SequiturSymbol toInsert) {
    Sequitur.join(toInsert, self.first!);
    Sequitur.join(self, toInsert);
  }

  SequiturSymbol? first;
  SequiturSymbol? last;

  String get value;

  SequiturSymbol();

  /// Cleans up for Symbol deletion.
  void cleanUp();

  /// Removes the digram from the hash table.
  void deleteDigram() {
    SequiturSymbol? dummy;
    if (first is Guard) {
      return;
    } else {
      dummy = theDigrams[this];
      // Only delete digram if its exactly the stored one.
      if (dummy == this) theDigrams.remove(this);
    }
  }

  /// Replace a digram with a non-Terminal.
  void substitute(Rule r) {
    cleanUp();
    first!.cleanUp();

    /// Inserts a Symbol after the last one
    insertAfter(last!, NonTerminal(r, null, null));
    if (!checkSymbol(last!)) checkSymbol(last!.first!);
  }

  /// Deal with a matching digram.
  static void match(SequiturSymbol newD, SequiturSymbol matching) {
    Rule r;
    SequiturSymbol first;
    SequiturSymbol second;

    if (matching.last is Guard && matching.first!.first is Guard) {
      // Reuse an existing Rule.
      r = (matching.last as Guard).r;
      newD.substitute(r);
    } else {
      // Create a new Rule.
      r = Rule();
      first = cloneSymbol(newD);
      second = cloneSymbol(newD.first!);
      r.theGuard!.first = first;
      first.last = r.theGuard;
      first.first = second;
      second.last = first;
      second.first = r.theGuard;
      r.theGuard!.last = second;
      matching.substitute(r);
      newD.substitute(r);
      theDigrams[first] = first;
    }

    // Check for an underused Rule.

    final rightFirst = r.first();
    if (rightFirst is NonTerminal && rightFirst.r.countOfRules == 1) {
      rightFirst.expand();
    }
  }

  Z matchSymbol<Z>(
    Z Function(NonTerminal) nonTerminal,
    Z Function(Terminal) terminal,
    Z Function(Guard) guard,
  );

  /// Produce the hashcode for a digram.
  @override
  int get hashCode => (21599 * value.hashCode + (20507 * first!.value.hashCode)) & 2265539 /*prime*/;

  /// Test if two digrams are equal.
  /// WARNING: don't use to compare two symbols.
  @override
  bool operator ==(Object other) => other is SequiturSymbol && value == other.value && first!.value == other.first!.value;
}

class Terminal extends SequiturSymbol {
  @override
  final String value;

  @override
  SequiturSymbol? first;
  @override
  SequiturSymbol? last;

  Terminal(this.value, this.first, this.last);

  @override
  void cleanUp() {
    Sequitur.join(last!, first!);
    deleteDigram();
  }

  @override
  Z matchSymbol<Z>(
    Z Function(NonTerminal p1) nonTerminal,
    Z Function(Terminal p1) terminal,
    Z Function(Guard p1) guard,
  ) =>
      terminal(this);
}

class NonTerminal extends SequiturSymbol {
  Rule r;
  @override
  final String value;

  @override
  SequiturSymbol? last;
  @override
  SequiturSymbol? first;

  NonTerminal(this.r, this.first, this.last) : value = (100000 + r.nonTerminalIdentificationRuleNumber).toString() {
    r.countOfRules++;
  }

  @override
  void cleanUp() {
    Sequitur.join(last!, first!);
    deleteDigram();
    r.countOfRules--;
  }

  /// This Symbol is the last reference to its Rule. The contents of the Rule are substituted in its place.
  void expand() {
    Sequitur.join(last!, r.first()!);
    Sequitur.join(r.last()!, first!);
    // digram consisting of the last element of
    // the inserted Rule and the first element after the inserted Rule
    // must be put into the hash table.
    SequiturSymbol.theDigrams[r.last()!] = r.last()!;
    r.theGuard = null;
  }

  @override
  Z matchSymbol<Z>(
    Z Function(NonTerminal p1) nonTerminal,
    Z Function(Terminal p1) terminal,
    Z Function(Guard p1) guard,
  ) =>
      nonTerminal(this);
}

class Guard extends SequiturSymbol {
  final Rule r;

  @override
  String get value => "0";

  @override
  SequiturSymbol? first;
  @override
  SequiturSymbol? last;

  Guard(this.r, this.first, this.last);

  Guard.self(
    this.r,
  ) {
    last = this;
    first = this;
  }

  @override
  void cleanUp() => Sequitur.join(last!, first!);

  @override
  void deleteDigram() {}

  @override
  Z matchSymbol<Z>(
    Z Function(NonTerminal p1) nonTerminal,
    Z Function(Terminal p1) terminal,
    Z Function(Guard p1) guard,
  ) =>
      guard(this);
}

SequiturSymbol cloneSymbol(SequiturSymbol source) => //
    source.matchSymbol(
      (a) => NonTerminal(a.r, a.first, a.last),
      (a) => Terminal(a.value, a.first, a.last),
      (a) => Guard(a.r, a.first, a.last),
    );

bool checkSymbol(SequiturSymbol source) {
  /// Checks a new digram. If it appears elsewhere, deals with it by calling match(),
  /// otherwise inserts it into the hash table. Overwritten in subclass Guard.
  bool check(SequiturSymbol s) {
    SequiturSymbol found;
    if (s.first is Guard) return false;
    if (!SequiturSymbol.theDigrams.containsKey(s)) {
      found = SequiturSymbol.theDigrams[s] = s;
      return false;
    }
    found = SequiturSymbol.theDigrams[s]!;
    if (found.first != s) SequiturSymbol.match(s, found);
    return true;
  }

  return source.matchSymbol(check, check, (a) => false);
}
