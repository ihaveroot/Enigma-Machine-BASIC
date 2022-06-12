        ' Our variables
        ALPHABET$  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ROTOR$(1)  = "DMTWSILRUYQNKFEJCAZBPGXOHV"
        ROTOR$(2)  = "HQZGPJTMOBLNCIFDYAWVEUSRKX"
        ROTOR$(3)  = "UQNTLSZFMREHDPXKIBVYGJCWOA"
        REFLECTOR$ = "YRUHQSLDPXNGOKMIEBFZCWVJAT"

        CRESET$ = CHR$(27) + "[38;5;15m"
        YELLOW$ = CHR$(27) + "[38;5;11m"

        CLS

        PRINT TAB(14) CHR$(27) + "[38;5;105mdMMMMMP dMMMMb  dMP .aMMMMP dMMMMMMMMb  .aMMMb"
        PRINT TAB(13) CHR$(27) + "[38;5;104mdMP     dMP dMP amr dMP'    dMP'dMP'dMP dMP'dMP"
        PRINT TAB(12) CHR$(27) + "[38;5;103mdMMMP   dMP dMP dMP dMP MMP'dMP dMP dMP dMMMMMP"
        PRINT TAB(11) CHR$(27) + "[38;5;102mdMP     dMP dMP dMP dMP.dMP dMP dMP dMP dMP dMP"
        PRINT TAB(10) CHR$(27) + "[38;5;101mdMMMMMP dMP dMP dMP  VMMMP' dMP dMP dMP dMP dMP" CHR$(10) CRESET$
        SLEEP 1.3
        PRINT TAB(10) "            created by: ihaveroot"
        PRINT TAB(10) " Based off of the G-312 Abwehr Enigma wiring (1941)"
        PRINT TAB(10) "        With Reflector wheel B (UKW-B)" CHR$(10) CHR$(10)
        SLEEP 1.3
        PRINT TAB(10) "  How do I use?"
        PRINT TAB(10) "   I have written a very lengthly detailed description"
        PRINT TAB(10) "   on how an Enigma machine operates. It's workings,"
        PRINT TAB(10) "   wiring, rotor, and plugboard configurations, are in the"
        PRINT TAB(10) "   source of this program. Please cat the file if"
        PRINT TAB(10) "   you have any questions." CHR$(10)
        PRINT TAB(10) "  Currently it does not take in white spaces,"
        PRINT TAB(10) "   even though I allow it in the input, any white"
        PRINT TAB(10) "   spaces in the input will be replaced by a random character"
        PRINT TAB(10) "   in the output, given the rotation value of the rotors,"
        PRINT TAB(10) "   it could be T, Z, X, etc."
        PRINT TAB(10) "   ex of a decrypted output:"
        PRINT TAB(10) "       HELLOPWORLD"
        PRINT TAB(10) "       IQAMQHAPPYQTODAY"
        PRINT TAB(10) "  I apologize for this failure"
        PRINT TAB(10) "  However a string with no spaces will output without any"
        PRINT TAB(10) "   extra characters inbetween" CHR$(10)
        PRINT TAB(10) "  If you don't like to read, you may try to decrypt the"
        PRINT TAB(10) "    message found below with the configs shown, and hopefully,"
        PRINT TAB(10) "    you'll get the idea:" CHR$(10)
        PRINT TAB(10) "  ROTOR 1: " YELLOW$ "12" CRESET$
        PRINT TAB(10) "  ROTOR 2: " YELLOW$ "21" CRESET$
        PRINT TAB(10) "  ROTOR 3: " YELLOW$ "19" CRESET$
        PRINT TAB(10) "  PLUGBOARD: " YELLOW$ "BE RY TZ HG OD" CRESET$
        PRINT TAB(10) "  ENCRYPTED MESSAGE: " YELLOW$ "JDTIMGCPGAQIOHBNKDM" CRESET$



1   ' CONFIG FOR ROTORS, AND PLUGBOARD
    PRINT CHR$(10)
    PRINT "    Rotor rotation config. "
    PRINT "     make sure the values do not exceed 26 and are not less than 1."
    PRINT "    ROTOR CONFIG [1-26]: "
    INPUT "    ROTOR 1: ", ROT(1)
    INPUT "    ROTOR 2: ", ROT(2)
    INPUT "    ROTOR 3: ", ROT(3)

    UROTVAL$ = STR$(ROT(1)) + CHR$(32) + STR$(ROT(2)) + CHR$(32) + STR$(ROT(3))  ' users choice stored in the variable for presentation later.

    ' simple check... stick with the length of the english alphabet characters...
    FOR I = 1 TO 3
        IF ROT(I) > 26 OR ROT(I) < 1 THEN PRINT "   ROTATION VALUES MUST NOT BE GREATER THAN 26 OR LESS THAN 1: ERROR IN ROTOR " STR$(I) " VALUE" : GOTO 1
    NEXT I

    PRINT
    INPUT " Would you like to configure your plugboard? (Default None) [Y/n]: ", YNPROMPT$
    IF YNPROMPT$ = "Y" THEN GOSUB 100


    ' We collect the users rotor rotation config and apply it to each rotor in line 98
    GOSUB 98 





