#!/bin/bash
# Back In A Minute GPL ONLY by Sigg3.net (C) 2014
# Code is GNU GPLv3
VERSION="1.3.7 non-ASCII" 
WEBURL="http://sigg3.net/biamin/"

########################################################################
# BEGIN CONFIGURATION                                                  #
# Default dir for config, change at runtime (no trailing slash!)       #
GAMEDIR="$HOME/.biamin"                                                #
#                                                                      #
# Disable BASH history for this session                                #
unset HISTFILE                                                         #
#                                                                      #
# Hero start location e.g. Home (custom maps only):                    #
START_LOCATION="C2"                                                    #
#                                                                      #
# Disable Cheats 1 or 0 (chars with >150 health set to 100 health )    #
DISABLE_CHEATS=0                                                       #
#                                                                      #
# Editing beyond this line is considered unsportsmanlike by some..!    #
# END CONFIGURATION                                                    #
#                                                                      #
# 'Back in a minute' uses the following coding conventions:            #
#                                                                      #
#  0. Variables are written in ALL_CAPS                                #
#  1. Functions are written in CamelCase                               #
#  2. Loop variables are written likeTHIS                              #
#  3. Put the right code in the right blocks (see INDEX below)         #
#  4. Please explain functions right underneath function declarations  #
#  5. Comment out unfinished or not working new features               #
#  6. If something can be improved, mark with TODO + ideas             #
#  7. Follow the BASH FAQ practices @ www.tinyurl.com/bashfaq          #
#  8. Please properly test your changes, don't break anyone's heart    #
#  9. $(grep "$ALCOHOLIC_BEVERAGE" fridge) only AFTER coding!          #
#                                                                      #
#  INDEX                                                               #
#  0. GFX Functions Block (~ 600 lines ASCII banners)                  #
#  1. Functions Block                                                  #
#  2. Runtime Block (should begin by parsing CLI arguments)            #
#                                                                      #
#  Please observe conventions when updating the script, thank you.     #
#                                           - Sigg3                    #
#                                                                      #
########################################################################

########################################################################
#                       CHANGES for 1.3.6.2                            #
# remains of GPS_Fix() included in NewSection()                        #
#                       CHANGES for 1.3.6.1                            #
# NoWriteOnGamedir() replaced to Die() because was used only once      #
# CosmeticName() removed because was used only in Intro()              #
# LookForItem() removed because was used only in NewSection()          #
# ActionsBar() removed because was used only in NewSection()           #
# TranslatePosition() removed because used only in MapNav()            #
# TopMenu() removed because used only in MainMenu()                    #
# HowTo() removed becouse used only in Credits()                       #
# remains of GX_MapSight() included in GX_Map()                        #
# all TodaysDate() moved to Intro() because need only once             #
#                                                                      #
# Fixed some little bugs (I'cant remember how many :) )                #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        0. GFX FUNCTIONS                              #
#                All ASCII banner-functions go here!                   #

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

GX_Banner() {
    clear
    cat <<"EOT"
                       B A C K   I N   A   M I N U T E
                       
                              NON-ASCII VERSION

                         a simple bash adventure game

                       Sigg3.net (C) 2014 - GNU GPL v.3

EOT
    echo "$HR"
}

GX_Credits() {
    clear
    cat <<"EOT"
                       B A C K   I N   A   M I N U T E
                        
   Back in a minute is an adventure game with 4 playable races, 6 enemies,
   8 items and 6 scenarios spread across the 270 sections of the world map.
   Biamin saves character sheets between sessions and keeps a highscore!
   The game supports custom maps too! See --help or --usage for information.
EOT
    echo -e "\n   Game directory: $GAMEDIR/\n"
    cat <<"EOT"
   This timekiller's written entirely in BASH. It was intended for sysadmins
   but please note that it isn't console-friendly and it looks best in 80x24
   terminal emulators (white on black). Make sure it's a window you can close.
      
   You are currently playing the non-ASCII version of Back in a minute.
   BASH code (C) Sigg3.net GNU GPL Version 3 2014

EOT
    echo "   Visit the Back in a minute website at <$WEBURL>"
    echo "   for updates, feedback and to report bugs. Thank you."
    echo "$HR"
}

GX_HowTo() {
    clear
    cat <<"EOT"
                       B A C K   I N   A   M I N U T E
                                 HOW TO PLAY

   Go to Main Menu and hit (P)lay and enter the NAME of the character you want
   to create or whose character sheet you want to load (case-sensitive).
   You enter the World of Back in a Minute. The first sector is Home.
   
   Each sector gives you these action alternatives:
   (C)haracter sheet: Toggle Character Sheet
   (R)est: Sleep to gain health points
   (M)ap and travel: Toggle Map to find yourself, items and to travel
   (Q)uit: Save current status and quit the world of Back in a Minute
   Use W, A, S, D keys to travel North, West, South or East directly.
      
   Travelling and resting involves the risk of being attacked by the creatures
   inhabiting the different scenarios. Some places are safer than others.
EOT
    echo "   For more information please visit <$WEBURL>"
    echo "$HR"
}

GX_HighScore() {
    clear
    cat <<"EOT"
                       B A C K   I N   A   M I N U T E
                                 HIGHSCORE
EOT
    echo "$HR"
}

GX_LoadGame() {
    clear
    cat << "EOT"
                       B A C K   I N   A   M I N U T E
                                 LOAD GAME
EOT
    echo "$HR"
}

GX_CharSheet() {
    clear
    cat <<"EOT"
                       B A C K   I N   A   M I N U T E
                               CHARACTER SHEET
EOT
    echo "$HR"
}

GX_Death() {
    clear
    cat <<"EOT"
                                     DEATH!
                                  
                    You are a stiff, pushing up the daisies,
                            you are irrevocably dead!
                  
                             Better luck next time!

EOT
    echo "$HR"
}

GX_Intro() {
    clear
    cat <<"EOT"
                 YOU WAKE UP TO A VAST AND UNFAMILIAR LANDSCAPE!

       Use the MAP to move around, and REST to regain health points
       
       Home, towns and the castle are safer than the open road.
       Don't venture far into the wilderness and mountains.
       You are not alone..
       
EOT
    echo "$HR"
}

GX_Races() {
    clear
    cat <<"EOT"

                               CHARACTER RACES:

      1. MAN            2. ELF              3. DWARF            4. HOBBIT
 
   Healing:  3/6      Healing:  4/6       Healing:  2/6        Healing:  4/6   
   Strength: 3/6      Strength: 3/6       Strength: 5/6        Strength: 1/6
   Accuracy: 3/6      Accuracy: 4/6       Accuracy: 3/6        Accuracy: 4/6
   Flee:     3/6      Flee:     1/6       Flee:     2/6        Flee:     3/6
   
   
   Dice rolls on each turn. Accuracy also initiative. Healing during resting.

EOT
    echo "$HR"
}

GX_Castle() {
    clear
    cat <<"EOT"
                                OLDBURG CASTLE
                                
                 Welcome to the Home of the King, the Royal Court
                           and other silly persons.

EOT
    echo "$HR"
}

GX_Town() {
    clear
    cat <<"EOT"
                     YOU HAVE REACHED A PEACEFUL LITTLE TOWN

          A hot bath, warm ale and a cozy bed awaits the weary traveller

EOT
    echo "$HR"
}

GX_Forest() {
    clear
    cat <<"EOT"
                              YOU'RE IN THE WOODS
                            
                   It feels like something is watching you...

EOT
    echo "$HR"
}

GX_Mountains() {
    clear
    cat <<"EOT"
                        YOU'RE TRAVELLING IN THE MOUNTAINS
                   
               The calls of the wilderness turn your blood to ice!

EOT
    echo "$HR"
}

GX_Home() {
    clear
    cat <<"EOT"
                              MY HOME IS MY CASTLE

                      You are safe here, and fully healed.

EOT
    echo "$HR"
}

GX_Road() {
    clear
    cat <<"EOT"
                                ON THE ROAD AGAIN

             The roads are safer than the woods, but beware of robbers!

EOT
    echo "$HR"
}

