ChaChing

CURRENT VERSION 2.5.1

NEW FEATURES:
New Command Line Options
    /chaching (or cc) <parameter> where parameter is one of...
        help - prints this help message
        config - brings up ChaChing's interface options dialog
        showtable - enumerates all items in the table of excluded items

Examples: 
 - display the exclusion table: cc showtable
 - show help: cc or cc help
 - bring up ChaChing's interface option table: cc config

DESCRIPTION:
ChaChing is another AddOn that permits a player to sell items in bulk.

- Chaching, by default, will sell all poor (grey) quality items.

- Chaching can be configured to sell all common (white) quality armor and weapon items. This is particularly useful at lower levels when many drops and quest rewards are of common quality.

CAVEAT: if you configure ChaChing to sell all common items, be sure to place items such as fishing poles, mining picks, blacksmith hammers, skinning knives, etc., on the exclusion list.

- Chaching allows allows a player to configure one or more bags from which all items in the selected bag(s) will be sold -- regardless of quality (poor, common, uncommon, rare, or epic. This capability is particularly useful for non-Enchanters as well as higher level characters when drops and quest rewards are soulbound and cannot be equipped or otherwise used by the player's character.

USAGE:
When a player opens a merchant window, ChaChing places a button at the top left of the window,[ChaChing]. When/if this button is clicked, ChaChing will vendor all of the items in the player's inventory as configured by the player. If, for example, bag[2] was configured as a "sell all" bag, ChaChing will sell all items in bag[2] in addition to all grey items. 

SETTING ADVANCED OPTIONS:
You may access ChaChing's interface options menu in two ways:

(1) press ESC to call up Blizzard's in-game menu, click on the [Interface Options] tab, click the [AddOns] tab, and then select ChaChing from the list of AddOn. 
(2) Issue the "/cc config" command in the game's Chat box.

The following options are available:

(a) Two checkboxes, [Sell Gray] and [Sell White] item. The latter only sells common quality Armor and Weapons.
(b) Five inventory bag checkboxes, one for each bag slot. Checking any checkbox instructs ChaChing to sell each and every item in that bag.
(c) Excluding selected items: if a player wants to prevent ChaChing from ever selling an item, drag the item to, and click on, the Entry Box. This will place the item in a table of items that can not be sold. For example, most of us have a common (white) quality fishing pole. Similarly, blacksmiths have a blacksmith hammer, and miners have a mining pick. The game considers these items to be weapons and should put on the table of items not to be sold.

PLAYER EXITING AND UI RELOADS:
1. All items residing on the exclusion table are retained across UI Reload and player logout/login events. At present, individual items cannot be removed from the exclusion list. Rather, the exclusion list must be cleared of all items. To do this, click the [Remove Entries] button on the Excluded Items dialog ("cc showtable").

2. If the [Sell Grey] box is cleared (i.e., unchecked), upon UI Reload or player logout, the [Sell Grey] checkbox will again be checked when the player enters the game world.
3. If the [Sell White] box is checked, it will remain checked until the player manually unchecks it. In other words, the state of the [Sell White] checkbox is retained across UI reloads and login/logout events.
4. [Bag] selections are not retained when the player logs out or performs and UI Reload. Upon reentering the game world, the [Sell White] button will be unchecked and all bags will be unchecked.
