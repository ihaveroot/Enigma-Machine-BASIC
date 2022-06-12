        REM Our variables
        ALPHABET$  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ROTOR$(1)  = "DMTWSILRUYQNKFEJCAZBPGXOHV"
        ROTOR$(2)  = "HQZGPJTMOBLNCIFDYAWVEUSRKX"
        ROTOR$(3)  = "UQNTLSZFMREHDPXKIBVYGJCWOA"
        REFLECTOR$ = "YRUHQSLDPXNGOKMIEBFZCWVJAT"

        CRESET$ = CHR$(27) + "[38;5;15m"
        YELLOW$ = CHR$(27) + "[38;5;11m"

        CLS

        PRINT TAB(14) CHR$(27) + "[38;5;105mdMMMMMP dMMMMb  dMP .aMMMMP dMMMMMMMMb  .aMMMb"
        PRINT TAB(13) CHR$(27) + "[38;5;104mdMP     dMP dMP amr dMPREM    dMP'dMP'dMP dMP'dMP"
        PRINT TAB(12) CHR$(27) + "[38;5;103mdMMMP   dMP dMP dMP dMP MMP'dMP dMP dMP dMMMMMP"
        PRINT TAB(11) CHR$(27) + "[38;5;102mdMP     dMP dMP dMP dMP.dMP dMP dMP dMP dMP dMP"
        PRINT TAB(10) CHR$(27) + "[38;5;101mdMMMMMP dMP dMP dMP  VMMMPREM dMP dMP dMP dMP dMP" CHR$(10) CRESET$
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



1   REM CONFIG FOR ROTORS, AND PLUGBOARD
    PRINT CHR$(10)
    PRINT "    Rotor rotation config. "
    PRINT "     make sure the values do not exceed 26 and are not less than 1."
    PRINT "    ROTOR CONFIG [1-26]: "
    INPUT "    ROTOR 1: ", ROT(1)
    INPUT "    ROTOR 2: ", ROT(2)
    INPUT "    ROTOR 3: ", ROT(3)

    UROTVAL$ = STR$(ROT(1)) + CHR$(32) + STR$(ROT(2)) + CHR$(32) + STR$(ROT(3))  REM users choice stored in the variable for presentation later.

    REM simple check... stick with the length of the english alphabet characters...
    FOR I = 1 TO 3
        IF ROT(I) > 26 OR ROT(I) < 1 THEN PRINT "   ROTATION VALUES MUST NOT BE GREATER THAN 26 OR LESS THAN 1: ERROR IN ROTOR " STR$(I) " VALUE" : GOTO 1
    NEXT I

    PRINT
    INPUT " Would you like to configure your plugboard? (Default None) [Y/n]: ", YNPROMPT$
    IF YNPROMPT$ = "Y" THEN GOSUB 100


    REM We collect the users rotor rotation config and apply it to each rotor in line 98
    GOSUB 98 