GX_Rest() {
    clear
    cat <<"EOT"
                      YOU TRY TO GET SOME MUCH NEEDED REST
                  
EOT
    echo "$HR"
}

GX_Monster_chthulu() {
    clear
    cat <<"EOT"
                     THE WRATH OF MIGHTY CHTHULU IS UPON YOU
                
EOT
    echo "$HR"
}

GX_Monster_orc() {
    clear
    cat <<"EOT"
                     AN ANGRY ORC APPEARS, BLOCKING YOUR WAY!
            
                          "Prepare to die", it growls.

EOT
    echo "$HR"
}

GX_Monster_varg() {
    clear
    cat <<"EOT"
                          YOU ENCOUNTER A TERRIBLE VARG!
                    
                                 It looks hungry.

EOT
    echo "$HR"
}

GX_Monster_mage() {
    clear
    cat <<"EOT"
                        A FIERCE MAGE STANDS IN YOUR WAY!
                     
               Before you know it, he begins his evil incantations..
         
                          "Lorem ipsum dolor sit amet..."

EOT
    echo "$HR"
}

GX_Monster_goblin() {
    clear
    cat <<"EOT"
                              A GOBLIN JUMPS YOU!
        
                         He raises his club to attack..
    
EOT
    echo "$HR"
}

GX_Monster_bandit() {
    clear
    cat <<"EOT"
                   YOU ARE AMBUSHED BY A LOWLIFE CRIMINAL!
                 
           "Hand over your expensive stuffs, puny poncer, or have your
           skull cracked open by the mighty club!"

EOT
    echo "$HR"
}

GX_Item0() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                                 Gift of Sight

    You give aid to an old woman, carry her firewood and water from the
     stream, and after a few days she reveals herself as a White Witch!
	
     She gives you a blessing and the Gift of Sight in return for your help.
     "The Gift of Sight," she says, "will aide you as you aided me."

     Look for a ~ symbol in your map to discover new items in your travels.
     However, from the 7 remaining items only 1 is made visible at a time.

EOT
    echo "$HR"
}

GX_Item1() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                             Emerald of Narcolepsy

     You encounter a strange merchant from east of all maps who joins you
     for a stretch of road. He is a likeable fellow, so when he asks if he
     could share a campfire with you and finally get some much needed rest in
     these strange lands, you comply.

     The following day he presents you with a brilliant emerald that he says
     will help you sleep whenever you need to get some rest. Or at least
     fetch you a good price at the market. Then you bid each other farewell.

     +1 Healing, Chance of Healing Sleep when you are resting.
	
EOT
    echo "$HR"
}

GX_Item2() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                                Guardian Angel

     You rescue a magical fairy caught in a cobweb, and in return she
     promises to come to your aid when you are caught in a similar bind.

     +5 Health in Death if criticality is less than or equal to -5

EOT
    echo "$HR"
}

GX_Item3() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                               Fast Magic Boots

     You are taken captive by a cunning gnome with magic boots, holding you
     with a spell that can only be broken by guessing his riddles.
     After a day and a night in captivity you decide to counter his riddles
     with one of your own: "What Creature of the Forest is terribly Red and
     Whiny, and Nothing Else without the Shiny?"
     
     The gnome ponders to and fro, talking to himself and spitting, as he gets
     more and more agitated. At last, furious, he demands "Show me!" and 
     releases you from the spell. Before he knows it you've stripped off his
     boots and are running away, magically quicker than your normal pace.

     +1 Flee

EOT
    echo "$HR"
}

GX_Item4() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                             Quick Rabbit Reaction

     Having spent quite a few days and nights out in the open, you have grown
     accustomed to sleeping with one eye open and quickly react to the dangers
     of the forests, roads and mountains in the old world, that seek every
     opportunity to best you.

     Observing the ancient Way of the Rabbit, you find yourself reacting more
     quickly to any approaching danger, whether it be day or night.

     +1 Initiative upon enemy attack

EOT
    echo "$HR"
}

GX_Item5() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                             Flask of terrible odour

     Under a steep rock wall you encounter a dragon pup's undiscovered carcass.
     You notice that its rotten fumes curiously scare away all wildlife and
     lowlife in the surrounding area.
     You are intrigued and collect a sample of the liquid in a small flask that
     you carry, to sprinkle on your body for your own protection.

     +1 Chance of Enemy Flee

EOT
    echo "$HR"
}
GX_Item6() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                             Two-Handed Broadsword

     From the thickest of forests you come upon and traverse a huge unmarked 
     marsh and while crossing, you stumble upon trinkets, shards of weaponry
     and old equipment destroyed by the wet. Suddenly you realize that you are
     standing on the remains of a centuries old, long forgotten battlefield.

     On the opposite side, you climb a mound only to find the wreckage of a
     chariot, crashed on retreat, its knight pinned under one of its wheels.
     You salvage a beautiful piece of craftmanship from the wreckage;
     a powerful two-handed broadsword, untouched by time.
		
     +1 Strength
	
EOT
    echo "$HR"
}

GX_Item7() {
    clear
    cat <<"EOT"
                                  ITEM FOUND!
                               Steady Hand Brew

    Through the many years of travel you have found that your acquired taste
     of a strong northlandic brew served cool keeps you on your toes.

     +1 Accuracy and Initiative

EOT
    echo "$HR"
}

# GFX MAP FUNCTIONS

# FILL THE $MAP file using either default or custom map
MapCreate() {
    if [ -f "$GAMEDIR/CUSTOM.map" ]; then
	if grep -q 'Z' "$GAMEDIR/CUSTOM.map" ; then
	    echo "Whoops! Custom map file still contains Z's!"
	    echo "Use ONLY symbols from the legend (x . T @ H C) in your custom maps!"
	    CustomMapError
	else
	    MAP=$(cat "$GAMEDIR/CUSTOM.map")
	fi
    else
	MAP=$(cat <<EOT
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R 
   #=========================================================================#
 1 )   x   x   x   x   x   @   .   .   .   T   x   x   x   x   x   x   @   T (
 2 )   x   x   H   x   @   @   .   @   @   x   x   x   x   x   @   @   @   @ (
 3 )   @   @   .   @   @   @   .   x   x   x   x   x   @   x   @   x   @   @ (
 4 )   @   @   .   @   @   @   .   @   x   x   x   @   T   x   x   x   x   x (
 5 )   @   @   .   .   T   .   .   @   @   @   @   @   .   @   x   x   x   x (
 6 )   @   @   @   @   .   @   @   @   @   @   @   @   .   @   @   x   x   x (
 7 )   @   @   @   @   .   .   .   T   @   @   @   @   .   @   @   x   x   x (
 8 )   @   @   T   .   .   @   @   @   @   @   @   .   .   .   .   .   .   x (
 9 )   @   @   .   @   @   @   @   @   @   @   .   .   @   x   @   @   .   . (
10 )   @   @   .   @   @   @   T   @   @   @   .   @   @   x   x   x   x   . (
11 )   T   .   .   .   .   .   .   .   @   @   .   x   x   C   x   x   x   . (
12 )   x   @   @   @   .   @   @   .   .   .   .   x   x   x   x   x   x   . (
13 )   x   x   @   x   .   @   @   @   @   @   .   @   x   x   @   @   @   . (
14 )   x   x   x   x   .   @   @   @   @   T   .   @   x   x   @   @   .   . (
15 )   x   x   x   T   .   @   @   @   @   @   @   @   @   T   .   .   .   @ (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
)
    fi
}
# Map template generator (CLI arg function)
MapCreateCustom() {
    [[ ! -d "$GAMEDIR" ]] && Die "Please create $GAMEDIR/ directory before running" 
    
    cat <<"EOT" > "${GAMEDIR}/rename_to_CUSTOM.map"
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R 
   #=========================================================================#
 1 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 2 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 3 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 4 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 5 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 6 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 7 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 8 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 9 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
10 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
11 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
12 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
13 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
14 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
15 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
    echo "Custom map template created in $GAMEDIR/rename_to_CUSTOM.map"
    echo ""
    echo "1. Change all 'Z' symbols in map area with any of these:  x . T @ H C"
    echo "   See the LEGEND in rename_to_CUSTOM.map file for details."
    echo "   Home default is $START_LOCATION. Change line 16 of CONFIG or enter new HOME at runtime."
    echo "2. Spacing must be accurate, so don't touch whitespace or add new lines."
    echo "3. When you are done, simply rename your map file to CUSTOM.map"
    echo "Please submit bugs and feedback at <$WEBURL>"
}

