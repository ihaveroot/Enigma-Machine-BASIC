# Enigma


                                           .oooooo.                  brts
                                          dP'   `Y8b                 4ssk
                                          88o   .d8P                 k6jf
                           z$$$%          `"' .d8P' http://sndup.net/dt57
                        ,$$$$$               `88'                    n695
                       d$$$$"                .o.                     n692
                      $$$$$$$$c.             Y8P                     d9pz
                     $$$$$FJ$$$$$.                             .ze$$$$$$$$
                    J$$$$$>$$$$$$$$..uc$$$$$$$$$$$bcc,.    .d$$$$$$$c.
                    $$$$$$F,,`?$$$$$ $$$$$$$$$$$$$$$$$$$$c."?$$$".?$$$
                    $$$$$$$`;;;`$$$$$$$F",cud$$$$$$$$$$$$$$$$b, ;;,$$$,
                    $$$$$$$b`;;,$$$$",cd$$$$$$$$$$$$$$P???$$$$$$b,'$$$$
                    ?$$$$$$$b`,$$$P.$$$$$$$$$$$$$$$$$$$$$hc,?$$$$$$.?$"
                     $$$$$$$$$$$$P.$$$$$$$$$$$$$$$$$$$$$$$$$.3$$$$$$b
                      $$$$$$$$$$$ $$$$$$$$$P'cd$$$$$$$$$$$$$$ $$$$$$$$
                     $c?$$$$$$$$$$$$$$$$$'eb,?$$$$$$$F"$$$$$$b3$$$$$$$F
                     $$$$$$$$$$$$$$$$$$$ MMMM,?$$$$$$$"_"$$$$$$$$$$$$$$
                     $$$$$$$$$$$$$$$$$$.MMMMMM $$$$$$.MMb`$$$$$$$$$$$$$
                     "$$$$$$$$$$$$$$$$ MMMMMMM $$$$$ MMMM,?$$$$$$$$$$$$
                      ?$$$$$$$$$$$$$$'MMMMMMM" $$$$F $$$$$$$$$$$$$$$$b.
                       `$$$$$$$$$$$$$$$$$$$$$b`CCCCC>.$$$$$$$$$$$$$$$'
                         ?$$$$$$$$$$$$$$$$$$$$$P% `''d$$$$$$$$$$$$$P
                          `?$$$$$$$$$$$$$$$$$$$".$$$$$$$$$$$$$$$$$"
                              "?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P"
                                    `""..-:.?$$$$$$$$$$$PF"
                                    .$$$$$e`::."$$$$$$$$$$.:.
                           .uc,    d$$$$$$$$.:::..???""  ...:'$e
                           d$ $   $$$$$$$$$<$ : e$$ ::::::''' ""
                           $F,F  $$$$$$$$$$<$$ :."".:' ..:::::::.
                       "=c $$    $$$$$$$$$F`"":::::::::::::::::::::
                           ?$$b. `$$$$$$$$ :::::::::::::::::::::::::
                          ._"""`...?$$$$$P :::::::::::::::::::::::::
                           "$$$$$$$$$$$$$ ::::::::::::::::::::::::::
                           
An Enigma machine written in Telebasic.

Based off of the [G-312 Abwehr Enigma](https://www.cryptomuseum.com/crypto/enigma/g/index.htm) wiring.

Using Reflector Wheel B [UKW-B](https://en.wikipedia.org/wiki/Enigma_rotor_details#Rotor_wiring_tables).

With the [AAU](https://en.wikipedia.org/wiki/Enigma_rotor_details#Turnover_notch_positions) Turnover sequence.



   **Table of contents**
- [Intro](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#intro)
- [Rotor Wirings](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#rotor-wirings)
  - [More on Rotor Wiring](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#more-on-rotor-wiring)
- [Reflector Wheel](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#reflector-wheel)
- [Rotor Rotations](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#rotor-rotations)
- [Plugboards](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#plugboards)
- [Conclusion/Resources](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#conclusion)
   
# Intro
I spent a couple days just putting this together, in the original file I had given an explaination on the inner Enigma workings. This does not use an Entry Wheel (ETW) I had described that the `ALPHABET$` variable in the program can be looked at as the ETW (I understand that the ETW is an entirely different piece in the Enigma, but for this it's held in almost the same regard). It follows the AAU sequence in regards to the Turnover Notch Position.

You'll find the descriptions I had originally wrote in the table of contents for a fast reference.

To understand the analogies that I make in my descriptions, below you'll find the variables where it will act as our Rotors, Reflector Wheel and User input.

```Basic
     ALPHABET$  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
     ROTOR$(1)  = "DMTWSILRUYQNKFEJCAZBPGXOHV"
     ROTOR$(2)  = "HQZGPJTMOBLNCIFDYAWVEUSRKX"
     ROTOR$(3)  = "UQNTLSZFMREHDPXKIBVYGJCWOA"
     REFLECTOR$ = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
```

# Rotor Wirings
 Shown in the variables below would be the default state [without a plugboard and entry wheel] if all rotors were in 1,1,1 (A,A,A)
  The way [rotor wiring](https://web.stanford.edu/class/cs106j/handouts/36-TheEnigmaMachine.pdf) works is the circuit comes in from the right side of the rotor, traveling through the scrambled wiring config
  then outputs on the leftside as a different letter. Into the second rotor it then gets translated into a different wiring config where it's outputted as a different letter.
  We actually should have 6 variables pertaining to the i/o of the rotors, shown in the variables are the output state of each wiring configuration.
   It can be interpreted as such:
```
    User input:      ABCDEFGHIJKLMNOPQRSTUVWXYZ
    
    First rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
    First rotor[o]:  DMTWSILRUYQNKFEJCAZBPGXOHV
    
    Second rotor[i]: ABCDEFGHIJKLMNOPQRSTUVWXYZ
    Second rotor[o]: HQZGPJTMOBLNCIFDYAWVEUSRKX
    
    Third rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
    Third rotor[o]:  UQNTLSZFMREHDPXKIBVYGJCWOA
    
    Reflector wheel: YRUHQSLDPXNGOKMIEBFZCWVJAT
```
   The numbers that go around the rotor pertain to the numerical values of the alphabet, 01=A, 02=B, 03=C...
   User input A[i] going into the first rotor can be viewed as the 01 position pertaining to the position of A in the alphabet, which then gets scrambled by the internal wiring
    of the rotor, now has an output of D which is the 4th character and position in the alphabet. In relation to the chart above, in D position 4, would then output as G[pos 7/26] in the second rotor.
   
   Like a table, you can encode a message as it is by going down the line through each rotor with it's corresponding letter and position in the alphabet,
    so user input A[1/26] would be D[o] output in the first rotor, then position of D[4/26] in the alphabet would be the 4th position in the second rotor D[i 4/26] -> G[o 7/26], G in the third, Z[o 26/26].
   
   This example is without an entry wheel and ends in the Reflectors value[i]:
```   
    A -> D -> G -> Z -> T
    B -> M -> C -> N -> K
    C -> T -> V -> J -> X
```   
   The output position of the wiring for each rotor, when starting the circuit, pertains to the numerical position of that letter in the alphabet in the following rotor:
```   
   First rotor
                    A [i [1/26]]
   First rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   First rotor[o]:  DMTWSILRUYQNKFEJCAZBPGXOHV
                    D [o [4/26]]
   Now in position 4 in the second rotor as the input, 
                       D[i [4/26]]
   Second rotor[i]: ABCDEFGHIJKLMNOPQRSTUVWXYZ
   Second rotor[o]: HQZGPJTMOBLNCIFDYAWVEUSRKX
                       G[o [7/26]]
   Now in the third, 
                          G[i [7/26]]
   Third rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   Third rotor[o]:  UQNTLSZFMREHDPXKIBVYGJCWOA
                          Z[o [26/26]]
```
## More on Rotor Wiring
   Rotors are by default wired from an exisiting [configuration](https://en.wikipedia.org/wiki/Enigma_rotor_details#Rotor_wiring_tables). You may switch rotor configs
    at will if you'd like. I would've done so to include all wirings but I'm lazy (there's a lot), I don't foresee any problems in swapping out the rotor values.
    In the link listed above is the default state (1,1,1) of all wirings and should line up with the order of the ALPHABET$ variable.
 
   You may also switch the Reflector freely, you will find in the table seen in the link above will have UKW rotors, those can be refered as the REFLECTOR$ in the same regard.
   
   ETW rotors are also fixed like the Reflector, they serve as an extra scramble in the entry point between the first key press and the first rotor, in this case we are not using
    an entry wheel but the ALPHABET$ variable in this program can be metaphorically pictured as such. (fun fact: the Enigma I uses an unscrambled ETW)
  
   The way it can be seen is from right to left, if you were to stand the variables above in a row it would be ordered as such:
```   
               Reflector rotor 3  rotor 2  rotor  1
               --| | \   | |\     | | \  / | |  |E|<---
              |  | |  \  |1|-\ -- |1|  X   |1|  |T|   |
               --| |---\ | |  \   | |/  \  | |--|W|-  |
                                  output           |  |
                           Q A Z W S X E D C R     |  |
                            F V G T H B Y J N      |  |
                             U J M I K L O P  <----   |
                                                      |
                                 Keyboard             |  Circuit[i]
                           Q W E R T Y U I O P        |
                            A S D F G H J K L   ------|
                              Z X C V B N M 
```                              
   Many online resources may swap this, going from left to right, in it's physical state the Enigma circuit enters from the rightmost side, so I've put it in that same order.
   
   With that being said if you choose to swap out the rotors, you can follow the ascending order in the wikipedia table with the variables above.
   
   The order of the wheels in the article are just what they used historically in those machines, though you can use any variation/combination from each era in this program. (ex. Rotor I from the German railway as `ROTOR$(1)`, Rotor VIII from the M3 & M4 as `ROTOR$(2)`, and so on.)
   
   It's also possible to make up your own rotor wiring, make sure that no characters repeat and that it includes all 26 letters of the alphabet.
   
   If you choose to create your own reflector, it has to configured in the way where the swapped characters replace each others' position in the alphabet as explained [below](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#reflector-wheel).
   
# Reflector Wheel
   Continuing on to the reflector wheel, we then go up the line as it were going down, using the table above the i/o are now reversed and can be seen as:
```   
   User input:      ABCDEFGHIJKLMNOPQRSTUVWXYZ
   
   First rotor[o]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   First rotor[i]:  DMTWSILRUYQNKFEJCAZBPGXOHV
   
   Second rotor[o]: ABCDEFGHIJKLMNOPQRSTUVWXYZ
   Second rotor[i]: HQZGPJTMOBLNCIFDYAWVEUSRKX
   
   Third rotor[o]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   Third rotor[i]:  UQNTLSZFMREHDPXKIBVYGJCWOA
   
   Reflector wheel: YRUHQSLDPXNGOKMIEBFZCWVJAT
```   
   The Reflector wheel is in a fixed position [no rotation], and prevents the encoding of the original character being sent, A[i] cannot have a final output of A[o].
   
   This is seen as a vulnerability for code breakers. You'll find that A encodes as Y and Y encodes as A, B encodes as R and R encodes as B.
    this is pertaining to the position of the input going in the reflector, taking the position of the encoded character in relation to the
    alphabetical position as the encoded character output.
```    
       Third rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
       Third rotor[o]:  UQNTLSZFMREHDPXKIBVYGJCWOA
                                           Y[o[rot3] pos[25/26 in alphabet, 1/26 in ref] enc as A[1/26 in alphabet, 25/26 in ref]]
            Reflector: YRUHQSLDPXNGOKMIEBFZCWVJAT
                                               A[o[ref] pos[25/26]]
```                                               
   Shown as generalization in this example, you can see that the numerical order of the two characters are swapped in the reflector, Y is in pos 1/26 and A is in the 25th.
   
   From the reflector, it acts as a map of sorts, from the last example, in the Rotor wiring section, we have an output of Z[o 26/26] from the third rotor which is the 26th letter of the alphabet.
   This then translates to the 26th position in the Reflector, shown as T.
```basic
     REFLECTOR$ = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
```
   
   The relay goes back through the third rotor, looking for the letter now T, it get's the position of T in the third rotor, which then
    gives us our output when we compare it to that of the numerical position of the alphabet.
```    
     User input:      ABCDEFGHIJKLMNOPQRSTUVWXYZ
   
     First rotor[o]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
     First rotor[i]:  DMTWSILRUYQNKFEJCAZBPGXOHV
   
     Second rotor[o]: ABCDEFGHIJKLMNOPQRSTUVWXYZ
     Second rotor[i]: HQZGPJTMOBLNCIFDYAWVEUSRKX
   
     Third rotor[o]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
     Third rotor[i]:  UQNTLSZFMREHDPXKIBVYGJCWOA
   
     Reflector wheel: YRUHQSLDPXNGOKMIEBFZCWVJAT
       
   A ... Z[from the third rotor, we go to pos 26 in the ref] -> T[pos in ref 26/26] -> D -> P -> final output U
       After translating the numerical position of the character in the third rotor to the character position of the Reflector,
        we find that T is in that position and now we go back to the third rotor to find T and find that it is in the 4th position,
         in that of the alphabet we get an output of D.
         
   B ... N[from the third rotor, we go to pos 14 in the ref] -> K[pos in ref 14/26] -> P -> E -> final output O
       K is in the 16th position, we get an output of P.
       
   C ... J[from the third rotor, we go to pos 10 in the ref] -> X[pos in ref 10/26] -> O -> I -> final output F
       X is in the 15th position, we get an output of O
```

   Shown below is a full cycle, demonstrated if the user presses the key A:
```   
    User input:      ABCDEFGHIJKLMNOPQRSTUVWXYZ
                   1.A[i]             14.U[o our final output is the letter U]
    First rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
    First rotor[o]:  DMTWSILRUYQNKFEJCAZBPGXOHV
                   2.D[o]             13.P[i]
                      3.D[i]     12.P[o]
    Second rotor[i]: ABCDEFGHIJKLMNOPQRSTUVWXYZ
    Second rotor[o]: HQZGPJTMOBLNCIFDYAWVEUSRKX
                      4.G[o]     11.D[i]
                     10.D5.G[i]
    Third rotor[i]:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
    Third rotor[o]:  UQNTLSZFMREHDPXKIBVYGJCWOA
                      9.T6.Z[o]
                                            7.Z[i]
    Reflector wheel: YRUHQSLDPXNGOKMIEBFZCWVJAT
                                            8.T[looking for pos of T in the third wheel we go back to complete the circuit]
```                                            
# Rotor Rotations
   The output however, of the examples above are based entirely on it being the first key press of the encryption process, without any rotation.
    If it were in seqence then the first rotor would shift accordingly, if the first rotor exceeds 26 turns then it would
    shift the second rotor 1 step, if the second exceedes 26 then the third would step 1 and so on.
   
   There are various Turnover notch position configurations, which would turn the second rotor if it were hit, other machines might turn over when the rotor steps 
    from Q to R, another may step when the first rotor goes from E to F. For this program it will follow the AAU sequence (steps normally).
    
   The rotor rotation is entirely mechanical in the Enigma so in the beginning the first key press will rotate the first rotor once before it starts the encryption sequence.
  
   Starting from a rotor configuration of 1,1,1:
```   
   A -> M -> C -> N -> K -> P -> E -> N     (first key press)  [1,1,2]
   B -> W -> S -> V -> W -> X -> Z -> Q     (second key press) [1,1,3]
   C -> I -> O -> X -> J -> V -> T -> Z     (third key press)  [1,1,4]
```   
   In this example all rotors are in their default state of 1, by the third key press, the first rotor is in position 4.   
```
 rotor3  rotor2  rotor1
    1      1       4
 ```
   The letter changes from B -> M to now B -> W in the first rotor, if it were the second key press.
   
   To visualize this change hitting a key will shift the first rotor once, before the letter passes through the first rotor.
```   
   A hit
   First rotor:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   First rotor:  MTWSILRUYQNKFEJCAZBPGXOHVD
   B hit
   First rotor:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   First rotor:  TWSILRUYQNKFEJCAZBPGXOHVDM
   C hit
   First rotor:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
   First rotor:  WSILRUYQNKFEJCAZBPGXOHVDMT
```   
   Spamming A say 5 times in sequence in it's default state (1,1,1) will output `NDPDX` (1,1,6).
# Plugboards   
   With the use of plugboards it can be seen as a manual wiring configuration in relation to a rotor. 
   
   You can configure the plug boards to change the input and output of the result
   
   The workflow in an Enigma is as follows:
   + Key press
   + Plugboard
   + Rotors
   + Plugboard
   + Output
   
   The plugboard comes in pairs, linking two letters together.
   for a maximum of 13 possible seperate configurations, none repeating.
```   
   ZD  BE  CF  GJ  HK  IL  MP  NQ  OR  SV  TW  UX  YA
```   
   This would mean that if the first key press being A it would first be translated to Y pertaining to the plugboard config then it would start the
    circuit in the rotors now being V in the first [1,1,2] (the first rotor takes in the input and position as it is, plugboard or not) 
    with an output of H when the circuit ends (rotor 1,2,3,Reflector,3,2,1), now back into the plugboard configuration seen above H now has a final output of K.
   
   The plugboard pairs intertwine with one another, for example A cannot translate into K as it is paired with Y given the config seen above.
   
   The plugboard may take all 13 different combinations if the user so wishes to do so, it is also possible to do less or none at all, though they must be paired and none repeating.
   
   The circuit with a plugboard as seen in the original machine would be as follows:
```   
               Reflector rotor 3  rotor 2  rotor  1
               --| | \ / | |  \   | |   \  | | /|E| <-------
              |  | | /\  |1|===\==|1|    \ |1|//|T| ===|   |
               ==| |/  \ | |    \ | |=====\| |/ |W|    |   |
                                  output               |   |
                           Q A Z W S X E D C R         |   |
                 ========>  F V G T H B Y J N          |   |
                 |           U J M I K L O P           |   |
                 |     =========[o]=====================   |
                 |    |          Keyboard                  |   
                 |    |    Q W E R T Y U I O P             | 
                 |    |     A S D F G H J K L   ----       |  
                 |    |       Z X C V B N M        |       |  
                 |    |                            | [i]   |      
                 |    |          Plugboard         |       |  
                 |    |    Q W E-R T Y-U I\ O P <---       |  
                 |    ====> A S D-F G\ H-J \K L -----------|
                 ====[o]===  Z X-C V  \B N M
```                 
# Conclusion
   Hopefully now you have a (somewhat) good understanding of the Enigma machine and it's workings, this is how I understood its functionality through my research, and now reflected in the program's code.
   
   It will also have comments explaining what the subroutines, and code are doing, in the file itself. This was made for Telebasic, some functionality may be limited depending on the interpreter you are using.

Some resources:
 - [Crypto Museum](https://www.cryptomuseum.com/crypto/enigma/index.htm)
 - [Wikipedia](https://en.wikipedia.org/wiki/Enigma_rotor_details)
 - [Stanford](https://web.stanford.edu/class/cs106j/handouts/36-TheEnigmaMachine.pdf)
 - [Cornell (arXiv)](https://arxiv.org/pdf/2004.09982.pdf)
 - [UoRegina](https://uregina.ca/~kozdron/Teaching/Cornell/135Summer06/Handouts/enigma.pdf)
 - [The Imitation Game](https://g.co/kgs/WSduUz)

[top :arrow_up_small:](https://github.com/ihaveroot/Enigma-Machine-BASIC-/edit/main/README.md#enigma)
