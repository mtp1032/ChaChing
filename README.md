# ChaChing

CURRENT VERSION: 1.1.0

NEW FEATURES:
 - Ability to exclude specific items from being sold. Items to be excluded are dragged then dropped onto the ChaChing options menu entry box.
 - Command line
    /chaching <parameter> where parameter is one of...
        help        prints a help message
        showlist    enumerates all items in the Excluded Table
        resetlist   clears all items from the Excluded Table
        options     brings up the interface options menu

DESCRIPTION:

ChaChing is another AddOn that permits a player to sell items in bulk. However, ChaChing differs from most similar AddOns in two important ways:

First, and in addition to bulk sales of poor (grey) items, players can configure ChaChing to sell all common (white) weapon and armor items. This is particularly useful at lower levels when many (most) drops and quest rewards are of common quality.

Second, ChaChing allows a player to configure one or more bags from which all items in the selected bag(s) will be sold -- regardless of their quality (poor, common, uncommon, rare, or epic). This capability is particularly useful for non-Enchanters as well as higher level characters when drops and quest rewards are soulbound and cannot be equipped or otherwise used by the player's character.

Third, and not unique to these kinds of AddOns, ChaChing offers the ability to exclude items from being sold (inadvertantly, usually)

USAGE:

ChaChing is preconfigured to automatically sell all poor (grey) quality items in the player's inventory. This behavior can be changed by unchecking the [Sell Grey] checkbox in ChaChing's options menu.

When a player opens a merchant window, ChaChing will have placed a button at the top left of the window, [ChaChing]. When/if the button is clicked, ChaChing will vendor all of the items in the player's inventory that have been configured for bulk sales. If, for example, bag[2] was configured as a bulk sales bag, ChaChing will sell all items in bag[2] in addition to all grey items. 

SETTING ADVANCED OPTIONS:

To access ChaChing's options dialog you can (1) press ESC to call up Blizzard's in-game menu, click on the [Interface Options] tab, click the [AddOns] tab, and then select ChaChing from the list of AddOn. You may now configure the options as you see fit. Alternatively, you may issue the following command in the Chat box: "/chaching options". This opens ChaChing's options dialog directly.

The following options are availabe:

(a) Two checkboxes, [Sell Gray] and [Sell White] item. The latter only sells common quality Armor and Weapons.
(b) Five checkboxes, one for each bag slot. Checking any checkbox marks that bag as containing items to sell regardless of their quality. All items in a checked bag will be sold.
(c) Excluded items: if a player wants to prevent ChaChing from ever selling an item, drag the item to and click on the Entry Box. This will place the tiem in a table of items that can not be sold. For example, most of us have a common (white) quality fishing pole. The game considers a fishing pole to be weapon. Similarly, many (most?) skinners have a common (white) skinning knife. These are items you should put on the table of items not to be sold.

PLAYER RELOGING AND UI RELOAD:

1. All items residing on the exclusion table are retained across UI Reload and player logou/login events. At present, individual items cannot be removed from the exclusion list. Rather, the exclusion list must be cleared of all items. In the next release of ChaChing, the ability to remove individual items from the table will be supported.

2. If the [Sell Grey] box is cleared (i.e., unchecked), upon UI Reload or player logout, the [Sell Grey] checkbox will again be checked when the player enters the game world.

3 [Sell White], and [Bag] selections are not retained when the player logs out or performs and UI Reload. Upon reentering the game world, the [Sell White] button will be unchecked and all bags will be unchecked.