#                          END GFX FUNCTIONS                           #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #

function Die() {
    echo -e "$1" && exit 1
}

# CLEANUP Function
CleanUp() { # Used in MainMenu(), NewSection(),
    [[ $FIGHTMODE ]] && {
	#  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
    	CHAR_HEALTH=$(( CHAR_HEALTH-20 )) ;
    	CHAR_EXP=$(( CHAR_EXP-20 )) ;
    	echo "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP" ;
    	echo -e "HEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP" ; }
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....
Please submit bugs and feedback at <$WEBURL>"
    exit 0
}
# PRE-CLEANUP tidying function for buggy custom maps
CustomMapError() {
    # Used in MapCreate(), NewSection() and MapNav()
    echo -en "What to do?
1) rename CUSTOM.map to CUSTOM_err.map or
2) delete template file CUSTOM.map (deletion is irrevocable).
Please select 1 or 2: "
    read -n 1 MAP_CLEAN_OPTS
    case "$MAP_CLEAN_OPTS" in
	1 ) mv "$GAMEDIR/CUSTOM.map" "$GAMEDIR/CUSTOM_err.map" ;
	    echo -e "\nCustom map file moved to $GAMEDIR/CUSTOM_err.map" ;
	    sleep 4 ;;
	2 ) rm -f "$GAMEDIR/CUSTOM.map" ;
	    echo -e "\nCustom map deleted!" ;
	    sleep 4 ;;
	* ) Die "\nBad option! Quitting.." ;;
    esac
}

SetupHighscore() { # Used in main() and Announce()
	HIGHSCORE="$GAMEDIR/highscore"
	if [[ -f "$HIGHSCORE" ]] ; then
		if grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" ; then	# legacy
			rm -f "$HIGHSCORE"	# Backwards compatibility: replaces old-style empty HS..
			clear
		fi
	fi
	touch -a "$HIGHSCORE"
}

### DISPLAY MAP
GX_Map() { # Used in MapNav()
    # GX_MapSight()
    if [[ $CHAR_ITEMS -gt 0 && $CHAR_ITEMS -lt 8 ]] ; then # Check for Gift of Sight
	# Show ONLY the NEXT item viz. "Item to see" (ITEM2C)
	# Since 1st item is item0, and CHAR_ITEMS begins at 0, ITEM2C=CHAR_ITEMS
	ITEM2C=${HOTZONE[$CHAR_ITEMS]}
	# If ITEM2C has been found earlier, it is now 20-20 and must be changed
	# Remember, the player won't necessarily find items in HOTZONE array's sequence
	if [[ "$ITEM2C" -eq "20-20" ]] ; then
	    ITEM_X && ITEM_Y
	    HOTZONE[$CHAR_ITEMS]="$ITEM_X-$ITEM_Y"
	    ITEM2C=${HOTZONE[$CHAR_ITEMS]}
	fi
	# Retrieve item map positions e.g. 1-15 >> X=1 Y=15
	IFS="-" read -r "ITEM2C_X" "ITEM2C_Y" <<< "$ITEM2C"
    else # Lazy fix for awk - it falls when see undefined variable #kstn
	ITEM2C_Y=0 && ITEM2C_X=0 
    fi
    # Finish GX_MapSight()

    clear

    # Awk comments:
    # 1st if - place "o" (player) on map
    #     internal if - lazy fix for ASCII borders 
    #     MAP_Y+2 and MAP_X+1 - fix for boards
    # 2nd if - if player has Gift-Of-Sight and not all items are found
    #     internal if - place ITEM2C on map 
    #     ITEM2C_Y+2 and ITEM2C_X+1 - fix for boards
    # 3rd if - if $COLOR == 1 colorise "o" (player) and "~" (ITEM2C)
    awk '
    BEGIN { FS = "   " ; OFS = "   ";}
    {
      if (NR == '$(( MAP_Y + 2 ))') {
         if ('$MAP_X' == 18 ) { $'$(( MAP_X + 1 ))'="o ("; }
         else                 { $'$(( MAP_X + 1 ))'="o";   } 
         }

      if ( '${CHAR_ITEMS}' > 0 && '${CHAR_ITEMS}' < 8) {
 	 if (NR == '$(( ITEM2C_Y + 2 ))') {
            if ( '$ITEM2C_X' == 18 ) { $'$(( ITEM2C_X + 1 ))'="~ ("; }
            else                     { $'$(( ITEM2C_X + 1 ))'="~";   } 
            }
         }
 
      if ('${COLOR}' == 1 ) {
	 if ( NR > 2 && NR < 19 ) {
 	    gsub(/~/, "'$(printf "%s" "${YELLOW}~${RESET}")'")
	    gsub(/o/, "'$(printf "%s" "${YELLOW}o${RESET}")'")
	    }
         }
      print;
    }' <<< "$MAP"

}
# SAVE CHARSHEET
SaveCurrentSheet() { # Saves current game values to CHARSHEET file (overwriting)
    echo "CHARACTER: $CHAR
RACE: $CHAR_RACE
BATTLES: $CHAR_BATTLES
EXPERIENCE: $CHAR_EXP
LOCATION: $CHAR_GPS
HEALTH: $CHAR_HEALTH
ITEMS: $CHAR_ITEMS
KILLS: $CHAR_KILLS
HOME: $CHAR_HOME" > "$CHARSHEET"
}


