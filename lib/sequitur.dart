import 'dart:collection';

/// https://en.wikipedia.org/wiki/Sequitur_algorithm
/// http://www.sequitur.info
/// https://arxiv.org/pdf/cs/9709102.pdf
String runSequitur({
  required final String input,
}) {
  final context = () {
    final digrams = LinkedHashMap<Symboll, Symboll>(
      equals: (final self, final obj) => self.value == obj.value && self.next?.value == obj.next?.value,
      hashCode: (final self) => self.value.hashCode,
    );
    int i = 0;
    return _SequiturContext(
      setDigram: (final a, final b) => digrams[a] = b,
      getDigram: (final a) => digrams[a],
      removeDigram: digrams.remove,
      containsDigram: digrams.containsKey,
      ruleFactory: () => Rule(i++),
    );
  }();
  final rootRule = _fillRule(
    context: context,
    input: input,
  );
  return _ruleDebugOutput(
    rule: rootRule,
  );
}

Rule _fillRule({
  required final _SequiturContext context,
  required final String input,
}) {
  final rootRule = context.ruleFactory();
  int i;
  for (i = 0; i < input.length; i++) {
    final prev = rootRule.theGuard.previous;
    if (prev == null) {
      throw Exception("Invalid State.");
    } else {
      _insertAfter(
        context: context,
        self: prev,
        toInsert: Terminal(
          value: input[i],
        ),
      );
      final newPrev = rootRule.theGuard.previous;
      if (newPrev == null) {
        throw Exception("Invalid State.");
      } else {
        _check(
          context: context,
          self: newPrev.previous!,
        );
      }
    }
  }
  return rootRule;
}

String _ruleDebugOutput({
  required final Rule rule,
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
    sym = currentRule.theGuard.next!;
    for (;;) {
      if (sym is Guard) {
        break;
      } else {
        if (sym is NonTerminal) {
          referredTo = sym.rule;
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
        sym = sym.next!;
      }
    }
    text.write('\n');
    processedRules++;
  }
  return text.toString();
}

class _SequiturContext {
  final Rule Function() ruleFactory;
  final Symboll Function(Symboll, Symboll) setDigram;
  final Symboll? Function(Symboll) getDigram;
  final bool Function(Symboll) containsDigram;
  final void Function(Symboll) removeDigram;

  const _SequiturContext({
    required final this.setDigram,
    required final this.getDigram,
    required final this.removeDigram,
    required final this.containsDigram,
    required final this.ruleFactory,
  });
}

class Rule {
  /// Guard symbol to mark beginning
  /// and end of rule.
  late final Guard theGuard;

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
    theGuard = Guard(
      rule: this,
    );
  }
}

class Terminal implements Symboll {
  @override
  final String value;
  @override
  Symboll? previous;
  @override
  Symboll? next;

  Terminal({
    required final this.value,
  });

  @override
  Terminal clone() {
    final sym = Terminal(
      value: value,
    );
    sym.previous = previous;
    sym.next = next;
    return sym;
  }

  @override
  void cleanUp(
    final _SequiturContext context,
  ) {
    _join(
      context: context,
      left: previous!,
      right: next!,
    );
    _deleteDigram(
      context: context,
      symbol: this,
    );
  }
}

class NonTerminal implements Symboll {
  @override
  final String value;
  final Rule rule;
  @override
  Symboll? previous;
  @override
  Symboll? next;

  NonTerminal({
    required final this.rule,
  }) : value = (10000000 + rule.number).toString() {
    rule.count++;
  }

  @override
  NonTerminal clone() {
    final sym = NonTerminal(
      rule: rule,
    );
    sym.previous = previous;
    sym.next = next;
    return sym;
  }

  @override
  void cleanUp(
    final _SequiturContext context,
  ) {
    _join(
      context: context,
      left: previous!,
      right: next!,
    );
    _deleteDigram(
      context: context,
      symbol: this,
    );
    rule.count--;
  }

  /// This Symbol is the last reference to
  /// its Rule. The contents of the Rule
  /// are substituted in its place.
  void expand(
    final _SequiturContext context,
  ) {
    _join(
      context: context,
      left: previous!,
      right: rule.theGuard.next!,
    );
    _join(
      context: context,
      left: rule.theGuard.previous!,
      right: next!,
    );
    context.setDigram(
      rule.theGuard.previous!,
      rule.theGuard.previous!,
    );
  }
}

