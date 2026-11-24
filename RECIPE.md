# Middle-earth

Your agents become the Fellowship: animated pixel sprites that smoke a pipe while idle, fight while they work and bring back the Ring when done. The Shire in light mode, Mordor in dark, where Sauron joins the cast.

![Middle-earth](preview.png)

![The window in the Shire](docs/shire.png)

## What you see

The window is a row with no system title bar (`"titlebar": "none"`). The macOS window buttons sit at `[12, 16]`. Ui font: `.SystemUIFont`, the system's own interface font (SF Pro on macOS). Terminal padding: `[14, 12]`. A 1px `border` divider runs between the columns.

- **Sidebar, left, 268px** (min 44, max 480, not resizable), on `chrome`:
  - **Brand**, 46px: the shipped `workspace-chrome`. It is a window drag area.
  - **Spaces** (`realms`), weight 1, min 90: each space shows a 20px pixel emblem instead of a colored letter tile. There are seven realms in order: Shire, Rivendell, Gondor, Rohan, Lórien, Moria and Mordor.
  - **Agents** (`fellowship`), weight 1, min 90: each agent card shows a 36px sprite beside a stack of lines: the character's name in semibold with a status word in `dim` ("On the road", "Resting", "Awaits counsel", "Returned"), then the model, the space in semibold (in the priority view; grouped by space, the section header names it), the tab title in `dim`, and the context bar. Each line truncates on its own; the card's height follows the lines it has.
  - **Footer**, 69px: `workspace-chrome` with `{ "footer": true }` (Settings, Add machine).
- **Work column**, right:
  - **Tabs**, 42px: the shipped `tabs`. It is a window drag area.
  - **Body**: a row with padding 8 and gap 8. The active tab's panes are cards: radius 10, a 1px `border` that turns `accent` on focus, and a 30px `pane` header always shown. A Files/Changes stack (368px, min 280, max 900) starts hidden on the right.
  - **Status bar**, 28px (`fellowship-status`): the machine, the branch, then one colored dot and count per agent state that has agents: "N awaiting counsel" (blocked, in the `blocked` color), "N returned", "N on the road", "N resting". With no agents it says "The road is quiet". The palette hint sits on the far right. It also puts the number of blocked agents on the Dock icon with `setBadge`, only when the number changes, and clears it at zero. The status bar is a row: `fellowship-status` (weight 3) and the vendored `usage-limits` (weight 2, min 130, `align: right`) showing Claude Code and Codex plan usage.

Themes: `{ "light": "shire", "dark": "mordor" }` set on the layout.

- **Shire**: background `#f4ecd8`, text `#3a3226`. Colors: accent `#4e7a32`, chrome `#e6d8b4`, canvas `#ece1c3`, popover `#faf4e4`, border `#cdb88c`, input `#a8875a`, hover `#ddcda2`, selected `#d5dcae`, muted `#6a5a40`, dim `#8a7a5c`.
- **Mordor**: background `#2b2420`, text `#e4d6c2`. Colors: accent `#e0662e`, chrome `#33281f`, canvas `#2f251e`, popover `#3a2e26`, border `#563826`, input `#7a4a2e`, hover `#3f3027`, selected `#4f2e1f`, muted `#c9b8a0`, dim `#a08e76`.

Program icons: Claude Code keeps its orange creature, now holding a gold ring. The shell is a round green hobbit door with a cream `>_` and a gold knob, drawn as a picture (`tint: false`).

## How it behaves