# CHAR SETUP
BiaminSetup() { # Used in MainMenu()
    # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"
    # Check whether CHAR exists if not create CHARSHEET
    if [[ -f "$CHARSHEET" ]] ; then
	echo -e " Welcome back, $CHAR!\n Loading character sheet ..."
	# TODO I don't know why, but "read -r VAR1 VAR2 VAR3 <<< $(awk $FILE)" not works :(
	# But one local variable at any case is better that to open one file eight times
	# 
	# "if (/^HOME:/) { HOME = $2 }" - is compatibility fix for older charactersheets
	# so it is last in line and will be undef if there isn't /^HOME:/ line in $CHARSHEET
	# TODO may be this fixes should be in main section?
	local CHAR_TMP=$(awk '
                  { 
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { RACE= $2 }
                   if (/^BATTLES:/)    { BATTLES = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^KILLS:/)      { KILLS = $2 }
                   if (/^HOME:/)       { HOME = $2 }
                 }
                 END { 
                 print CHARACTER ";" RACE ";" BATTLES ";" EXPERIENCE ";" LOCATION ";" HEALTH ";" ITEMS ";" KILLS ";" HOME ;
                 }' $CHARSHEET )
	IFS=";" read -r CHAR CHAR_RACE CHAR_BATTLES CHAR_EXP CHAR_GPS CHAR_HEALTH CHAR_ITEMS CHAR_KILLS CHAR_HOME <<< "$CHAR_TMP"
	unset CHAR_TMP
	# Compatibility fix for older charactersheets
	[[ $CHAR_HOME ]] || CHAR_HOME="$START_LOCATION"
	# If character is dead, don't fool around..
	(( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
	sleep 2
    else
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	GX_Races
	read -sn 1 -p " Select character race (1-4): " CHAR_RACE
	case $CHAR_RACE in
	    2 ) echo "You chose to be an ELF" ;;
	    3 ) echo "You chose to be a DWARF" ;;
	    4 ) echo "You chose to be a HOBBIT" ;;
	    1 | * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" ;;	# Not very good, but works :) #kstn
	esac
	
	CHAR_GPS="$START_LOCATION"
	CHAR_HOME="$START_LOCATION"

	# If there IS a CUSTOM.map file, ask where the player would like to start
	if [ -f "$GAMEDIR/CUSTOM.map" ] ; then
	    read -p " HOME location for custom maps (ENTER for default $START_LOCATION): " "CHAR_LOC"
	    if [[ ! -z "$CHAR_LOC" ]]; then
		# Use user input as start location.. but first SANITY CHECK
		read CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$CHAR_LOC")
		if (( CHAR_LOC_LEN > 3 )) || (( CHAR_LOC_LEN < 1 )) ; then
		    Die " Error! Wrong number of characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
		else
		    echo -en "Sanity check.."
		    case "$CHAR_LOC_A" in
			A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -n ".." ;;
			* ) Die "\n Error! Start location X-Axis $CHAR_LOC_A must be a CAPITAL alphanumeric A-R letter!" ;;
		    esac
		    case "$CHAR_LOC_B" in
			1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
			* ) Die "\n Error! Start location Y-Axis $CHAR_LOC_B is too big or too small!";;
		    esac
		fi
		unset CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B
		# End of SANITY check, everything okay!
		CHAR_GPS="$CHAR_LOC"
		CHAR_HOME="$CHAR_LOC"
		unset CHAR_LOC
	    fi # or CHAR_GPS and CHAR_HOME not changed from START_LOCATION
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
	sleep 2
    fi # Finish check whether CHAR exists if not create CHARSHEET 

    # Set abilities according to race (each equal to 12)
    case $CHAR_RACE in
	1 ) HEALING=3 && STRENGTH=3 && ACCURACY=3 && FLEE=3 ;; # human  (3,3,3,3)
	2 ) HEALING=4 && STRENGTH=3 && ACCURACY=4 && FLEE=1 ;; # elf    (4,3,4,1)
	3 ) HEALING=2 && STRENGTH=5 && ACCURACY=3 && FLEE=2 ;; # dwarf  (2,5,3,2)
	4 ) HEALING=4 && STRENGTH=1 && ACCURACY=4 && FLEE=3 ;; # hobbit (4,1,4,3)
    esac

    # Adjust abilities according to items
    if (( CHAR_ITEMS >= 2 )); then
	((HEALING++))			# Adjusting for Emerald of Narcolepsy
	if (( CHAR_ITEMS >= 4 )); then
	    ((FLEE++))			# Adjusting for Fast Magic Boots
	    if (( CHAR_ITEMS >= 7 )); then		
		((STRENGTH++))		# Adjusting for Broadsword
		if (( CHAR_ITEMS >= 8 )); then	
		    ((ACCURACY++))	# Adjusting for Steady Hand Brew
		fi
	    fi
	fi
    fi

    # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    [[ $DISABLE_CHEATS -eq 1 && $CHAR_HEALTH -ge 150 ]] && CHAR_HEALTH=150
    Intro
}

TodaysDate() {
    # An adjusted version of warhammeronline.wikia.com/wiki/Calendar
    # Variables used in DisplayCharsheet () ($TODAYS_DATE_STR), and
    # in FightMode() ($TODAYS_DATE_STR, $TODAYS_DATE, $TODAYS_MONTH, $TODAYS_YEAR)
    read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date '+%-y %-m %-d')"
    # Adjust date
    case "$TODAYS_DATE" in
	1 | 21 | 31 ) TODAYS_DATE+="st" ;;
	2 | 22 ) TODAYS_DATE+="nd" ;;
	3 | 23 ) TODAYS_DATE+="rd" ;;
 	* ) TODAYS_DATE+="th" ;;
    esac
    # Adjust month
    case "$TODAYS_MONTH" in
	1 ) TODAYS_MONTH="After-Witching" ;;
	2 ) TODAYS_MONTH="Year-Turn" ;;
	3 ) TODAYS_MONTH="Plough Month" ;;
	4 ) TODAYS_MONTH="Sigmar Month" ;;
	5 ) TODAYS_MONTH="Summer Month" ;;
	6 ) TODAYS_MONTH="Fore-Mystery" ;;
	7 ) TODAYS_MONTH="After-Mystery" ;;
	8 ) TODAYS_MONTH="Harvest Month" ;;
	9 ) TODAYS_MONTH="Brew Month" ;;
 	10 ) TODAYS_MONTH="Chill Month" ;;
 	11 ) TODAYS_MONTH="Ulric Month" ;;
 	12 ) TODAYS_MONTH="Fore-Witching" ;;
 	* ) TODAYS_MONTH="Biamin Festival" ;;  # rarely happens, if ever :(
    esac
    # Adjust year
    case ${TODAYS_YEAR} in
	1 | 21 | 31 | 41 | 51 | 61 | 71 | 81 | 91 ) TODAYS_YEAR+="st";;
	2 | 22 | 32 | 42 | 52 | 62 | 72 | 82 | 92 ) TODAYS_YEAR+="nd";;
	3 | 23 | 33 | 43 | 53 | 63 | 73 | 83 | 93 ) TODAYS_YEAR+="rd";;
	*) TODAYS_YEAR+="th";;
    esac
    # Output example "3rd of Year-Turn in the 13th cycle"
    TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEAR Cycle"
}


################### MENU SYSTEM #################

MainMenu() {
    while (true) ; do # Forever, because we exit through CleanUp()
	GX_Banner 		
	read -sn 1 -p "        (P)lay    (L)oad game    (H)ighscore    (C)redits    (Q)uit   " TOPMENU_OPT
	case "$TOPMENU_OPT" in
	    p | P ) 
		GX_Banner ;
		read -p " Enter character name (case sensitive): " CHAR ;
		[[ $CHAR ]] && BiaminSetup;; # Do nothing if CHAR is empty
	    l | L ) 
		LoadGame && BiaminSetup;; # Do nothing if CHAR is empty
	    h | H ) HighScore ;;
	    c | C ) Credits ;;
	    q | Q ) CleanUp ;;
	    * ) ;; # TODO rewrite without clear 
	esac
    done
}
# Highscore
HighscoreRead() {
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n;"
    local i=1
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( i > 10 )) && break
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
	((i++))
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
    unset HIGHSCORE_TMP
}

HighScore() { # Used in MainMenu()
    GX_HighScore
    echo ""
    if [ ! -s "$HIGHSCORE" ] ; then # Die if $HIGHSCORE is empty
	echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!"
    else
	HighscoreRead		# Show 10 highscore entries
    fi
    echo -e "\n                   Press the any key to go to (M)ain menu    "
    read -sn 1 
}   # Return to MainMenu()

Credits() { # Used in MainMenu()
    GX_Credits
    read -sn 1 -p "                 (H)owTo    (L)icense      (M)ain menu       " "CREDITS_OPT"
    case "$CREDITS_OPT" in
	L | l ) License ;;
	H | h ) 
	    GX_HowTo
	    read -sn 1 -p "                       Press any key to return to (M)ain Menu               " ;;
	M | * ) ;;
    esac
    unset CREDITS_OPT
}   # Return to MainMenu()

PrepareLicense() { # gets license
    # TODO add option to use wget if systen hasn't curl (Debian for instance)
    echo "Download GNU GPL Version 3 ..."
    GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "")
    echo "Download CC BY-NC-SA 4.0 ..."
    if [[ $GPL ]] ; then 
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL"  > "$GAMEDIR/LICENSE" "$GAMEDIR/LICENSE"
	echo "License downloaded!"
	sleep 1
	return 0
    else
	echo "Can't download license :( Do you have Internet access?"
	sleep 1
	return 1
    fi
}
License() { # Used in Credits()
    # Displays license if present or runs PrepareLicense && then display it..
    clear
    if [ -f "$GAMEDIR/LICENSE" ]; then
	"$PAGER" "$GAMEDIR/LICENSE" # Some like "more" than "less" (as pager) :)
    else
	echo "License file currently missing in $GAMEDIR/ !"
	echo -n "To DL licenses, about 60kB, type YES (requires internet access): " 
	read "DL_LICENSE_OPT"
	case "$DL_LICENSE_OPT" in
	    YES ) 
		PrepareLicense && "$PAGER" "$GAMEDIR/LICENSE" ;;
	    * ) 
		echo -e "
Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>
More info:\t<${WEBURL}about#license>
Press any key to go back to main menu!";
		read -sn 1;;
	esac
    fi
}   # Return to Credits() 


