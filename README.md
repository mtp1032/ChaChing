# ChaChing

CURRENT VERSION: 1.0.1 (Release Candidate)

DESCRIPTION:

ChaChing is another AddOn that permits a player to sell items in bulk. However, ChaChing differs from most similar AddOns in two important ways:

First, and in addition to bulk sales of poor (grey) items, players can configure ChaChing to sell all common (white) weapon and armor items. This is particularly useful at lower levels when many (most) drops and quest rewards are of common quality.

Second, ChaChing allows a player to configure one or more bags from which all items in the selected bag(s) will be sold -- regardless of their quality (poor, common, uncommon, rare, or epic). This capability is particularly useful for non-Enchanters as well as higher level characters when drops and quest rewards are soulbound and cannot be equipped or otherwise used by the player's character.

USAGE:

When a player opens a merchant window, ChaChing will have placed a button at the top left of the window, [ChaChing]. When/if the button is clicked, ChaChing will vendor all of the items in the player's inventory that have been configured for bulk sales. If, for example, bag[2] was configured as a bulk sales bag, ChaChing will sell all items in bag[2] in addition to all grey items.

By default ChaChing is preconfigured to vendor all poor quality (grey) items. The default can be changed by unchecking the [Sell Grey] checkbox.

SETTING ADVANCED OPTIONS:

Press ESC to call up Blizzard's in-game menu and click on the [Interface Options] tab. Click the [AddOns] tab, select ChaChing from the list of AddOns, and then configure the options as you see fit. The following options are availabe:

(a) Two checkboxes, [Sell Gray] and [Sell White] item. The latter only sells common quality Armor and Weapons.
(b) Five checkboxes, one for each bag slot. Checking any checkbox marks that bag as containing items to sell regardless of their quality. All items in a checked bag will be sold.
(c) Excluded items Entry Box. If a player wants to prevent ChaChing from ever selling an item, drag the item to and click on the Entry Box. This will place the tiem in a table of items that can not be sold.

COMMAND LINE OPTIONS:

1. In the Chat command window, issue either of the following commands:
"chaching" or "/chaching help"

2. In the Chat window, issue the "/chaching options" command. This will bring up the same ChaChing window as in #1 above.

PLAYER RELOG AND UI RELOAD:

1. The exclusion table is retained across UI Reload and player logout events. At present, individual items cannot be removed from the exclusion list. Rather, the exclusion list must be cleared of all items.

2. If the [Sell Grey] box is cleared (i.e., unchecked), upon UI Reload or player login/logout, the [Sell Grey] checkbox will again be checked.

3 [Sell White], and [Bag] selections are not retained when the player logs out or performs and UI Reload. 