- **Casting.** A new agent takes a random free member of Gandalf, Aragorn, Frodo, Sam, Legolas and Gimli. If the system is dark when the agent appears, Sauron is one more member of the draw. The choice is kept per terminal address in shared `fellowship.cast`, so the character survives restarts and later theme changes. When every member is taken, the cast starts over: the next agent gets a random pick among the least-used members.
- **Rare editions.** A fresh casting has a 10% chance (`RARE_CHANCE` in `casting.js`) of drawing the hero's rare edition: Gandalf the White, King Elessar, Frodo Elf-friend, Samwise the Gardener, Prince Legolas, Gimli of Helm's Deep or Annatar. When the draw lands on Gandalf, a 1% roll (`SAX_CHANCE`) comes first for the ultra rare Epic Sax Gandalf (`gandalf-sax` sprites). The edition is kept per terminal address in shared `fellowship.rare` as `{ name, sprite }` and pruned with `fellowship.cast`. The card shows that name and those sprites in every state; toasts and banners use them too.
- **Working:** the character fights. Its status word follows how long it has worked: "On the road", "Far from home" from 10 minutes, "Into the Wild" from 30, "Into Mordor" from 60. Two frames swap every 800ms:
  - Gandalf: sparks burst from his staff.
  - Aragorn: draws his sword from its scabbard and thrusts.
  - Frodo: Sting glows blue.
  - Sam: swings a frying pan.
  - Legolas: draws his bow and looses an arrow.
  - Gimli: brings his axe down.
  - Sauron: strikes with a burning mace while his eyes flare.
- **Idle:** eyes closed, two frames every 1800ms:
  - Gandalf, Aragorn, Frodo, Sam and Gimli: a pipe with a glowing ember and a smoke ring rising.
  - Legolas: takes a bite of lembas instead.
  - Sauron: his Eye smoulders.