LoadGame() { # Used in MainMenu()
    GX_LoadGame
    if [[ ! $(find "$GAMEDIR"/ -name '*.sheet') ]]; then
	# TODO replace to read -p after debug
	echo " Sorry! No character sheets in $GAMEDIR/"
	echo " Press any key to return to (M)ain menu and try (P)lay"
	read -sn 1 # St. Anykey - patron of cyberneticists :)
	return 1   # BiaminSetup() will not be run after LoadGame()
    else
	local i=1
	for loadSHEET in $(find "$GAMEDIR"/ -name '*.sheet') ; do 
	    # Character can consist from two and more words
	    # not only "Corum" but "Corum Jhaelen Irsei" for instance 
	    awk '{ if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { if ($2 == 1 ) { RACE="Human"; }
               		                 if ($2 == 2 ) { RACE="Elf"; }
             		                 if ($2 == 3 ) { RACE="Dwarf"; }
            		                 if ($2 == 4 ) { RACE="Hobbit";} 
                                        }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                 }
                 END { 
                 print " "'$i' ". \"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")" 
                 }' $loadSHEET 
	    SHEETS[((i++))]="$loadSHEET" # initialize SHEETS[$i] than $i++
	done
    fi
    # TODO replace to read -p after debug
    echo -en "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
    read NUM
    if [[ ! ${SHEETS[$NUM]} ]] ; then
	unset NUM SHEETS i
	return 1 # BiaminSetup() will not be run after LoadGame()
    else
	CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' ${SHEETS[$NUM]} );
	unset NUM SHEETS i
	return 0 # BiaminSetup() will be run after LoadGame()
    fi
}   # return to MainMenu()
# GAME ITEMS

# GAME ITEMS
# Randomizers for Item Positions used in e.g. HotzonesDistribute
ITEM_X() { # Used in HotzonesDistribute() and GX_Map()
    ITEM_X=$((RANDOM%18+1))
}
ITEM_Y() { # Used in HotzonesDistribute() and GX_Map()
    ITEM_Y=$((RANDOM%15+1))
}

HotzonesDistribute() { # Used in Intro(),
    # Scatters special items across the map
    if (( CHAR_ITEMS < 8 )); then
	ITEMS_2_SCATTER=$(( 8 - CHAR_ITEMS ))
	# default x-y HOTZONEs to extraterrestrial section 20-20
	HOTZONE=( 20-20 20-20 20-20 20-20 20-20 20-20 20-20 20-20 )
	i=7
	while [ $ITEMS_2_SCATTER -gt 0 ]; do
	    ITEM_X && ITEM_Y
	    HOTZONE[$i]="$ITEM_X-$ITEM_Y"
	    ((i--))
	    ((ITEMS_2_SCATTER--))
	done
    fi
}
################### GAME SYSTEM #################
RollDice() {     # Used in RollForEvent(), RollForHealing(), etc
    DICE_SIZE=$1 # DICE_SIZE used in RollForEvent()
    DICE=$((RANDOM%$DICE_SIZE+1))
}

## GAME FUNCTIONS: ITEMS IN LOOP
ItemWasFound() { # Used in NewSection()
    case "$CHAR_ITEMS" in
	0 ) GX_Item0 ;;				# Gift of Sight (set in MapNav)
	1 ) (( HEALING++ )) && GX_Item1 ;;	# Emerald of Narcolepsy (set now & setup)
	2 ) GX_Item2 ;;				# Guardian Angel (set in battle loop)
	3 ) (( FLEE++ )) && GX_Item3 ;;         # Fast Magic Boots (set now & setup)
	4 ) GX_Item4 ;;				# Quick Rabbit Reaction (set in battle loop)
	5 ) GX_Item5 ;;				# Flask of Terrible Odour (set in battle loop)
	6 ) (( STRENGTH++ )) && GX_Item6 ;;	# Two-Handed Broadsword	(set now & setup)
	7 | *) (( ACCURACY++ )) && GX_Item7 ;;	# Steady Hand Brew (set now & setup)
    esac

    COUNTDOWN=180
    while (( COUNTDOWN > 0 )); do
	GX_Item$CHAR_ITEMS
	echo "                      Press any letter to continue  ($COUNTDOWN)"
	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done

    unset SKIP

    # Remove the item that is found from the world
    i=0
    while (( i < 7 )); do
        [ "$MAP_X-$MAP_Y" = "${HOTZONE[$i]}" ] && HOTZONE[$i]="20-20"
	((i++))
    done

    (( CHAR_ITEMS++ )) 

    # BUGFIX: re-distribute items to increase randomness. Fix to avoid items
    # previously shown still there (but hidden) after a diff item was found..
    HotzonesDistribute
    
    SaveCurrentSheet # Save CHARSHEET items
    NODICE=1         # No fighting if item is found..
}   # Return to NewSection()

## GAME ACTION: MAP + MOVE
MapNav() { # Used in NewSection()
    if [ -z "$1" ] ; then	# If empty = toggle map (m) was pressed, else just move!
	GX_Map
	# If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	echo -en " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS"

	case "$SCENARIO" in
	    H ) echo " (Home)" ;;
	    x ) echo " (Mountain)" ;;
	    . ) echo " (Road)" ;;
	    T ) echo " (Town)" ;;
	    @ ) echo " (Forest)" ;;
	    C ) echo " (Oldburg Castle)" ;;
	esac

	echo "$HR"
	read -sn 1 -p " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " DEST

    else  # The player did NOT toggle map, just moved without looking from NewSection()..
	DEST="$1"
	GX_Place "$SCENARIO"    # Shows the _current_ scenario scene, not the destination's.
    fi

    case "$DEST" in
	w | W | n | N ) echo -en "You go North"; # Going North (Reversed: Y-1)
	    (( MAP_Y != 1  )) && (( MAP_Y-- )) || ( echo "You wanted to visit Santa, but walked in a circle.." && sleep 3 ) ;;
	d | D | e | E ) echo -en "You go East" # Going East (X+1)
	    (( MAP_X != 18 )) && (( MAP_X++ )) || ( echo "You tried to go East of the map, but walked in a circle.." && sleep 3 ) ;;
	s | S ) echo -en "You go South" # Going South (Reversed: Y+1)
	    (( MAP_Y != 15 )) && (( MAP_Y++ )) || ( echo "You tried to go someplace warm, but walked in a circle.." && sleep 3 ) ;;
	a | A ) echo -en "You go West" # Going West (X-1)
	    (( MAP_X != 1  )) && (( MAP_X-- )) || ( echo "You tried to go West of the map, but walked in a circle.." && sleep 3 ) ;;
	q | Q ) CleanUp ;; # Save and exit
	* ) echo -en "Loitering..." && sleep 2
    esac

    # TranslatePosition() - Translate MAP_X numeric back to A-R
    MAP_X=$(awk '{print substr("ABCDEFGHIJKLMNOPQR", '$MAP_X', 1)}' <<< "$MAP_X")   
    CHAR_GPS="$MAP_X$MAP_Y" 	# Set new [A-R][1-15] to CHAR_GPS
    sleep 1
}   # Return NewSection()

# GAME ACTION: DISPLAY CHARACTER SHEET
DisplayCharsheet() { # Used in NewSection() and FightMode()
    if (( CHAR_KILLS > 0 )); then
	MURDERSCORE=$(echo "scale=zero;100*$CHAR_KILLS/$CHAR_BATTLES" | bc -l) # kill/fight percentage
    else
	MURDERSCORE=0
    fi
    case $CHAR_RACE in
	1 ) local RACE="(Human)" ;;
	2 ) local RACE="(Elf)" ;;
	3 ) local RACE="(Dwarf)" ;;
	4 ) local RACE="(Hobbit)" ;;
    esac
    case "$SCENARIO" in
	H ) local PLACE="(Home)" ;; 
	x ) local PLACE="(Mountain)" ;;
	. ) local PLACE="(Road)" ;;
	T ) local PLACE="(Town)" ;;
	@ ) local PLACE="(Forest)" ;;
	C ) local PLACE="(Oldburg Castle)" ;;
    esac
    GX_CharSheet
    cat <<EOF
 Character:                 $CHAR $RACE
 Health Points:             $CHAR_HEALTH
 Experience Points:         $CHAR_EXP
 Current Location:          $CHAR_GPS $PLACE
 Current Date:              $TODAYS_DATE_STR
 Number of Battles:         $CHAR_BATTLES
 Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)
 Items found:               $CHAR_ITEMS of 8
 Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE
