# Jack of All Trades
## Features
* Automates the benefits of the Bard class feature Jack of All Trades
* Automates the benefits of the Fighter (Champion) subclass feature Remarkable Athlete
* Updates the Glibness spell with an effect that gives the appropriate "floor of 15" on Charisma skill and ability checks

* All of the above effects can be used in conjunction with custom skills (e.g. Thieves' Tools [DEX], Muscle-based Intimidation [STR], etc.).
NOTE: Changing the ability used on a main skill doesn't change which ability is associated with the skill in the code; you must make it as a custom skill in order to receive the appropriate benefits. 
For instance, using the above STR Intimidation example, changing the CHA of the regular Intimidation skill to STR will not make Remarkable Athlete apply, you'd have to make a custom skill to get that.

* If you wish, you can add your own feature that gives half proficiency into the mix; I have set up the applyHalf function in such a way that it is (hopefully) easy to add into the code.
E.g. if checkHomebrewFeature then
		applyHalf(rRoll, rSource, true/false, "Homebrew Feature Name")
* You still have to write your own checkHomebrewFeature function in that scenario--and decide where in the priority order it lies relative to JoAT and RA--but hopefully that's not any harder than it needs to be.

## Installation

[Download the Jack_Of_All_Trades.ext file](https://github.com/ThatDudeThatIsOverThere/Jack_of_All_Trades_plus_Glibness/releases) and place it in the extensions folder in the Fantasy Grounds Unity game folder.

You can open the Fantasy Grounds Unity game folder by opening Fantasy Grounds Unity and clicking here. 

![Screenshot of the thing you need to click in Fantasy Grounds Unity](https://github.com/ThatDudeThatIsOverThere/File-Holder/blob/main/Readme-Images/FGU-Folder-Open.png)

If you have Fantasy Grounds Unity open while placing the file, you will need to close and reopen Fantasy Grounds Unity after placing the file in order to use the extension.

## Attribution
SmiteWorks owns rights to code sections copied from their rulesets by permission for Fantasy Grounds community development.
'Fantasy Grounds' is a trademark of SmiteWorks USA, LLC.
'Fantasy Grounds' is Copyright 2004-2022 SmiteWorks USA LLC.
