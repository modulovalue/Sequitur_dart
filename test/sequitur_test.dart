// @dart = 2.9
import 'package:sequitur_dart/sequitur.dart';
import 'package:test/test.dart';

void main() {
  group("sequitur", () {
    test("sam", () {
      expect(
        runSequitur(
          input: """I am Sam I am Sam Sam I am""",
        ),
        [
          'Usage\tRule\n',
          '0 -> 1 1 2 3 4 \n',
          '1 -> 3 5 2 \n',
          '2 -> S 5 \n',
          '3 -> I _ \n',
          '4 -> a m \n',
          '5 -> 4 _ \n',
          '',
        ].join(),
      );
    });
    test("please porridge", () {
      expect(
        runSequitur(
          input: """pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.""",
        ),
        [
          'Usage\tRule\n',
          '0 -> 1 2 3 4 3 5 \\n \\n 6 2 7 4 7 5 \n',
          '1 -> p e a s 8 r r i d g 9 \n',
          '2 -> h o t \n',
          '3 -> 10 1 \n',
          '4 -> c 11 \n',
          '5 -> 12 _ t h 8 t 10 n 12 9 d a y s _ 11 . \n',
          '6 -> s o m 9 l i k 9 i t _ \n',
          '7 -> 10 6 \n',
          '8 -> 9 p o \n',
          '9 -> e _ \n',
          '10 -> , \\n \n',
          '11 -> o l d \n',
          '12 -> i n \n',
          '',
        ].join(),
      );
    });
    test("genesis", () {
      expect(
        runSequitur(
          input: """In the beginning, God created the heavens and the earth.
And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters. 
And God said, Let there be light: and there was light. 
And God saw the light, that it was good: and God divided the light from the darkness. 
And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day. 
And God said, Let there be a firmament in the midst of the waters, and let it divide the waters from the waters. 
And God made the firmament, and divided the waters which were under the firmament from the waters which were above the firmament: and it was so. 
And God called the firmament Heaven. And the evening and the morning were the second day. 
And God said, Let the waters under the heaven be gathered together unto one place, and let the dry land appear: and it was so. 
And God called the dry land Earth; and the gathering together of the waters called he Seas: and God saw that it was good. 
And God said, Let the earth bring forth grass, the herb yielding seed, and the fruit tree yielding fruit after his kind, whose seed is in itself, upon the earth: and it was so. 
And the earth brought forth grass, and herb yielding seed after his kind, and the tree yielding fruit, whose seed was in itself, after his kind: and God saw that it was good. 
And the evening and the morning were the third day. 
And God said, Let there be lights in the firmament of the heaven to divide the day from the night; and let them be for signs, and for seasons, and for days, and years: 
And let them be for lights in the firmament of the heaven to give light upon the earth: and it was so. 
And God made two great lights; the greater light to rule the day, and the lesser light to rule the night: he made the stars also. 
And God set them in the firmament of the heaven to give light upon the earth, 
And to rule over the day and over the night, and to divide the light from the darkness: and God saw that it was good. 
And the evening and the morning were the fourth day. 
And God said, Let the waters bring forth abundantly the moving creature that hath life, and fowl that may fly above the earth in the open firmament of heaven. 
And God created great whales, and every living creature that moveth, which the waters brought forth abundantly, after their kind, and every winged fowl after his kind: and God saw that it was good. 
""",
        ),
        [
          'Usage\tRule\n',
          '0 -> I 1 2 3 g 4 5 6 7 8 9 10 11 12 13 10 14 . \\n 15 16 17 18 i 19 20 21 22 m 23 v o 24 ; 25 26 18 a 12 27 28 e p 29 15 S p 30 31 32 7 33 34 27 35 36 37 38 39 40 41 42 43 44 6 45 38 7 46 44 47 48 41 _ D a y 23 49 _ 50 51 N 52 53 25 54 55 56 57 36 58 59 4 60 m 24 56 61 62 31 63 64 65 66 67 23 46 64 68 69 67 65 68 70 71 67 72 73 H 74 75 53 76 54 77 c o 78 79 69 60 80 81 82 83 84 85 86 87 88 _ p l 89 e 62 90 91 a p p 92 72 91 E 93 ; 94 82 95 84 61 _ 51 50 S 96 97 45 98 99 100 101 90 102 103 104 105 104 a 106 107 108 109 108 t 110 111 112 113 99 114 101 115 102 58 106 115 90 105 116 117 6 107 118 108 1 117 110 a 119 97 120 60 19 30 34 121 122 123 81 41 124 63 125 126 127 52 ; 76 128 129 130 131 129 96 o 131 132 57 133 y 92 s 134 135 128 132 136 124 137 138 139 _ 140 66 141 w o 142 136 s ; 143 g 144 a 145 136 141 o _ 146 125 103 l 147 77 r 148 149 127 150 134 50 151 143 s t 152 12 153 140 154 77 21 155 4 143 73 32 156 137 6 135 149 157 57 76 157 n 150 23 158 63 90 136 47 159 120 143 f 20 r 160 79 161 100 162 143 163 164 h a 160 l i f e 23 f 165 166 167 y 168 169 58 b 71 170 16 4 170 o p 171 59 32 11 154 172 173 142 174 153 147 23 175 176 i 164 33 19 6 174 i 177 170 35 178 114 162 179 180 181 30 _ 182 179 78 175 183 184 185 173 168 165 58 119 159 186 29 \\n \n',
          '1 -> n _ \n',
          '2 -> t 50 \n',
          '3 -> b e \n',
          '4 -> i n \n',
          '5 -> n 185 \n',
          '6 -> , _ \n',
          '7 -> G o 34 \n',
          '8 -> c r 74 \n',
          '9 -> t e \n',
          '10 -> 34 2 \n',
          '11 -> 187 a 75 \n',
          '12 -> s _ \n',
          '13 -> a n \n',
          '14 -> 92 19 \n',
          '15 -> 188 189 \n',
          '16 -> 14 _ \n',
          '17 -> w a \n',
          '18 -> 12 w \n',
          '19 -> t h \n',
          '20 -> o u \n',
          '21 -> t _ \n',
          '22 -> f 190 \n',
          '23 -> 6 115 \n',
          '24 -> i d \n',
          '25 -> _ 115 \n',
          '26 -> 191 r k 88 s \n',
          '27 -> 192 189 f 89 123 32 189 \n',
          '28 -> d e \n',
          '29 -> . _ \n',
          '30 -> i r \n',
          '31 -> i 21 \n',
          '32 -> o 193 \n',
          '33 -> 163 194 \n',
          '34 -> d _ \n',
          '35 -> 17 195 s \n',
          '36 -> 98 39 3 \n',
          '37 -> _ 41 \n',
          '38 -> : 25 \n',
          '39 -> 181 196 \n',
          '40 -> 17 12 \n',
          '41 -> l 52 \n',
          '42 -> 154 197 \n',
          '43 -> w _ \n',
          '44 -> 181 37 \n',
          '45 -> 198 199 g 200 \n',
          '46 -> 201 83 \n',
          '47 -> 126 49 \n',
          '48 -> 154 51 90 \n',
          '49 -> 90 26 s \n',
          '50 -> 187 _ \n',
          '51 -> c 153 l 83 \n',
          '52 -> i 202 \n',
          '53 -> 29 188 203 \n',
          '54 -> 90 204 205 90 \n',
          '55 -> f 30 \n',
          '56 -> s 21 \n',
          '57 -> 191 y \n',
          '58 -> _ a \n',
          '59 -> 168 30 206 21 \n',
          '60 -> _ 90 \n',
          '61 -> 32 64 \n',
          '62 -> 23 207 \n',
          '63 -> 201 123 \n',
          '64 -> 90 35 \n',
          '65 -> 126 64 \n',
          '66 -> 154 151 \n',
          '67 -> 60 208 \n',
          '68 -> 184 209 177 205 \n',
          '69 -> 85 28 r \n',
          '70 -> a b \n',
          '71 -> o 194 \n',
          '72 -> 112 48 \n',
          '73 -> 208 _ \n',
          '74 -> e a \n',
          '75 -> 194 n \n',
          '76 -> 58 78 \n',
          '77 -> s e \n',
          '78 -> n 34 \n',
          '79 -> 121 64 _ \n',
          '80 -> 11 _ \n',
          '81 -> 3 _ \n',
          '82 -> g a 122 \n',
          '83 -> e 34 \n',
          '84 -> 86 g e 122 _ \n',
          '85 -> u n \n',
          '86 -> t o \n',
          '87 -> _ o \n',
          '88 -> n e \n',
          '89 -> a c \n',
          '90 -> 181 _ \n',
          '91 -> d 176 115 \n',
          '92 -> 74 r \n',
          '93 -> 152 19 \n',
          '94 -> 76 90 \n',
          '95 -> 185 _ \n',
          '96 -> 74 s \n',
          '97 -> 210 211 \n',
          '98 -> 42 24 6 L 212 \n',
          '99 -> 213 178 \n',
          '100 -> 95 22 \n',
          '101 -> 19 214 215 216 \n',
          '102 -> 187 r b _ 217 218 \n',
          '103 -> 23 90 \n',
          '104 -> 116 31 \n',
          '105 -> t 144 123 217 \n',
          '106 -> 119 6 \n',
          '107 -> 174 o 77 _ 218 \n',
          '108 -> _ i \n',
          '109 -> 12 4 \n',
          '110 -> 77 l f 6 \n',
          '111 -> 192 213 \n',
          '112 -> 210 199 140 \n',
          '113 -> 29 135 \n',
          '114 -> 20 202 168 190 \n',
          '115 -> 13 34 \n',
          '116 -> f 219 \n',
          '117 -> i t \n',
          '118 -> 184 215 \n',
          '119 -> 180 209 12 182 \n',
          '120 -> 186 113 203 94 204 220 144 \n',
          '121 -> 57 98 \n',
          '122 -> 181 r \n',
          '123 -> e _ \n',
          '124 -> 109 67 87 193 156 \n',
          '125 -> 90 57 \n',
          '126 -> 168 r o 221 \n',
          '127 -> 90 n \n',
          '128 -> 207 155 81 \n',
          '129 -> 132 s \n',
          '130 -> i g \n',
          '131 -> n 133 \n',
          '132 -> 22 _ \n',
          '133 -> 216 115 \n',
          '134 -> : _ \n',
          '135 -> \\n 188 \n',
          '136 -> l 150 \n',
          '137 -> g i 194 148 111 \n',
          '138 -> 134 115 \n',
          '139 -> 117 118 \n',
          '140 -> s o \n',
          '141 -> _ t \n',
          '142 -> 214 74 21 \n',
          '143 -> 141 50 \n',
          '144 -> r e \n',
          '145 -> 195 _ \n',
          '146 -> 219 l 123 \n',
          '147 -> e s \n',
          '148 -> 222 150 _ \n',
          '149 -> 158 146 \n',
          '150 -> 130 223 \n',
          '151 -> 167 28 \n',
          '152 -> a r \n',
          '153 -> a l \n',
          '154 -> 113 7 \n',
          '155 -> 181 221 \n',
          '156 -> 90 80 158 \n',
          '157 -> 71 r 143 \n',
          '158 -> 86 _ \n',
          '159 -> 138 211 \n',
          '160 -> 19 _ \n',
          '161 -> b r \n',
          '162 -> 160 70 85 191 n t 169 \n',
          '163 -> m o \n',
          '164 -> v 95 172 u 144 166 \n',
          '165 -> o w l \n',
          '166 -> 224 225 \n',
          '167 -> m a \n',
          '168 -> _ f \n',
          '169 -> l y \n',
          '170 -> 224 123 \n',
          '171 -> e n \n',
          '172 -> 8 t \n',
          '173 -> e d \n',
          '174 -> w h \n',
          '175 -> e 194 \n',
          '176 -> 183 222 \n',
          '177 -> c h \n',
          '178 -> _ 161 \n',
          '179 -> 6 a \n',
          '180 -> f 145 \n',
          '181 -> 19 e \n',
          '182 -> k 4 d \n',
          '183 -> r y \n',
          '184 -> _ w \n',
          '185 -> 4 g \n',
          '186 -> 198 139 226 200 \n',
          '187 -> h e \n',
          '188 -> A 78 \n',
          '189 -> 19 123 \n',
          '190 -> o r \n',
          '191 -> d a \n',
          '192 -> u p o 1 \n',
          '193 -> f _ \n',
          '194 -> v e \n',
          '195 -> 9 r \n',
          '196 -> r 123 \n',
          '197 -> s a \n',
          '198 -> 19 225 \n',
          '199 -> 31 40 \n',
          '200 -> o o d \n',
          '201 -> 227 v 24 \n',
          '202 -> g 223 \n',
          '203 -> 228 75 185 \n',
          '204 -> 163 r 5 \n',
          '205 -> 220 196 \n',
          '206 -> 167 m 171 \n',
          '207 -> l 212 \n',
          '208 -> 55 206 t \n',
          '209 -> h i \n',
          '210 -> : 76 \n',
          '211 -> 7 197 43 \n',
          '212 -> e 21 \n',
          '213 -> 228 93 \n',
          '214 -> 226 r \n',
          '215 -> a s \n',
          '216 -> s 6 \n',
          '217 -> y i e l 227 n g _ \n',
          '218 -> 77 173 \n',
          '219 -> r u \n',
          '220 -> 184 e \n',
          '221 -> m _ \n',
          '222 -> _ l \n',
          '223 -> h t \n',
          '224 -> 141 h \n',
          '225 -> a 21 \n',
          '226 -> _ g \n',
          '227 -> d i \n',
          '228 -> 90 e \n',
          '',
        ].join(),
      );
    });
    test("green eggs and ham", () {
      expect(
        runSequitur(
          input: """I am Sam

I am Sam
Sam I am

That Sam-I-am
That Sam-I-am!
I do not like
that Sam-I-am

Do you like 
green eggs and ham

I do not like them,
Sam-I-am.
I do not like
green eggs and ham.

Would you like them 
Here or there?

I would not like them 
here or there.
I would not like them 
anywhere.
I do not like 
green eggs and ham.
I do not like them,
Sam-I-am

Would you like them
in a house?
Would you like them
with a mouse?

I do not like them
in a house.
I do not like them 
with a mouse.
I do not like them
here or there.
I do not like them
anywhere.
I do not like green eggs and ham.
I do not like them, Sam-I-am.


Would you eat them
in a box?
Would you eat them
with a fox?

Not in a box.
Not with a fox.
Not in a house.
Not with a mouse.
I would not eat them here or there.
I would not eat them anywhere.
I would not eat green eggs and ham.
I do not like them, Sam-I-am.

Would you? Could you?
in a car?
Eat them! Eat them!
Here they are.

I woould not ,
could not,
in a car

You may like them.
You will see.
You may like them
in a tree?
d not in a tree.
I would not, could not in a tree.
Not in a car! You let me be.

I do not like them in a box.
I do not like them with a fox
I do not like them in a house
I do mot like them with a mouse
I do not like them here or there.
I do not like them anywhere.
I do not like green eggs and ham.
I do not like them, Sam-I-am.

A train! A train!
A train! A train!
Could you, would you
on a train?

Not on a train! Not in a tree!
Not in a car! Sam! Let me be!
I would not, could not, in a box.
I could not, would not, with a fox.
I will not eat them with a mouse
I will not eat them in a house.
I will not eat them here or there.
I will not eat them anywhere.
I do not like them, Sam-I-am.


Say!
In the dark?
Here in the dark!
Would you, could you, in the dark?

I would not, could not,
in the dark.

Would you, could you,
in the rain?

I would not, could not, in the rain.
Not in the dark. Not on a train,
Not in a car, Not in a tree.
I do not like them, Sam, you see.
Not in a house. Not in a box.
Not with a mouse. Not with a fox.
I will not eat them here or there.
I do not like them anywhere!

You do not like 
green eggs and ham?

I do not 
like them,
Sam-I-am.

Could you, would you,
with a goat?

I would not,
could not.
with a goat!

Would you, could you,
on a boat?

I could not, would not, on a boat.
I will not, will not, with a goat.
I will not eat them in the rain.
I will not eat them on a train.
Not in the dark! Not in a tree!
Not in a car! You let me be!
I do not like them in a box.
I do not like them with a fox.
I will not eat them in a house.
I do not like them with a mouse.
I do not like them here or there.
I do not like them ANYWHERE!

I do not like 
green egss
and ham!

I do not like them,
Sam-I-am.

You do not like them.
SO you say.
Try them! Try them!
ANd you may.
Try them and you may I say.

Sam!
If you will let me be,
I will try them.
You will see.

Say!
I like green eggs and ham!
I do!! I like them, Sam-I-am!
And I would eat them in a boat!
And I would eat them with a goat...
And I will eat them in the rain.
And in the dark. And on a train.
And in a car. And in a tree.
They are so goodm so goodm you see!

So I will eat them in a box.
And I will eat them with a fox.
And I will eat them in a house.
And I will eat them with a mouse.
And I will eat them here and there.
Say! I will eat them ANHYWHERE!

I do so like 
green eggs and ham!
Thank you!
Thank you,
Sam-I-am
""",
        ),
        [
          'Usage\tRule\n',
          '0 -> 1 \\n 1 2 _ 3 \\n 4 4 ! 5 t 6 7 D 8 9 10 7 11 12 . 5 13 14 15 16 17 ? 7 18 19 17 20 18 21 10 22 12 14 23 24 25 \\n 26 24 27 23 28 15 26 28 \\n 29 \\n 21 30 7 31 32 b 33 31 \\n 34 33 \\n 35 b 36 34 36 37 38 39 40 41 40 42 43 44 30 45 ? _ 46 47 48 47 49 _ 49 \\n 50 51 52 53 54 55 _ 56 57 48 7 58 59 58 32 60 47 61 62 63 64 63 35 65 66 53 67 68 69 70 71 27 68 38 72 m 73 74 75 76 _ 29 77 22 13 76 78 79 79 80 \\n 81 47 82 81 83 2 84 L 85 86 64 87 88 89 90 91 i 92 f 93 94 75 95 96 97 98 38 99 100 42 101 78 7 102 103 104 105 47 50 _ 106 107 108 87 106 109 57 106 20 45 110 57 111 109 87 111 112 113 81 57 114 115 87 116 117 67 118 87 119 120 114 38 113 88 39 113 121 99 101 77 122 123 124 47 72 62 15 74 125 80 57 126 127 56 20 126 122 108 57 128 47 \\n 129 90 87 128 130 131 132 131 126 100 111 100 81 112 83 66 86 67 98 69 101 71 100 133 101 75 134 41 134 135 136 137 \\n 138 s s \\n 139 140 137 141 125 \\n 123 142 143 O 144 145 146 84 147 107 135 148 146 149 148 150 129 145 151 \\n 152 153 f 144 132 154 e 57 155 156 157 59 \\n 102 158 159 153 _ 160 ! 161 74 118 162 163 98 164 163 _ 126 . . 165 111 166 167 168 81 166 169 115 168 169 170 117 T 19 52 171 172 172 119 173 86 \\n S 8 174 88 165 121 165 133 165 175 165 176 149 61 104 177 143 a y 161 132 178 135 H 136 122 129 160 _ 179 180 124 181 181 182 \\n \n',
          '1 -> 3 183 \\n \n',
          '2 -> S 184 \n',
          '3 -> 129 184 \n',
          '4 -> \\n T 6 \n',
          '5 -> 185 \\n \n',
          '6 -> 186 t 187 \n',
          '7 -> \\n \\n \n',
          '8 -> o _ \n',
          '9 -> 188 158 \n',
          '10 -> \\n 159 \n',
          '11 -> 189 _ \n',
          '12 -> 190 57 191 \n',
          '13 -> 159 . \n',
          '14 -> 7 25 \n',
          '15 -> _ \\n \n',
          '16 -> H e \n',
          '17 -> 177 192 193 177 \n',
          '18 -> 194 195 193 m 15 \n',
          '19 -> h e \n',
          '20 -> . \\n \n',
          '21 -> 42 22 \n',
          '22 -> 20 11 \n',
          '23 -> 32 h \n',
          '24 -> 196 47 \n',
          '25 -> 197 9 190 \n',
          '26 -> 198 m \n',
          '27 -> 185 _ 141 \n',
          '28 -> 196 70 \n',
          '29 -> 41 70 \n',
          '30 -> 13 27 , 187 20 \n',
          '31 -> 199 200 \n',
          '32 -> \\n 37 \n',
          '33 -> 93 47 \n',
          '34 -> 198 f \n',
          '35 -> 201 37 \n',
          '36 -> 93 202 \n',
          '37 -> i 203 \n',
          '38 -> h 196 \n',
          '39 -> 202 175 \n',
          '40 -> 43 200 _ \n',
          '41 -> 176 192 51 177 \n',
          '42 -> 139 204 \n',
          '43 -> 20 194 62 \n',
          '44 -> 205 _ \n',
          '45 -> \\n 199 \n',
          '46 -> C 206 \n',
          '47 -> ? \\n \n',
          '48 -> 37 115 \n',
          '49 -> E 207 142 ! \n',
          '50 -> 16 177 \n',
          '51 -> _ 104 \n',
          '52 -> 150 208 \n',
          '53 -> 117 \\n \n',
          '54 -> 209 o \n',
          '55 -> 210 62 \n',
          '56 -> 57 211 \n',
          '57 -> , \\n \n',
          '58 -> 212 213 150 74 \n',
          '59 -> 20 212 132 120 \n',
          '60 -> t 214 \n',
          '61 -> d _ \n',
          '62 -> n 215 \n',
          '63 -> 68 60 20 \n',
          '64 -> 216 131 211 \n',
          '65 -> 115 84 \n',
          '66 -> 212 154 \n',
          '67 -> 11 141 \n',
          '68 -> _ 37 \n',
          '69 -> b 93 \n',
          '70 -> 22 141 \n',
          '71 -> _ 121 \n',
          '72 -> \\n 217 \n',
          '73 -> 215 _ \n',
          '74 -> 180 142 \n',
          '75 -> _ 175 \n',
          '76 -> 72 218 \n',
          '77 -> 149 204 \n',
          '78 -> 87 191 20 \n',
          '79 -> \\n 219 84 219 ! \n',
          '80 -> \\n 46 91 206 \n',
          '81 -> 220 221 \n',
          '82 -> \\n 201 \n',
          '83 -> 84 116 222 82 169 65 \n',
          '84 -> ! _ \n',
          '85 -> e t _ m 171 b \n',
          '86 -> 222 \\n \n',
          '87 -> , _ \n',
          '88 -> 169 69 \n',
          '89 -> 20 129 \n',
          '90 -> 211 91 55 \n',
          '91 -> 87 w \n',
          '92 -> 223 224 \n',
          '93 -> o x \n',
          '94 -> 130 97 \n',
          '95 -> \\n 209 \n',
          '96 -> i 225 \n',
          '97 -> 62 44 141 \n',
          '98 -> _ 169 \n',
          '99 -> 100 41 \n',
          '100 -> 94 _ \n',
          '101 -> 89 226 218 \n',
          '102 -> 227 y 153 \n',
          '103 -> n _ \n',
          '104 -> 223 e \n',
          '105 -> _ 228 \n',
          '106 -> 229 105 \n',
          '107 -> ! \\n \n',
          '108 -> 199 110 \n',
          '109 -> 127 230 55 \n',
          '110 -> 230 206 \n',
          '111 -> 231 r 232 \n',
          '112 -> 202 167 \n',
          '113 -> 233 201 \n',
          '114 -> 201 169 \n',
          '115 -> c 208 \n',
          '116 -> 114 170 \n',
          '117 -> e 20 \n',
          '118 -> 87 152 \n',
          '119 -> 188 _ \n',
          '120 -> 173 117 \n',
          '121 -> 34 93 \n',
          '122 -> 107 \\n \n',
          '123 -> 212 226 195 \n',
          '124 -> 15 159 \n',
          '125 -> 182 20 \n',
          '126 -> 198 g 234 \n',
          '127 -> 47 95 55 \n',
          '128 -> 220 164 \n',
          '129 -> I _ \n',
          '130 -> 89 132 \n',
          '131 -> 62 87 \n',
          '132 -> 235 225 \n',
          '133 -> 169 38 \n',
          '134 -> 101 _ \n',
          '135 -> A N \n',
          '136 -> Y W H E R E \n',
          '137 -> 122 11 \n',
          '138 -> g 214 103 e g \n',
          '139 -> a n \n',
          '140 -> 61 186 m \n',
          '141 -> 104 m \n',
          '142 -> 51 m \n',
          '143 -> 20 S \n',
          '144 -> _ 119 \n',
          '145 -> s a \n',
          '146 -> 151 147 \n',
          '147 -> T r 157 \n',
          '148 -> 61 119 213 \n',
          '149 -> _ 139 \n',
          '150 -> y _ \n',
          '151 -> y 20 \n',
          '152 -> 227 m \n',
          '153 -> 107 I \n',
          '154 -> l 85 \n',
          '155 -> 209 96 \n',
          '156 -> t r \n',
          '157 -> 150 141 \n',
          '158 -> 236 _ \n',
          '159 -> 138 g s 149 140 \n',
          '160 -> d o \n',
          '161 -> 84 129 \n',
          '162 -> - I - 184 \n',
          '163 -> 107 237 216 238 \n',
          '164 -> b 234 \n',
          '165 -> 166 174 \n',
          '166 -> 20 237 \n',
          '167 -> 231 228 \n',
          '168 -> 233 237 \n',
          '169 -> 239 224 \n',
          '170 -> 156 e \n',
          '171 -> e _ \n',
          '172 -> 179 g o o d m _ \n',
          '173 -> s e \n',
          '174 -> 155 178 \n',
          '175 -> 26 196 \n',
          '176 -> 19 177 \n',
          '177 -> r e \n',
          '178 -> 238 _ \n',
          '179 -> s 8 \n',
          '180 -> l i k e \n',
          '181 -> 107 T 186 n k _ 188 \n',
          '182 -> 57 152 162 \n',
          '183 -> _ 2 \n',
          '184 -> a m \n',
          '185 -> \\n 189 \n',
          '186 -> h a \n',
          '187 -> 183 162 \n',
          '188 -> y 240 \n',
          '189 -> 217 195 \n',
          '190 -> 241 m \n',
          '191 -> 2 162 \n',
          '192 -> _ o r \n',
          '193 -> _ 241 \n',
          '194 -> 209 210 \n',
          '195 -> 62 236 \n',
          '196 -> 240 173 \n',
          '197 -> W 210 \n',
          '198 -> 235 92 \n',
          '199 -> 197 188 \n',
          '200 -> 205 142 \n',
          '201 -> N 73 \n',
          '202 -> 20 201 \n',
          '203 -> 103 242 \n',
          '204 -> y w 176 \n',
          '205 -> _ 243 \n',
          '206 -> 210 188 \n',
          '207 -> a t \n',
          '208 -> a r \n',
          '209 -> 129 w \n',
          '210 -> 240 244 \n',
          '211 -> c 55 \n',
          '212 -> Y 240 _ \n',
          '213 -> m a \n',
          '214 -> 177 e \n',
          '215 -> o t \n',
          '216 -> 54 u 244 \n',
          '217 -> 129 226 \n',
          '218 -> 195 142 \n',
          '219 -> A _ 221 \n',
          '220 -> o 203 \n',
          '221 -> 156 232 \n',
          '222 -> e ! \n',
          '223 -> t h \n',
          '224 -> _ 242 \n',
          '225 -> l l _ \n',
          '226 -> d 8 \n',
          '227 -> S a \n',
          '228 -> d 208 k \n',
          '229 -> 239 51 \n',
          '230 -> 87 c \n',
          '231 -> 229 _ \n',
          '232 -> a 239 \n',
          '233 -> . _ \n',
          '234 -> o 207 \n',
          '235 -> w i \n',
          '236 -> _ 180 \n',
          '237 -> A n 61 \n',
          '238 -> 243 142 \n',
          '239 -> i n \n',
          '240 -> o u \n',
          '241 -> t 19 \n',
          '242 -> a _ \n',
          '243 -> e 207 \n',
          '244 -> l 61 \n',
          '',
        ].join(),
      );
    });
  });
}