EOF
    echo -en "\n      (D)isplay Race Info        (A)ny key to continue          (Q)uit     "
    read -sn 1 CHARSHEET_OPT
    if [[ "$CHARSHEET_OPT" == "d" || "$CHARSHEET_OPT" == "D"  ]] ; then
    	GX_Races
    	echo -en "\n                          Press any letter to return        "
    	read -sn1
    elif
		[[ "$CHARSHEET_OPT" == "q" || "$CHARSHEET_OPT" == "Q" ]] ; then
		CleanUp
    fi
}

# FIGHT MODE! (secondary loop for fights)
FightTable() {  # Used in FightMode()
    GX_Monster_"$ENEMY"		# ${VAR^} - capitalise $VAR
    # TODO ${VAR^} should be changed to work on bash less than 4 (MacOS for instance)
	ENEMYNAME=$(echo $ENEMY | sed  's/^\(.\)/\U\1/' ) # nice capital NAME for enemies..
	
    echo -e "$SHORTNAME\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
    echo -e "$ENEMYNAME\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
}   # Return to FightMode()

FightMode() {	# FIGHT MODE! (secondary loop for fights)
                # Used in NewSection() and Rest()
    LUCK=0      # Used to assess the match in terms of EXP..
    FIGHTMODE=1	# Anti-cheat bugfix for CleanUp: Adds penalty for CTRL+C during fights!

    RollDice 20 # Determine enemy type
    case "$SCENARIO" in
	H ) ENEMY="chthulu" ;; 
	x ) (( DICE <= 10 )) && ENEMY="orc"     || (( DICE >= 16 )) && ENEMY="goblin" || ENEMY="varg" ;;
	. ) (( DICE <= 12 )) && ENEMY="goblin"  || ENEMY="bandit" ;;
	T ) (( DICE <= 15 )) && ENEMY="bandit"  || ENEMY="mage"   ;;
	@ ) (( DICE <=  8 )) && ENEMY="goblin"  || (( DICE >= 17 )) && ENEMY="orc"    || ENEMY="bandit" ;;
	C ) (( DICE <=  5 )) && ENEMY="chthulu" || ENEMY="mage" ;;
    esac

    # ENEMY ATTRIBUTES; If you want to tune/balance the fights do it here!
    # 
    # I know it looks ugly, but I think we should have all monster's in one place
    # We could use associative arrays but it will not work with bash less than 4.0 (or 4.2 ?) - MacOS for instance
    #
    # EN_FLEE_THRESHOLD - At what Health will enemy flee? :)
    # PL_FLEE_EXP       - Exp player get if he manage to flee from enemy
    # EN_FLEE_EXP       - Exp player get if enemy manage to flee from him
    # EN_DEFEATED_EXP   - Exp player get if he manage to kill the enemy

    case "$ENEMY" in
	bandit )  EN_STRENGTH=2 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=10  ; EN_DEFEATED_EXP=20   ;;
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; PL_FLEE_EXP=10  ; EN_FLEE_EXP=15  ; EN_DEFEATED_EXP=30   ;; 
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; PL_FLEE_EXP=15  ; EN_FLEE_EXP=25  ; EN_DEFEATED_EXP=50   ;; 
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; PL_FLEE_EXP=25  ; EN_FLEE_EXP=50  ; EN_DEFEATED_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; PL_FLEE_EXP=35  ; EN_FLEE_EXP=75  ; EN_DEFEATED_EXP=150  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=200 ; EN_FLEE_EXP=500 ; EN_DEFEATED_EXP=1000 ;;
    esac

    GX_Monster_$ENEMY
    sleep 1 #?!!

    # Adjustments for items
    (( CHAR_ITEMS >= 5 )) && (( ACCURACY++ )) # item4: Quick Rabbit Reaction
    (( CHAR_ITEMS >= 6 )) && (( EN_FLEE++ ))  # item5: Flask of Terrible Odour

    # DETERMINE INITIATIVE (will usually be enemy)
    if (( EN_ACCURACY > ACCURACY )); then
	echo "The $ENEMY has initiative"
	NEXT_TURN="en"
    else
	echo "$CHAR has the initiative!"
	echo -en "\n\t\t   Press any key to fight or (F) to Flee"
	read -sn 1 FLEE_OPT
	case "$FLEE_OPT" in
	    f | F ) echo -e "\nTrying to slip away unseen.. (Flee: $FLEE)"
		RollDice 6
		(( DICE <= FLEE )) && { 
		    echo "You rolled $DICE and managed to run away!";
		    LUCK=3;
		    unset FIGHTMODE; } || {
		    echo "You rolled $DICE and lost your initiative.." ;
		    NEXT_TURN="en" ; } ;;
	    * ) NEXT_TURN="pl" ;;
	esac
    fi

    sleep 1

    (( CHAR_ITEMS >= 5 )) && (( ACCURACY--)) # Resets Quick Rabbit Reaction setting..

    # GAME LOOP: FIGHT LOOP
    while (( FIGHTMODE > 0 )) # If player didn't manage to run
    do
	if (( CHAR_HEALTH <= 0 )); then
	    echo -e "\nYour health points are $CHAR_HEALTH"
	    sleep 2
	    echo "You WERE KILLED by the $ENEMY, and now you are dead..."
	    sleep 2
	    if (( CHAR_EXP >= 1000 )) && (( CHAR_HEALTH < -5 )) && (( CHAR_HEALTH > -15 )); then
		echo "However, your $CHAR_EXP Experience Points relates that you have"
		echo "learned many wondrous and magical things in your travels..!"
		echo "+20 HEALTH: Health Restored to 20"
		CHAR_HEALTH=20
		LUCK=2
		unset FIGHTMODE
		sleep 8
		break	# bugfix: Resurrected player could continue fighting
	    elif (( CHAR_ITEMS >= 3 )) && (( CHAR_HEALTH > -6 )); then
		echo "Suddenly you awake again, SAVED by your Guardian Angel!"
		echo "+5 HEALTH: Health Restored to 5"
		CHAR_HEALTH=5
		LUCK=2
		unset FIGHTMODE
		sleep 8
		break # bugfix: Resurrected player could continue fighting..
	    else      # DEATH!
		echo "Gain 1000 Experience Points to achieve magic healing!"
		sleep 4
		case "$CHAR_RACE" in
		    1 ) FUNERAL_RACE="human" ;;
		    2 ) FUNERAL_RACE="elf" ;;
		    3 ) FUNERAL_RACE="dwarf" ;;
		    4 ) FUNERAL_RACE="hobbit" ;;
		esac
		local COUNTDOWN=20
		while (( COUNTDOWN > 0 )); do
		    GX_Death
		    echo " The $TODAYS_DATE_STR:"
		    echo " In such a short life, this sorry $FUNERAL_RACE gained $CHAR_EXP Experience Points."
		    echo " We honor $CHAR with $COUNTDOWN secs silence." 
    		    read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
		done
		unset FUNERAL_RACE COUNTDOWN
		echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
		rm -f "$CHARSHEET" # A sense of loss is important for gameplay:)
		# Zombie fix
		unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS
		unset FIGHTMODE && DEATH=1 && break 	# Zombie fix		    
	    fi
	fi

	FightTable

	if [ "$NEXT_TURN" = "pl" ] ; then  # Player's turn
	    echo -en "\nIt's your turn, press any key to (R)oll or (F) to Flee" 
	    read -sn 1 "FIGHT_PROMPT"
	    RollDice 6
	    FightTable
	    echo -en "\nROLL D6: $DICE"
	    if [ "$FIGHT_PROMPT" = "f" ] || [ "$FIGHT_PROMPT" = "F" ] ; then
		unset FIGHT_PROMPT
		# Player tries to flee!
		if (( DICE <= FLEE )); then
		    echo -e "\tFlee [D6 $DICE < $FLEE] You managed to flee!"
		    unset FIGHTMODE
		    LUCK=3
		    sleep 3
		    break
		else
		    echo -e "\tFlee [D6 $DICE > $FLEE] Your escape was ill-fated!"
		    NEXT_TURN="en"
		    sleep 2
		fi
	    else # Player fights
		unset FIGHT_PROMPT
		if (( DICE <= ACCURACY )); then
		    echo -e "\tAccuracy [D6 $DICE < $ACCURACY] Your weapon hits the target!"
		    echo -n "Press the R key to (R)oll for damage" 
		    read -sn 1 "FIGHT_PROMPT"
		    RollDice 6
		    echo -en "\nROLL D6: $DICE"
		    DAMAGE=$(( DICE*STRENGTH ))
		    echo -en "\tYour blow dishes out $DAMAGE damage points!"
		    EN_HEALTH=$(( EN_HEALTH-DAMAGE ))
		    unset FIGHT_PROMPT
		    (( EN_HEALTH <= 0 )) && sleep 1 && break # extra pause here..
		    NEXT_TURN="en" 
		    sleep 3
		else
		    echo -e "\tAccuracy [D6 $DICE > $ACCURACY] You missed!"
		    NEXT_TURN="en"
		    sleep 2
		fi
	    fi
	else # Enemy's turn
	    # Enemy tries to flee
	    if (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then
		FightTable
		RollDice 20
		echo -e "\nRolling for enemy flee: D20 < $EN_FLEE"
		sleep 2
		if (( DICE < EN_FLEE )); then
		    echo -n "ROLL D20: $DICE"
		    echo -e "\tThe $ENEMY uses an opportunity to flee!"
		    LUCK=1
		    unset FIGHTMODE
		    sleep 2
		    break # bugfix: Fled enemy continue fighting..
		else
			FightTable
		fi
	    fi

	    echo -en "\nIt's the $ENEMY's turn"
	    sleep 2
	    RollDice 6
	    if (( DICE <= EN_ACCURACY )); then
		echo -en "\nAccuracy [D6 $DICE < $EN_ACCURACY] The $ENEMY strikes you!"
		RollDice 6
		DAMAGE=$(( DICE*EN_STRENGTH ))
		echo -en "\n-$DAMAGE HEALTH: The $ENEMY's blow hits you with $DAMAGE points!"
		CHAR_HEALTH=$(( CHAR_HEALTH-DAMAGE ))
		SaveCurrentSheet
		NEXT_TURN="pl"
	    else
		echo -e "\nAccuracy [D6 $DICE > $EN_ACCURACY] The $ENEMY misses!"
		NEXT_TURN="pl"
	    fi
	    sleep 2
	fi
    done
    # FIGHT LOOP ends

    # After the figthing 
    if [[ $DEATH -ne 1 ]] ; then   # VICTORY!
	if (( LUCK == 2 )); then   # died but saved by guardian angel or 1000 EXP
	    echo "When you come to, the $ENEMY has left the area ..."
	elif (( LUCK == 1 )); then # ENEMY managed to FLEE
	    echo -en "You defeated the $ENEMY and gained $EN_FLEE_EXP Experience Points!" 
	    CHAR_EXP=$(( CHAR_EXP + EN_FLEE_EXP ))
	elif (( LUCK == 3 )); then # PLAYER managed to FLEE during fight!
	    echo -en "You got away while the $ENEMY wasn't looking, gaining $PL_FLEE_EXP Experience Points!"
	    CHAR_EXP=$(( CHAR_EXP + PL_FLEE_EXP ))
	else			   # ENEMY was slain!
	    FightTable
	    echo -en "\nYou defeated the $ENEMY and gained $EN_DEFEATED_EXP Experience Points!" 
	    CHAR_EXP=$(( CHAR_EXP + EN_DEFEATED_EXP ))
	    (( CHAR_KILLS++ ))
	fi
	(( CHAR_BATTLES++ ))
	SaveCurrentSheet
	unset LUCK
	sleep 4
	DisplayCharsheet
    fi    
}   # Return to NewSection() or to Rest()
# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    echo -e "Rolling for healing: D6 <= $HEALING\nROLL D6: $DICE"
    if (( DICE <= HEALING )); then
	CHAR_HEALTH=$(( CHAR_HEALTH + $1 ))
	echo "You slept well and gained $1 Health."
    else
	echo "$2"
    fi
    sleep 2
}   # Return to Rest()

