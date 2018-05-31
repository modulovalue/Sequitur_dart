# Sequitur_dart
The Sequitur/Nevill-Manning algorithm in Dart

> Sequitur (or Nevill-Manning algorithm) is a recursive algorithm developed by Craig Nevill-Manning and Ian H. Witten in 1997 that infers a hierarchical structure (context-free grammar) from a sequence of discrete symbols. The algorithm operates in linear space and time. It can be used in data compression software applications.  
Wikipedia: [Sequitur algorithm](https://en.wikipedia.org/wiki/Sequitur_algorithm)


Try it out: [sequitur.info](http://www.sequitur.info)

based on the Java implementation by [Eibe Frank](http://www.sequitur.info/java)


```
 Sequitur sequitur = new Sequitur()..run('''I am Sam I am Sam Sam I am''');
 print(sequitur.outputString);
```

results in

```
Usage	Rule
 0	R0 -> R1 R1 R2 R3 R4 
 2	R1 -> R3 R5 R2 
 2	R2 -> S R5 
 2	R3 -> I _ 
 2	R4 -> a m 
 2	R5 -> R4 _ 
```


TODO:
- [ ] to JSON
- [ ] from JSON