2   REM GET USER'S INPUT AND THEN TRANSLATE THAT INTO THE PLUGBOARD CONF.
    PRINT CHR$(10) " Pertaining true to life special characters, and numbers will be omitted."
    INPUT " Input your message [Encrypted text/Text to encrypt]: ", UINPUT$

    REM Just in case, remove double spaces and all non letter characters.
    REM If there is a white space in the message, then it will be replaced with the letter Z
    REM  as there is no room for white spaces, I would've made a fix for this, but I'm sure
    REM  the user can figure out what it reads when decrypted.
    UMESSAGE$ = UPS$(TH_SED$(TH_SED$(UINPUT$, "\s{2,}", " ", "gi"), "(\@|\$|\.|\,|\?|\&|\*|\(|\)|\[|\]|\{|\}|\|\%|\!|\+|\-|\`|\<|\>|\||\\|\/|\=|\;|\:|\"+CHR$(34)+"|\'|\#|\%|\^|\_|\~|\d)", "", "gi"))

    REM Goto plugboard substitution if they answered yes, otherwise the message will stay the same.
    REM We have a configuration number, to track the state of the encryption being passed through the subroutines.
    REM CONFIGNUM with a value of 2 will be the output of the rotors, and then will be passed back through the
    REM  plugboard if the user has configured one. Otherwise, it will have a constant value of 1 which shown below
    REM  will be our message without the plugboard scrambling.
    CONFIGNUM = 1
    IF YNPROMPT$ = "Y" THEN GOSUB 99        : MESSAGE$(CONFIGNUM) = UPBMESSAGE$
    IF YNPROMPT$ = "" OR YNPROMPT$ = "N" THEN MESSAGE$(CONFIGNUM) = UMESSAGE$





3   REM START ENCRYPT PROCESS.
    REM We need to get the position of each character according to the user's message
    REM  bring that into the first rotor, where it's corresponding character output
    REM  position will be brought into the second and so forth.
    REM We get the position of each letter from the user input in relation to the ALPHABET$ var, from there each position
    REM  goes through the line of rotors until the circuit is complete.
    REM First we call line 97 subroutine to rotate the rotors per key press, and then we start the process,
    REM  at the end of the loop we jump to the plugboard config [line 99], if the user had chosen to configure it,
    REM  then back to loop for our second letter.


    FOR I = 1 TO LEN(MESSAGE$(CONFIGNUM))
    GOSUB 97       
        BUFPOS = POS(ALPHABET$, MID$(MESSAGE$(CONFIGNUM), I, 1))         REM Starts off by getting the first letter in the message
        FOR J = 1 TO 2
            BUFPOS = POS(ALPHABET$, MID$(ROTORROTATION$(J), BUFPOS, 1))  REM This goes through each rotor in ascending order, getting it's position and it's output character.
        NEXT J
    BUFPOS = POS(ALPHABET$, MID$(ROTORROTATION$(3), BUFPOS, 1))          REM Here we get our rotor 3 output and now we also get our
    BUFPOS = POS(ROTORROTATION$(3), MID$(REFLECTOR$, BUFPOS, 1))         REM  reflector character, which will then be located in the third rotor.
        FOR K = 2 TO 1 STEP -1
            BUFPOS = POS(ROTORROTATION$(k), MID$(ALPHABET$, BUFPOS, 1))  REM now reversed, in descending order, we start with rotor 2 and work our way up to 1 back up the circuit.
        NEXT K
    CIRCCOMPLETE$ = CIRCCOMPLETE$ + MID$(ALPHABET$, BUFPOS, 1)           REM We then get our final output from the position of the char from the first rotor to the alphabet pos.
    NEXT I

    REM Output of all 3 rotors now become our final message in array MESSAGE$(1), CONFIGNUM 1
    REM  if there is no plugboard config. Otherwise our final output message will be
    REM  MESSAGE$(2) using the UPBMESSAGE$ as it's output, CONFIGNUM 2.
    MESSAGE$(CONFIGNUM) = CIRCCOMPLETE$

    REM We go back to the plugboard config, if the user had configured one,
    REM  otherwise output the encrypted message.
    IF YNPROMPT$ = "Y" THEN CONFIGNUM = 2 : GOSUB 99 : MESSAGE$(2) = UPBMESSAGE$


    REM Print off the users rotor configuration and output
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

    REM All in all, this is just a subsitution cipher, a 76-bit encryption key, what made it such a formidable opponent during the World War is the
    REM  fact that the configuration was changed each month. with 3 rotor settings at 26 different positions, and the original plugboard
    REM  config of 10 pairs of letters connected, it gave a whopping 158,962,555,217,826,360,000 different possible setting combinations (for the current enigma being used,
    REM  I believe would've been the M4 iirc).
    REM You can view the resources at the end of this program if you'd like to learn more. These are the resources I used to create this as well as the inspired.

4 REM Reset everything if we go again
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




97 REM ROTOR ROTATION
    REM Check to see if any rotors need resetting as we will always add 1 in the formula for rotor 1's rotation before each circuit.
    REM This will have a domino effect if all are edging on the 26th rotation, when rotor 3 max's out nothing happens except a reset.
    ROT(1) = ROT(1) + 1
    IF ROT(1) = 27 THEN ROT(1) = 1 : ROT(2) = ROT(2) + 1
    IF ROT(2) = 27 THEN ROT(2) = 1 : ROT(3) = ROT(3) + 1
    IF ROT(3) = 27 THEN ROT(3) = 1 
98  REM ROTOR REORIENTATION
    REM This reorients the rotor to it's corresponding rotation, chosen by the user, each rotors value will change progressively, given the 
    REM  alphabetical characters passing through with each complete circuit.
    REM A rotation value of 5 for rotor 1 will be the following
    REM SILRUYQNKFEJCAZBPGXOHVDMTW
    REM Whereas it's default rotation value is
    REM DMTWSILRUYQNKFEJCAZBPGXOHV
    REM You are picking the 5th letter in the rotation, subtracting 26 instead of 27, would've yielded the 6th letter rather than the 5th.
    FOR K = 1 TO 3
       ROTORROTATION$(K) = RIGHT$(ROTOR$(K), VAL(ABS(27 - ROT(K)))) + LEFT$(ROTOR$(K), VAL(ROT(K) - 1))
    NEXT K
RETURN




99 REM PLUGBOARD SUBSTITUTION
    REM We need to do this twice, if the user configured it.
    UPBMESSAGE$ = ""                                  REM We need to clear this, after the first step, so there's no conflict when it comes back again.
    IF CONFIGNUM = 1 THEN MESSAGE$(1) = UMESSAGE$     REM The users first message, being passed through.
    IF CONFIGNUM = 2 THEN MESSAGE$(2) = CIRCCOMPLETE$ REM The end encrypted message will be CIRCCOMPLETE$, after it has passed through
                                                      REM  all rotors, it will come back here, to then output our final encrypted message.

    REM Here we will compare the plugboard arrays to the users message.
    REM Replacing the characters appropriately pertaining to the second step in the Enigma workflow as well as the last.
    REM Not only will we have to make sure that it's in the correct order in regards to the key press sequence
    REM  but we will also have to replace that letter with the substitute.
    REM For loop to 13, 13 pairs, 13 possible arrays, we then just do a right and left to remove the existing character with the 
    REM  substitute. if the position of the subsitute is on the right side say config BE, replacing the letter B with E, then we get every
    REM  character left in the message - 1 to remove that existing character then we add the right side which will be the letter E in this case.
    REM Vice versa if we are replacing E with B, we add with the Left side of the array.
    REM Not sure how I could chop this down, but it works as intended.
    FOR I = 1 TO LEN(MESSAGE$(CONFIGNUM))
    UPBMESSAGE$ = UPBMESSAGE$ + MID$(MESSAGE$(CONFIGNUM), I, 1)
    IF I = LEN(MESSAGE$(CONFIGNUM)) THEN RETURN
        FOR J = 1 TO 13
            IF POS(PBOARDCONF$(J), MID$(MESSAGE$(CONFIGNUM), I, 1)) = 1 THEN UPBMESSAGE$ = LEFT$(UPBMESSAGE$, I - 1) + RIGHT$(PBOARDCONF$(J), 1) : NEXT I
            IF POS(PBOARDCONF$(J), MID$(MESSAGE$(CONFIGNUM), I, 1)) = 2 THEN UPBMESSAGE$ = LEFT$(UPBMESSAGE$, I - 1) + LEFT$(PBOARDCONF$(J), 1)  : NEXT I
        NEXT J
    NEXT I
RETURN




100 REM PLUGBOARD CONFIGURATION
    PRINT CHR$(10) "    Please enter in your desired combinations for a maximum of 13, seperated by a whitespace between each pair."
    PRINT          "    Please ensure that no two pairs are the same and none repeat the same character."
    PRINT          "    Ex of a full table/input: ZD BE CF GJ HK IL MP NQ OR SV TW UX YA"
    PRINT          "    Leave blank to go back." CHR$(10)
    INPUT          "      :~] ", PINP$

    REM Check if field is blank
    IF PINP$ = "" OR PINP$ = " " THEN RETURN

    REM Removing any double white spaces. It'll fuck with the array splitting
    PINPUT$ = UPS$(TH_SED$(PINP$, "\s{2,}", " ", "gi"))

    REM 3 letter check, someone will fuck up.
    FOR I = 1 TO LEN(PINPUT$)
        IF MID$(PINPUT$, I, 1) <> CHR$(32) THEN LETTERCOUNT = LETTERCOUNT + 1
        IF MID$(PINPUT$, I, 1)  = CHR$(32) THEN LETTERCOUNT = 0
        IF LETTERCOUNT >= 3 THEN PRINT TAB(4) "ERROR: 3 LETTER COUNT DETECTED, PLUGBOARD CONFIG ONLY ACCEPTS PAIRS OF CHARACTERS." : LETTERCOUNT = 0 : GOTO 100
    NEXT I

    REM Duplicate check, someone will fuck up.
    FOR J = 1 TO 26
        IF TH_RE(PINPUT$, MID$(ALPHABET$, J, 1), 1) > 1 THEN PRINT TAB(4) "ERROR: DUPLICATE DETECTED, PLEASE ENSURE THERE ARE NO DUPLICATED CHARACTERS" : GOTO 100
    NEXT J

    REM Array splitting values.
    REM Wasn't sure how to approach this, but it turned out alright.
    REM We split each pair into their own array, which will then be put in a for loop that will compare
    REM  each letter of the message to the plugboard arrays, replacing the characters accordingly.
    BUF$ = ""
    DELIM$ = " "
    MAXARRAY = 0
110 REM Array splitting, the process of encryption has started as we will replace the corresponding character in the users message in line 99
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