- **Blocked:** a still sprite with a red `!` in the top-left corner.
- **Done:** a still sprite with a small gold Ring in the top-left corner.
- **Toasts** (`fellowship-toast`, set as the layout's `toast`):
  - "<program> finished" and "<program> needs you" become a line of the hero's own, from `HERO_LINES` ("Gandalf arrives precisely when he means to", "Sam won't go on without you"). Each line takes the display name, so a rare edition reads "Gandalf the White arrives…". Heroes without lines fall back to "<Hero> returned from the quest" and "<Hero> awaits your counsel".
  - The body reads "<program> · <body>" and the toast shows the matching 28px sprite.
  - Other toasts look like Herdr's own, with an 18px icon.
- **System banners:** when the Herdr window is not active, the same text goes to the system too, with the character's 128px PNG as the picture.
  - macOS: Notification Center through `terminal-notifier`. Clicking the banner brings Herdr forward.
  - Linux: `notify-send`.
  - Windows: no banner, only the in-app toast.
- **Sounds:** a custom done sound and a custom blocked sound.
- **Everything else** (clicks, keys, sorting, pinning, sub-agents) is the shipped `agents`, `spaces` and `toast` behavior.

## Built from

- **Layout:** a clone of `main` 0.1.16 (`layouts/middle-earth.json`). Root keys: `theme`, `ui_font`, `toast`, `titlebar`, `traffic_lights`, `preview` (`layouts/middle-earth.png`, which the settings screen shows).
- **Shipped mods used as they are:** `workspace-chrome`, `tabs`, `pane`, `files` and `changes`.
- **`fellowship`:** a clone of `agents`.
  - `castFor` assigns the characters, using `shared` / `setShared` and `settings().dark`.
  - `heroSprite` picks the pose. A two-frame swap is two stacked `image()`s whose `opacity` loops linearly from 7 to -6 and from -6 to 7. The over-range values clamp, so each frame stays fully on or fully off for half of the period: a crisp swap instead of a fade.
  - Sprites are in `sprites/<hero>[-work|-2|-idle|-idle-2|-blocked|-done].svg`: seven heroes with seven files each, and the same seven files for each rare edition as `<hero>-rare`, plus `gandalf-sax`.
  - The folder also holds `banners/<hero>[-rare]-<blocked|done>.png`, `sounds/` and `program-icons/`.
- **`fellowship-status`:** a clone of `workspace-status`, with counts from `agents()` by status.
- **`fellowship-toast`:** a clone of `toast`.
  - `heroOf()` matches the title against `/^(.+) (finished|needs you)$/`. It reads the terminal from `action.args.terminal` when the action is `agent.focus`, then looks up `fellowship.cast` and `fellowship.rare`.
  - `init()` posts to the system by `window().platform`. On macOS it uses `exec("terminal-notifier", [...])` with `-activate dev.herdr.app -contentImage <appHome>/<png>`, falling back to `osascript` if that fails. On Linux it uses `exec("notify-send", ["-a", "Herdr", "-i", <png>, title, body])`. It skips this when `window().active` or during `checking()`.
- **`realms`:** a clone of `spaces`. It keeps each space's realm in shared `realms.emblems` and draws `emblems/<realm>.svg`.
- **Outside the layout:**
  - `programs.json` sets the `claude` and `shell` icons.
  - `settings.json` sets `sounds.done` and `sounds.blocked`, relative to the home.
  - `install.sh` merges both files.
- **Art:** `tools/sprites.py` writes every SVG from character grids (24x24 agents, 16x16 realm emblems), with `shape-rendering="crispEdges"`. `tools/banners.py` (Pillow) scales the blocked and done poses 8x with nearest-neighbor into PNGs. `tools/header.py` draws the README's cast strips, `docs/header.png`, `docs/rare.png` and `docs/sax.png`. The SVGs declare width and height 36 over a 24x24 viewBox: Herdr rasterizes an SVG at its declared size, and a 24px raster stretched to 36 picks up faint lines at its edges.

## Watch out

- **Installing takes more than `layouts/` and `mods/`.** An agent adding this layout must also:
  1. Copy `themes/shire.json` and `themes/mordor.json` to the home's `themes/`. Without them the layout shows the person's own theme.
  2. Copy `layouts/middle-earth.png` beside the layout file. Settings shows it as the layout's picture.
  3. Merge `settings.snippet.json` into the home's `settings.json` (the `sounds` keys) and `programs.json` into the home's `programs.json` (the `claude` and `shell` entries), key by key, keeping everything else.

  On macOS and Linux, `./install.sh` does all of this and moves anything it replaces to `backups/middle-earth-<time>/`. On Windows, do it by hand.
- **Version:** built and tested on Herdr 0.1.16, macOS. Linux and Windows follow the code and Herdr's docs, but nobody has tested them.
- **Palette keys:** each grid character maps to a color per sprite. Overlays such as smoke, badges and weapons must use keys that the base palette does not use: smoke uses `1` to `6`. Otherwise they recolor a beard or a pack.
- **Badges** are drawn into the empty top-left 4x5 corner. The generator asserts that the corner is empty.
- **Program icons and sounds** belong to the person's own files, not to the layout. Herdr reads them from `programs.json` and `settings.json` for every layout.
- **Banners from inside Herdr:**
  - `osascript display notification` exits 0 but shows nothing, so `terminal-notifier` is needed.
  - `terminal-notifier` has to be allowed once: open its `.app`.
  - A Focus mode hides banners unless `terminal-notifier` is allowed in it.
- **Posting from `init()`:** the post happens in `init()`, not in `render()`. `render()` may never run while the window is on another macOS Space.
- **Image loading:** images load lazily, so the first frame after a switch can show empty sprite slots.

## Done when

- `herdr-app check mods/<name>` passes for `fellowship`, `fellowship-toast`, `fellowship-status` and `realms`.
- `layout.switch {"name":"middle-earth"}` shows the Shire in light mode and Mordor in dark mode, in the system font.
- Starting a Claude Code agent adds a random member (Sauron can be drawn when dark) with a working animation. When the agent waits, it switches to the idle pipe.
- A second agent gets the next free character, and the characters stay the same after a restart.
- A finished agent shows its hero's done line with the Ring sprite and plays `done-alert.mp3`.
- An agent that needs you puts a number on the Dock icon.
- With another app in front and `terminal-notifier` installed, the same message arrives as a macOS banner with the sprite.
- The status bar counts agents by state, or says "The road is quiet".