class Guard implements Symboll {
  @override
  final String value;
  final Rule rule;
  @override
  Symboll? previous;
  @override
  Symboll? next;

  Guard({
    required final this.rule,
  }) : value = "0" {
    previous = this;
    next = this;
  }

  @override
  void cleanUp(
    final _SequiturContext digrams,
  ) =>
      _join(
        context: digrams,
        left: previous!,
        right: next!,
      );

  @override
  Guard clone() {
    final sym = Guard(
      rule: rule,
    );
    sym.previous = previous;
    sym.next = next;
    return sym;
  }
}

abstract class Symboll {
  String get value;

  abstract Symboll? previous;

  abstract Symboll? next;

  void cleanUp(
    _SequiturContext context,
  );

  Symboll clone();
}

/// Links two symbols together, removing any old
/// digram from the hash table.
void _join({
  required final _SequiturContext context,
  required final Symboll left,
  required final Symboll right,
}) {
  if (left.next != null) {
    _deleteDigram(
      context: context,
      symbol: left,
    );
    if ((right.previous != null) &&
        (right.next != null) &&
        right.value == right.previous!.value &&
        right.value == right.next!.value) {
      context.setDigram(right, right);
    }
    if ((left.previous != null) &&
        (left.next != null) &&
        left.value == left.next!.value &&
        left.value == left.previous!.value) {
      context.setDigram(left.previous!, left.previous!);
    }
  }
  left.next = right;
  right.previous = left;
}

bool _check({
  required final _SequiturContext context,
  required final Symboll self,
}) {
  if (self is Guard) {
    return false;
  } else {
    if (self.next is Guard) {
      return false;
    } else {
      if (!context.containsDigram(self)) {
        context.setDigram(self, self);
        return false;
      } else {
        final found = context.getDigram(self);
        if (found!.next != self) {
          _match(
            context: context,
            newD: self,
            matching: found,
          );
        }
        return true;
      }
    }
  }
}

/// Replace a digram with a non-Terminal.
void _substitute({
  required final _SequiturContext context,
  required final Rule r,
  required final Symboll self,
}) {
  self.cleanUp(context);
  self.next!.cleanUp(context);
  _insertAfter(
    context: context,
    self: self.previous!,
    toInsert: NonTerminal(
      rule: r,
    ),
  );
  final _checked = _check(context: context, self: self.previous!);
  if (!_checked) {
    _check(
      context: context,
      self: self.previous!.next!,
    );
  }
}

/// Insert toInsert after self.
void _insertAfter({
  required final _SequiturContext context,
  required final Symboll self,
  required final Symboll toInsert,
}) {
  _join(
    context: context,
    left: toInsert,
    right: self.next!,
  );
  _join(
    context: context,
    left: self,
    right: toInsert,
  );
}

void _match({
  required final _SequiturContext context,
  required final Symboll newD,
  required final Symboll matching,
}) {
  Rule r;
  Symboll first;
  Symboll second;
  final prev = matching.previous;
  if (prev is Guard && matching.next!.next is Guard) {
    r = prev.rule;
    _substitute(
      context: context,
      r: r,
      self: newD,
    );
  } else {
    r = context.ruleFactory();
    first = newD.clone();
    second = newD.next!.clone();
    r.theGuard.next = first;
    first.previous = r.theGuard;
    first.next = second;
    second.previous = first;
    second.next = r.theGuard;
    r.theGuard.previous = second;
    _substitute(
      context: context,
      r: r,
      self: matching,
    );
    _substitute(
      context: context,
      r: r,
      self: newD,
    );
    context.setDigram(first, first);
  }
  final next = r.theGuard.next;
  // Check for an underused Rule.
  if (next is NonTerminal && next.rule.count == 1) {
    next.expand(context);
  }
}

/// Remove the given symbol from the digram store.
void _deleteDigram({
  required final _SequiturContext context,
  required final Symboll symbol,
}) {
  if (symbol.next is! Guard) {
    if (context.getDigram(symbol) == symbol) {
      context.removeDigram(symbol);
    }
  }
}
