# ChaChing 💰

**World of Warcraft Auction House Companion**  
*Smart selling decisions with instant "Cha-Ching!" feedback*

---

## Table of Contents

- [ChaChing 💰](#chaching-)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Features](#features)
  - [How It Works](#how-it-works)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Commands](#commands)
  - [Configuration](#configuration)
  - [Supported Versions](#supported-versions)
  - [Contributing](#contributing)
  - [License](#license)
  - [Future Plans](#future-plans)

---

## About

**ChaChing** is a lightweight World of Warcraft addon that helps you make smarter Auction House decisions.  

It analyzes your items, suggests optimal sell prices, and gives you satisfying **instant "Cha-Ching!" audio + visual feedback** when you make a good sale — turning mundane vendor/AH tasks into a rewarding experience.

---

## Features

- ✅ Intelligent price suggestions based on current market data
- ✅ Instant "Cha-Ching!" sound + celebration animation on successful sales
- ✅ Smart item valuation and undercutting logic
- ✅ Sell / Vendor decision engine
- ✅ Exclusion lists (never auto-sell certain items)
- ✅ Mini-map icon + slash commands
- ✅ Lightweight & performant (pure Lua)
- ✅ Localization support
- ✅ Debug tools for power users

---

## How It Works

1. Scan the Auction House or open your bags
2. ChaChing evaluates each item
3. It recommends **Sell**, **Vendor**, or **Keep**
4. When you sell at a good price → you hear the iconic **Cha-Ching!** and see a visual reward

---

## Installation

1. Download the latest release (or clone this repo)
2. Extract the `ChaChing` folder
3. Copy it into your WoW AddOns directory:
   - **Retail**: `World of Warcraft\_retail_\Interface\AddOns\`
   - **TBC Classic / Anniversary**: `World of Warcraft\_classic_\Interface\AddOns\`
4. Restart WoW or reload UI (`/reload`)

---

## Usage

- `/chaching` or `/cc` — Open main menu
- `/cc scan` — Force a market scan
- `/cc config` — Open settings

The mini-map icon also provides quick access.

---

## Commands

| Command              | Description                     |
|----------------------|---------------------------------|
| `/cc`                | Toggle main window              |
| `/cc scan`           | Refresh market data             |
| `/cc sell`           | Quick sell evaluation           |
| `/cc debug`          | Toggle debug mode               |
| `/cc reset`          | Reset saved settings            |

---

## Configuration

All settings are saved per-character and can be adjusted in-game via the options panel.

---

## Supported Versions

- **Retail** (The War Within + future patches)
- **Classic Era**
- **Season of Discovery**
- **TBC Anniversary / Classic**

---

## Contributing

Pull requests are welcome!  
See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Future Plans

- Enhanced Auction House scanning
- Integration with external price databases (future)
- Mobile/web companion app (long-term vision)
- Guild sharing of price data

---

**Made with ❤️ for fellow gold makers and loot hoarders.**

---

**Ready to replace your current README?**  

Just copy the content above into `README.md`, commit it with a message like:

> docs: update README to WoW addon focus

Then push.

After that, tell me and we’ll do the next piece (e.g. proper `ChaChing.toc` file, folder cleanup, etc.).  

Want any tweaks to this README before you commit it?