# FiveM Voting System
[Watch on YouTube](https://youtu.be/enZ7oDmBUM8)

[![ZAP-Hosting Gameserver and Webhosting](https://r2.fivemanage.com/JEc8nqRsuJODhwqwkKd7o/zap-hosting-banner-pulsescripts.png)](https://zap-hosting.com/pulsescripts?voucher=pulse-20)

######
## Support, Scripts & More
- [Script Store](https://pulsescripts.com/)
- [Join the Discord For Support](https://discord.gg/c6gXmtEf3H)
######

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- [pl_lib](https://github.com/pulsescripts/pl_lib) — PulseLib shared framework bridge (must be in the same resources folder)
- [oxmysql](https://github.com/overextended/oxmysql)

## Supported Frameworks
- **QBox** (`qbx_core`)
- **QBCore** (`qb-core`)
- **ESX** (`es_extended`)

Framework, TextUI, and Notification system are all auto-detected by `pl_lib` — no manual `Config.Notify` / `Config.DrawText` settings required.

## Installation Guide
1. Extract `pl-voting` **and** `pl_lib` into your server resources folder (both must be present)
2. Run `database.sql` against your database (HeidiSQL, phpMyAdmin, etc.)
3. Open `config.lua` and configure:
   - Add admin licenses / permission groups
   - Set `Config.LogWebhook` to your Discord webhook URL if you want logs
   - Adjust `Config.Candidates` and `Config.VotingBooths` for your server
4. Add both resources to `server.cfg` — `pl_lib` must start **before** `pl-voting`:
   ```
   ensure pl_lib
   ensure pl-voting
   ```
5. Restart the server

> **Upgrading from v1.0.x?**  
> The vote names in the `election` table were previously stored as JSON-encoded strings (e.g. `"John Doe"` with surrounding quotes). Run the following SQL to clean up existing records before starting the new version:
> ```sql
> UPDATE election SET name  = JSON_UNQUOTE(name)  WHERE name  LIKE '"%"';
> UPDATE election SET party = JSON_UNQUOTE(party) WHERE party LIKE '"%"';
> ```

## Configuration (`config.lua`)

| Key | Default | Description |
|-----|---------|-------------|
| `Config.Permissions` | `{"god","admin","mod"}` | ESX groups allowed to use the admin menu |
| `Config.AdminLicense` | `{}` | QB/QBox license identifiers with admin access |
| `Config.MenuCommand` | `'election'` | Command to open the admin panel |
| `Config.Log` | `true` | Enable/disable Discord logging |
| `Config.LogWebhook` | `""` | Discord webhook URL |
| `Config.LogType` | `'discord'` | `'discord'` \| `'fivemanage'` \| `'fivemerr'` |
| `Config.Candidates` | see file | List of `{ name, party }` objects |
| `Config.VotingBooths` | see file | `vector3` positions (configured for Gabz Townhall) |
| `Config.ServerAnnouncement` | `true` | Broadcast a chat message on election start/end |
| `Config.Debugpoly` | `false` | Show voting booth zone boxes |

## Security Notes
- All admin actions (`startElection`, `endElection`, `deleteRecord`, `resetVotes`, `resetSomeonesVote`) are validated **server-side** — a player cannot bypass the permission check by triggering events from the console.
- `voting:server:castVote` performs a server-side election-state check and duplicate-vote check before recording any vote.
- The UI no longer loads scripts from external CDNs (axios and FontAwesome removed); all JavaScript runs locally.

## 🛒 More Scripts from Pulse Scripts

| Script | Link |
|--------|------|
| 🍔 BurgerShot | [View](https://pulsescripts.com/product/burgershot) |
| 🐱 UwU Cat Cafe | [View](https://pulsescripts.com/product/uwucatcafe) |
| 🍕 Pizza This | [View](https://pulsescripts.com/product/6707931) |
| ☕ Bean Machine | [View](https://pulsescripts.com/product/6741732) |
| 🐟 KOI | [View](https://pulsescripts.com/product/6994012) |
| 🍽️ Diner | [View](https://pulsescripts.com/product/7007587) |
| 🌮 Taco Farmer | [View](https://pulsescripts.com/product/6707937) |
| 🐚 Pearls | [View](https://pulsescripts.com/product/6707935) |
| 🍔 Horny Burgers + UpnAtom | [View](https://pulsescripts.com/product/6749404) |
| 🍩 Rusty Browns | [View](https://pulsescripts.com/product/6707942) |
| 🍬 Bubble Gum Cafe | [View](https://pulsescripts.com/product/6707950) |
| 💊 Drug Selling | [View](https://pulsescripts.com/product/drugsellingv2) |
| 🛑 Wheel Clamper | [View](https://pulsescripts.com/product/6805299) |
