ChaChing

CURRENT VERSION 3.0

DESCRIPTION:
ChaChing is another AddOn that permits a player to sell items in bulk. To this end, ChaChing supports the following options
(1) Sell all poor quality (i.e., grey) items. This is the default, but the player can turn this option off
(2) Sell all common quality (i.e., white) armor or weapons items. ChaChing also supports the ability to exclude certain white items
such as skinning knives, fishing poles, arclight spanners, etc., from being sold
(3) Sell all items, regardless of type or quality, by selecting a bag in which ALL items in that bag will be sold.

USAGE:
When a player opens a merchant window, ChaChing places a button at the top left of the window,[ChaChing]. When/if this button is clicked, ChaChing will vendor all of the items in the player's inventory as configured by the player. If, for example, bag[2] was configured as a "sell all" bag, ChaChing will sell all items in bag[2] in addition to all other configured items. 

SETTING OPTIONS:
You may access ChaChing's interface options menu in two ways:

(1) Press ESC to call up Blizzard's in-game menu, click on the [Interface Options] tab, click the [AddOns] tab, and then select ChaChing from the list of AddOn. 
(2) Issue the "/cc config" command in the game's Chat box.

The following options are available:

(a) Two checkboxes, [Sell Gray] and [Sell White] item. The latter only sells common quality Armor and Weapons.
(b) Five inventory bag checkboxes, one for each bag slot. Checking any checkbox instructs ChaChing to sell each and every item in that bag.
(c) Excluding selected items: if a player wants to prevent ChaChing from ever selling an item, the player must drop and drag the item to the Entry Box. This will place the item in a table of items that will not be sold. For example, most of us have a common (white) quality fishing pole. You should place all such needed items in the table of items not to be sold.

PLAYER EXITING AND UI RELOADS:
1. All items residing on the exclusion table are retained across game essions (i.e., UI Reload and player logout/login events). At present, individual items cannot be removed from the exclusion list. Rather, the exclusion list must be cleared of all items. To do this, click the [Remove Entries] button on the Excluded Items dialog ("cc showtable"). 
2. If the [Sell Grey] box is cleared (i.e., unchecked), upon UI Reload or player logout, the [Sell Grey] checkbox will again be checked when the player enters the game world.
3. If the [Sell White] box is checked, it will remain checked until the player manually unchecks it. In other words, the state of the [Sell White] checkbox is retained across UI reloads and login/logout events.
4. [Bag] selections are not retained when the player across game sessions. Upon reentering the game world, the [Sell White] button will be unchecked as will all bags.