2   ' GET USER'S INPUT AND THEN TRANSLATE THAT INTO THE PLUGBOARD CONF.
    PRINT CHR$(10) " Pertaining true to life special characters, and numbers will be omitted."
    INPUT " Input your message [Encrypted text/Text to encrypt]: ", UINPUT$

    ' Just in case, remove double spaces and all non letter characters.
    ' If there is a white space in the message, then it will be replaced with the letter Z
    '  as there is no room for white spaces, I would've made a fix for this, but I'm sure
    '  the user can figure out what it reads when decrypted.
    UMESSAGE$ = UPS$(TH_SED$(TH_SED$(UINPUT$, "\s{2,}", " ", "gi"), "(\@|\$|\.|\,|\?|\&|\*|\(|\)|\[|\]|\{|\}|\|\%|\!|\+|\-|\`|\<|\>|\||\\|\/|\=|\;|\:|\"+CHR$(34)+"|\'|\#|\%|\^|\_|\~|\d)", "", "gi"))

    ' Goto plugboard substitution if they answered yes, otherwise the message will stay the same.
    ' We have a configuration number, to track the state of the encryption being passed through the subroutines.
    ' CONFIGNUM with a value of 2 will be the output of the rotors, and then will be passed back through the
    '  plugboard if the user has configured one. Otherwise, it will have a constant value of 1 which shown below
    '  will be our message without the plugboard scrambling.
    CONFIGNUM = 1
    IF YNPROMPT$ = "Y" THEN GOSUB 99        : MESSAGE$(CONFIGNUM) = UPBMESSAGE$
    IF YNPROMPT$ = "" OR YNPROMPT$ = "N" THEN MESSAGE$(CONFIGNUM) = UMESSAGE$





3   ' START ENCRYPT PROCESS.
    ' We need to get the position of each character according to the user's message
    '  bring that into the first rotor, where it's corresponding character output
    '  position will be brought into the second and so forth.
    ' We get the position of each letter from the user input in relation to the ALPHABET$ var, from there each position
    '  goes through the line of rotors until the circuit is complete.
    ' First we call line 97 subroutine to rotate the rotors per key press, and then we start the process,
    '  at the end of the loop we jump to the plugboard config [line 99], if the user had chosen to configure it,
    '  then back to loop for our second letter.


    FOR I = 1 TO LEN(MESSAGE$(CONFIGNUM))
    GOSUB 97       
        BUFPOS = POS(ALPHABET$, MID$(MESSAGE$(CONFIGNUM), I, 1))         ' Starts off by getting the first letter in the message
        FOR J = 1 TO 2
            BUFPOS = POS(ALPHABET$, MID$(ROTORROTATION$(J), BUFPOS, 1))  ' This goes through each rotor in ascending order, getting it's position and it's output character.
        NEXT J
    BUFPOS = POS(ALPHABET$, MID$(ROTORROTATION$(3), BUFPOS, 1))          ' Here we get our rotor 3 output and now we also get our
    BUFPOS = POS(ROTORROTATION$(3), MID$(REFLECTOR$, BUFPOS, 1))         '  reflector character, which will then be located in the third rotor.
        FOR K = 2 TO 1 STEP -1
            BUFPOS = POS(ROTORROTATION$(k), MID$(ALPHABET$, BUFPOS, 1))  ' now reversed, in descending order, we start with rotor 2 and work our way up to 1 back up the circuit.
        NEXT K
    CIRCCOMPLETE$ = CIRCCOMPLETE$ + MID$(ALPHABET$, BUFPOS, 1)           ' We then get our final output from the position of the char from the first rotor to the alphabet pos.
    NEXT I

    ' Output of all 3 rotors now become our final message in array MESSAGE$(1), CONFIGNUM 1
    '  if there is no plugboard config. Otherwise our final output message will be
    '  MESSAGE$(2) using the UPBMESSAGE$ as it's output, CONFIGNUM 2.
    MESSAGE$(CONFIGNUM) = CIRCCOMPLETE$

    ' We go back to the plugboard config, if the user had configured one,
    '  otherwise output the encrypted message.
    IF YNPROMPT$ = "Y" THEN CONFIGNUM = 2 : GOSUB 99 : MESSAGE$(2) = UPBMESSAGE$


    ' Print off the users rotor configuration and output
    PRINT CHR$(10) TAB(5) "This is your configuration, if you would like to decrypt"
    PRINT TAB(5)          " your encrypted message, you must make a note of the rotor and plugboard values"
    PRINT TAB(5)          " that you may have selected, and input those values along with your encrypted message."
    PRINT CHR$(10) TAB(5) "ROTOR VALUES:"
    PRINT TAB(5) YELLOW$ UROTVAL$ CRESET$

    IF PINP$  = "" OR  PINP$  = " " THEN PRINT TAB(5) "PLUGBOARD CONF: " YELLOW$ "NONE"      CRESET$
    IF PINP$ <> "" AND PINP$ <> " " THEN PRINT TAB(5) "PLUGBOARD CONF: " YELLOW$ UPS$(PINP$) CRESET$

    PRINT TAB(5) "OUTPUT: "
    PRINT TAB(5) "======="
    PRINT TAB(5) YELLOW$ MESSAGE$(CONFIGNUM) CRESET$ CHR$(10)

    INPUT "     Would you like to encrypt/decrypt another message? [Y/n]", ANOTHER$
    IF ANOTHER$ = "Y" THEN GOTO 4
    IF ANOTHER$ = "N" OR ANOTHER$ = "" OR ANOTHER$ = " " THEN END

    ' All in all, this is just a subsitution cipher, a 76-bit encryption key, what made it such a formidable opponent during the World War is the
    '  fact that the configuration was changed each month. with 3 rotor settings at 26 different positions, and the original plugboard
    '  config of 10 pairs of letters connected, it gave a whopping 158,962,555,217,826,360,000 different possible setting combinations (for the current enigma being used,
    '  I believe would've been the M4 iirc).
    ' You can view the resources at the end of this program if you'd like to learn more. These are the resources I used to create this as well as the inspired.

4 ' Reset everything if we go again
    FOR I = 1 TO 20
        ROT(I) = 0
        PINPUT$ = ""
        MESSAGE$(I) = ""
        UPBMESSAGE$ = ""
        LETTERCOUNT = 0
        CIRCCOMPLETE$ = ""
        PBOARDCONF$(I) = ""
        ROTORROTATION$(I) = ""
    NEXT I
GOTO 1




97 ' ROTOR ROTATION
    ' Check to see if any rotors need resetting as we will always add 1 in the formula for rotor 1's rotation before each circuit.
    ' This will have a domino effect if all are edging on the 26th rotation, when rotor 3 max's out nothing happens except a reset.
    ROT(1) = ROT(1) + 1
    IF ROT(1) = 27 THEN ROT(1) = 1 : ROT(2) = ROT(2) + 1
    IF ROT(2) = 27 THEN ROT(2) = 1 : ROT(3) = ROT(3) + 1
    IF ROT(3) = 27 THEN ROT(3) = 1 
98  ' ROTOR REORIENTATION
    ' This reorients the rotor to it's corresponding rotation, chosen by the user, each rotors value will change progressively, given the 
    '  alphabetical characters passing through with each complete circuit.
    ' A rotation value of 5 for rotor 1 will be the following
    ' SILRUYQNKFEJCAZBPGXOHVDMTW
    ' Whereas it's default rotation value is
    ' DMTWSILRUYQNKFEJCAZBPGXOHV
    ' You are picking the 5th letter in the rotation, subtracting 26 instead of 27, would've yielded the 6th letter rather than the 5th.
    FOR K = 1 TO 3
       ROTORROTATION$(K) = RIGHT$(ROTOR$(K), VAL(ABS(27 - ROT(K)))) + LEFT$(ROTOR$(K), VAL(ROT(K) - 1))
    NEXT K
RETURN




99 ' PLUGBOARD SUBSTITUTION
    ' We need to do this twice, if the user configured it.
    UPBMESSAGE$ = ""                                  ' We need to clear this, after the first step, so there's no conflict when it comes back again.
    IF CONFIGNUM = 1 THEN MESSAGE$(1) = UMESSAGE$     ' The users first message, being passed through.
    IF CONFIGNUM = 2 THEN MESSAGE$(2) = CIRCCOMPLETE$ ' The end encrypted message will be CIRCCOMPLETE$, after it has passed through
                                                      '  all rotors, it will come back here, to then output our final encrypted message.

    ' Here we will compare the plugboard arrays to the users message.
    ' Replacing the characters appropriately pertaining to the second step in the Enigma workflow as well as the last.
    ' Not only will we have to make sure that it's in the correct order in regards to the key press sequence
    '  but we will also have to replace that letter with the substitute.
    ' For loop to 13, 13 pairs, 13 possible arrays, we then just do a right and left to remove the existing character with the 
    '  substitute. if the position of the subsitute is on the right side say config BE, replacing the letter B with E, then we get every
    '  character left in the message - 1 to remove that existing character then we add the right side which will be the letter E in this case.
    ' Vice versa if we are replacing E with B, we add with the Left side of the array.
    ' Not sure how I could chop this down, but it works as intended.
    FOR I = 1 TO LEN(MESSAGE$(CONFIGNUM))
    UPBMESSAGE$ = UPBMESSAGE$ + MID$(MESSAGE$(CONFIGNUM), I, 1)
    IF I = LEN(MESSAGE$(CONFIGNUM)) THEN RETURN
        FOR J = 1 TO 13
            IF POS(PBOARDCONF$(J), MID$(MESSAGE$(CONFIGNUM), I, 1)) = 1 THEN UPBMESSAGE$ = LEFT$(UPBMESSAGE$, I - 1) + RIGHT$(PBOARDCONF$(J), 1) : NEXT I
            IF POS(PBOARDCONF$(J), MID$(MESSAGE$(CONFIGNUM), I, 1)) = 2 THEN UPBMESSAGE$ = LEFT$(UPBMESSAGE$, I - 1) + LEFT$(PBOARDCONF$(J), 1)  : NEXT I
        NEXT J
    NEXT I
RETURN




100 ' PLUGBOARD CONFIGURATION
    PRINT CHR$(10) "    Please enter in your desired combinations for a maximum of 13, seperated by a whitespace between each pair."
    PRINT          "    Please ensure that no two pairs are the same and none repeat the same character."
    PRINT          "    Ex of a full table/input: ZD BE CF GJ HK IL MP NQ OR SV TW UX YA"
    PRINT          "    Leave blank to go back." CHR$(10)
    INPUT          "      :~] ", PINP$

    ' Check if field is blank
    IF PINP$ = "" OR PINP$ = " " THEN RETURN

    ' Removing any double white spaces. It'll fuck with the array splitting
    PINPUT$ = UPS$(TH_SED$(PINP$, "\s{2,}", " ", "gi"))

    ' 3 letter check, someone will fuck up.
    FOR I = 1 TO LEN(PINPUT$)
        IF MID$(PINPUT$, I, 1) <> CHR$(32) THEN LETTERCOUNT = LETTERCOUNT + 1
        IF MID$(PINPUT$, I, 1)  = CHR$(32) THEN LETTERCOUNT = 0
        IF LETTERCOUNT >= 3 THEN PRINT TAB(4) "ERROR: 3 LETTER COUNT DETECTED, PLUGBOARD CONFIG ONLY ACCEPTS PAIRS OF CHARACTERS." : LETTERCOUNT = 0 : GOTO 100
    NEXT I

    ' Duplicate check, someone will fuck up.
    FOR J = 1 TO 26
        IF TH_RE(PINPUT$, MID$(ALPHABET$, J, 1), 1) > 1 THEN PRINT TAB(4) "ERROR: DUPLICATE DETECTED, PLEASE ENSURE THERE ARE NO DUPLICATED CHARACTERS" : GOTO 100
    NEXT J

    ' Array splitting values.
    ' Wasn't sure how to approach this, but it turned out alright.
    ' We split each pair into their own array, which will then be put in a for loop that will compare
    '  each letter of the message to the plugboard arrays, replacing the characters accordingly.
    BUF$ = ""
    DELIM$ = " "
    MAXARRAY = 0
110 ' Array splitting, the process of encryption has started as we will replace the corresponding character in the users message in line 99
    FOR I = 1 TO LEN(PINPUT$)
        IF MID$(PINPUT$, I, 1) = DELIM$ THEN GOTO 110.00006
        BUF$ = BUF$ + MID$(PINPUT$, I, 1)
        IF I = LEN(PINPUT$) THEN GOTO 110.00006
    NEXT I
        MAXARRAY = MAXARRAY + 1
        PBOARDCONF$(MAXARRAY) = BUF$
        BUF$ = ""
        IF I <> LEN(PINPUT$) THEN GOTO 110.00005
    RETURN
RETURN