# GAME ACTION: REST
# Game balancing can also be done here, if you think players receive too much/little health by resting.
Rest() {  # Used in NewSection()
    RollDice 100
    GX_Rest
    case "$SCENARIO" in
	H ) if (( CHAR_HEALTH < 100 )); then
	    CHAR_HEALTH=100
	    echo "You slept well in your own bed. Health restored to 100."
	    else
	    echo "You slept well in your own bed, and woke up to a beautiful day."
	    fi
	    sleep 2
	    ;;
	x ) RollForEvent 60 && FightMode || RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;;
	. ) RollForEvent 30 && FightMode || RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	T ) RollForEvent 15 && FightMode || RollForHealing 15 "The vices of town life kept you up all night.." ;;
	@ ) RollForEvent 35 && FightMode || RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	C ) RollForEvent 5  && FightMode || RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
    esac
    sleep 2
}   # Return to NewSection()

# THE GAME LOOP

RollForEvent() { # Used in NewSection() and Rest()
    echo -e "Rolling for event: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE" 
    sleep 2
    (( DICE <= $1 )) && return 0 || return 1
}   # Return to NewSection() or Rest()

GX_Place() {     # Used in NewSection() and MapNav()
    # Display scenario GFX
    case "$1" in
	H ) GX_Home ;;
	x ) GX_Mountains ;;
	. ) GX_Road ;;
	T ) GX_Town ;;
	@ ) GX_Forest ;;
	C ) GX_Castle ;;
	Z | * )  clear
	    echo "Whoops! There is an error with your map file!"
	    echo "Either it contains unknown characters or it uses incorrect whitespace."
	    echo "Recognized characters are: x . T @ H C"
	    echo "Please run game with --map argument to create a new template as a guide."
	    echo ""
	    CustomMapError;;
    esac
}   # Return to NewSection() or MapNav()


# THE GAME LOOP
NewSection() { # Used in Intro()
    while (true) # While (player-is-alive) :) 
    do
	# Do not attack player at the first turn
	# TODO DICE_SIZE=100 - it's very dirty fix for first use RollForEvent()
	[[ $NODICE ]] && { DICE=99 && DICE_SIZE=100 && unset NODICE ;} || RollDice 100
	# GPS_Fix()  Find out where we are
	# Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
	read -r MAP_X MAP_Y  <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
	MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18} #kstn
	# MAP_X+2 MAP_X+2 - padding for borders
	SCENARIO=$(awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" )
	# Finish GPS_Fix() 
	# Look for treasure @ current GPS location
	(( CHAR_ITEMS < 8 )) && { # Checks current section for treasure
	    for zoneS in "${HOTZONE[@]}" ; do
	    	[[ "$zoneS" == "$MAP_X-$MAP_Y" ]] && ItemWasFound
	    done
	}

	GX_Place "$SCENARIO"
	# Find out if we're attacked - FightMode() if RollForEvent return 0
	case "$SCENARIO" in
	    H ) RollForEvent 1  && FightMode ;; 
	    x ) RollForEvent 50 && FightMode ;;
	    . ) RollForEvent 20 && FightMode ;;
	    T ) RollForEvent 15 && FightMode ;;
	    @ ) RollForEvent 35 && FightMode ;;
	    C ) RollForEvent 10 && FightMode ;;
	    Z | * )  clear
		echo "Whoops! There is an error with your map file!"
		echo "Either it contains unknown characters or it uses incorrect whitespace."
		echo "Recognized characters are: x . T @ H C"
		echo -e "Please run game with --map argument to create a new template as a guide.\n"
		CustomMapError
		;;
	esac
	# If player was slain in fight mode
        (( DEATH == 1 )) && unset DEATH && HighScore && break

	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    echo -en "          (C)haracter     (R)est     (M)ap and Travel     (Q)uit   "
	    read -sn 1 ACTION
	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) 
		    Rest; # Player may be attacked during the rest :)
		    # If player was slain during the rest
		    [[ $DEATH -eq 1 ]] && unset DEATH && HighScore && break 2 ;;
		q | Q ) CleanUp ;;              # Leaving the realm of magic behind ....
		m | M ) MapNav; break ;;        # Go to Map then move
		* ) MapNav "$ACTION"; break ;;	# Move directly (if not WASD, then loitering :)
	    esac
	done
    done
}   # Return to MainMenu() (if player is dead)

Intro() { # Used in BiaminSetup()
    # Intro function basically gets the game going
    # Create FIGHT CHAR name
    SHORTNAME=$(awk '{ if (length($0) == 12) { print $0; } 
                       else { if (length($0) > 12) { print substr($0,0,11); }
                              else {STR = $0; LEN = 12 - length(STR); for (i=0; i < LEN; i++) { STR = STR "_" } print STR } }
                     }' <<< "$CHAR")
	SHORTNAME=$( echo $SHORTNAME | sed  's/^\(.\)/\U\1/' ) # ALL CAPS
    TodaysDate	       # Fetch today's date in Warhammer calendar (Used in DisplayCharsheet() and FightMode() )
    MapCreate          # Create session map in $MAP  
    HotzonesDistribute # Place items randomly in map

    local COUNTDOWN=60
    GX_Intro
    echo "                        Press any letter to continue" 
    while [ $COUNTDOWN -ge 0 ]; do
    	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done
    unset COUNTDOWN
    
    NODICE=1 # Do not roll on first section after loading/starting a game in NewSection()
    NewSection
}

Announce() {
    # Simply outputs a 160 char text you can cut & paste to social media.
    # I was gonna use pump.io for this, but too much hassle && dependencies..

    SetupHighscore

    # Die if $HIGHSCORE is empty
    [ ! -s "$HIGHSCORE" ] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    [[ $SCORE_TO_PRINT -lt 1 && $SCORE_TO_PRINT -gt 10 ]] && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    RollDice 6
    case $DICE in
	1 ) ADJECTIVE="honorable" ;;
	2 ) ADJECTIVE="fearless" ;;
	3 ) ADJECTIVE="courageos" ;;
	4 ) ADJECTIVE="brave" ;;
	5 ) ADJECTIVE="legendary" ;;
	6 ) ADJECTIVE="heroic" ;;
    esac

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    case $highRACE in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
    esac

    [[ $highBATTLES -eq 1 ]] && highBATTLES+=" battle" || highBATTLES+=" battles"
    [[ $highITEMS -eq 1 ]]   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=${highCHAR^}

    ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    
    ANNOUNCEMENT_LENGHT=$(awk '{print length($0)}' <<< "$ANNOUNCEMENT" ) 
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo -e "$HR\n"

    [[ $ANNOUNCEMENT_LENGHT -gt 160 ]] && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
    exit 0
}

ColorConfig() {
    echo -en "
We need to configure terminal colors for the map!
Please note that a colored symbol is easier to see on the world map.
Back in a minute was designed for white text on black background.
Does \033[1;33mthis text appear yellow\033[0m without any funny characters?
Do you want color? No to DISABLE, Yes or ENTER to ENABLE color: " 
    read COLOR_CONFIG
    case "$COLOR_CONFIG" in
	N | n | NO | No | no | DISABLE | disable ) 
	    COLOR=0 ;
	    echo -e "Disabling color! Edit $GAMEDIR/config to change this setting.";
	    sed -i 's/COLOR: NA/COLOR: 0/g' "$GAMEDIR/config" ;;
	* ) COLOR=1 ;
	    echo "Enabling color!" ;
	    sed -i 's/COLOR: NA/COLOR: 1/g' "$GAMEDIR/config" ;;
    esac
    sleep 2
}

CreateBiaminLauncher() {
    if grep -q 'biamin.sh' "$HOME/.bashrc" ; then
	echo "Found existing launcher in $HOME/.bashrc.. skipping!"
    else
	BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )	# TODO $0 is a powerful beast, but will sometimes fail..
	echo "This will add $BIAMIN_RUNTIME/biamin.sh to your .bashrc"
	read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER
	case "$LAUNCHER" in
	    y | Y ) LAUNCHER=1 ;;
	    * ) LAUNCHER=0 ;;
	esac
	if (( LAUNCHER == 1 )) ; then
	    {   # https://github.com/koalaman/shellcheck/wiki/SC2129
		echo ""
		echo "# Back in a Minute Game Launcher (just run 'biamin')"
		echo "biamin() {"
		echo "$BIAMIN_RUNTIME/biamin.sh \"\$@\""
		echo "}"
	    } >> "$HOME/.bashrc"
	    echo "Done. Close and re-open BASH to test \"biamin\" command!"
	else
	    echo "Don't worry, not changing anything!"
	fi
    fi
}		        


#                           END FUNCTIONS                              #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Parse CLI arguments if any # TODO use getopts ?
case "$1" in
    --announce )
	Announce ;;
    --h | --help )
	echo "Run the game BACK IN A MINUTE with '--play' or 'p' arguments to play!"
	echo "For usage: run biamin --usage"
	echo "Current dir for game files: $GAMEDIR/"
	echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	echo "You are currently running the NON-ASCII (GPL-only) version."
	exit 0;;
    --i | --install )
	CreateBiaminLauncher ;
	exit 0;;
    --map )
	read -n1 -p "Create custom map template? [Y/N] " CUSTOM_MAP_PROMPT
	if [ "$CUSTOM_MAP_PROMPT" = "y" ] || [ "$CUSTOM_MAP_PROMPT" = "Y" ]; then
	    echo "Creating custom map template.."
	    MapCreateCustom
	else
	    echo "Not doing anything! Quitting.."
	fi
	exit 0 ;;
    --play | -p | p )
	echo "Launching Back in a Minute.." ;;
    --v | --version )
	echo -e "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net\n"
	echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
	echo "This is free software: you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
	echo -e "For details see: <http://www.gnu.org/licenses/gpl-3.0>\n"
	echo "You are currently running the NON-ASCII (GPL-ONLY) version."
	echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
	exit 0 ;;
    --usage | * )
	echo "Usage: biamin or ./biamin.sh"
	echo "  (NO ARGUMENTS)      display this usage text and exit"
	echo "  --play or p         PLAY the game \"Back in a minute\""
	echo "  --announce          DISPLAY an adventure summary for social media and exit"
	echo "  --install           ADD biamin.sh to your .bashrc file"
	echo "  --map               CREATE custom map template with instructions and exit"
	echo "  --help              display help text and exit"
	echo "  --usage             display this usage text and exit"
	echo "  --version           display version and licensing info and exit"
	exit 0;;
esac

# Check whether gamedir exists..
[[ ! -d "$GAMEDIR" ]] && {
    echo "Game directory default is $GAMEDIR/" ;
    echo "You can change this in $GAMEDIR/config. Creating directory .." ;
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR .."
}

# Check whether $GAMEDIR/config exists..
[[ ! -f "$GAMEDIR/config" ]] && {
    echo "Creating $GAMEDIR/config .." ;
    echo "GAMEDIR: $GAMEDIR" > "$GAMEDIR/config" ;
    echo "COLOR: NA" >> "$GAMEDIR/config" ;
}

echo "Putting on the traveller's boots.."

# Load variables from $GAMEDIR/config. NB variables should not be empty !
read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR " " COLOR ;}' "$GAMEDIR/config" )
# Color configuration
case "$COLOR" in
    1 ) echo "Enabling color for maps!" ;;
    0 )	echo "Enabling old black-and-white version!" ;;
    * ) ColorConfig ;;
esac

# Define colors if enabled
if (( COLOR == 1 )); then
    YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
    RESET='\033[0m'
fi

# Direct termination signals to CleanUp
trap CleanUp SIGHUP SIGINT SIGTERM

SetupHighscore # Setup highscore file
MainMenu       # Run main menu
exit 0         # This should never happen:
               # .. but why be 'tardy when you can be tidy?