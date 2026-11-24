<p align="center">
  <img src="docs/header.png" alt="Gandalf, Aragorn, Frodo, Sam, Legolas, Gimli and Sauron as pixel sprites" width="640">
</p>

<h1 align="center">Middle-earth for Herdr</h1>

<p align="center">
  <em>One layout to rule your agents.</em><br>
  A Lord of the Rings layout for the <a href="https://herdr.dev">Herdr</a> desktop app.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Herdr-layout-4e7a32" alt="Herdr layout">
  <img src="https://img.shields.io/badge/macOS-supported-e0662e" alt="macOS">
  <img src="https://img.shields.io/badge/license-MIT-a8875a" alt="MIT license">
</p>

Your agents become the Fellowship and your spaces become the realms. Light mode is the Shire and dark mode is Mordor.

![Middle-earth in the Shire](docs/shire.png)

![Middle-earth in Mordor, with Sauron](docs/mordor.png)

- **Agents:** Gandalf, Aragorn, Frodo, Sam, Legolas and Gimli, as animated pixel sprites. Sauron joins in dark mode.
  - **Idle:** they smoke a pipe.
  - **Working:** they fight. The longer they work, the further they go: "On the road", then "Far from home" after 10 minutes, "Into the Wild" after 30 and "Into Mordor" after an hour.
  - **Blocked:** they raise a `!`.
  - **Done:** they bring back the Ring.
- **Cards:** each agent's card stacks its model, its space in bold, its session name and a bar for how much of its context window is used, so a narrow sidebar still shows everything.
- **Model and context:** both are read off the agent's screen, so the bar needs a statusline that prints the percentage (see [Model and context](#model-and-context-optional)).
- **Spaces:** each space gets a realm emblem: Shire, Rivendell, Gondor, Rohan, Lórien, Moria or Mordor.
- **Notifications:** toasts and macOS banners in character, with the sprite. Each hero has a line of their own ("Gandalf arrives precisely when he means to", "Gimli won't take another step without you").
- **Dock badge:** the Herdr icon shows how many agents are waiting for you.
- **Status bar:** counts agents by state ("2 on the road · 1 awaiting counsel"). On the right, your Claude Code and Codex plan usage (5-hour, weekly and per-model windows, e.g. `5h 42% · wk 61%`) from the [usage-limits](#plan-usage) mod, with a hover panel for reset times.
- **Also included:** a Claude Code icon holding the Ring, a hobbit-door shell icon, and custom alert sounds.

## Rare editions

<p align="center">
  <img src="docs/rare.png" alt="Gandalf the White, King Elessar, Frodo Elf-friend, Samwise the Gardener, Prince Legolas, Gimli of Helm's Deep and Annatar as pixel sprites" width="640">
</p>

Every new agent has a **10% chance** of drawing a hero's rare edition. It keeps it until it closes, with its own name on the card and its own art in every state:

- **Gandalf the White:** white robes and a white staff that bursts with light.
- **King Elessar:** the silver crown and the White Tree, with Andúril glowing blue.
- **Frodo Elf-friend:** the elven cloak of Lórien and the Phial of Galadriel.
- **Samwise the Gardener:** a straw hat, a spade and a mallorn sapling to water.
- **Prince Legolas:** the silver circlet of Mirkwood and two elven knives.
- **Gimli of Helm's Deep:** helm and mail, keeping count of orcs on his axe handle.
- **Annatar:** Sauron's fair form, forging a ring. Dark mode only, like Sauron.

### Ultra rare edition

<p align="center">
  <img src="docs/sax.png" alt="Epic Sax Gandalf playing a golden saxophone, in two frames" width="240">
</p>

When the draw lands on Gandalf, he has a **1% chance** of coming as **Epic Sax Gandalf**, a nod to the old Gandalf Sax Guy meme: the Grey Pilgrim on a golden saxophone, nodding to the riff while he works and letting one slow note drift up while he rests. That is about one agent in six hundred. If he shows up, you'll know.

## Install

Made for Herdr 0.1.16. Tested on macOS. Linux and Windows should work but are untested.

### macOS and Linux

```sh
git clone https://github.com/joaovitorwoliveira/herdr-middle-earth
cd herdr-middle-earth
./install.sh
```

The script copies the layout, themes and mods into `~/.config/herdr-app` (`HERDR_APP_HOME` picks another folder) and switches to the layout. It also merges the sounds into `settings.json` and the program icons into `programs.json`. Anything it replaces is moved to `backups/middle-earth-<time>/`. `ctrl-shift-l` switches back to your layout. The script needs `bash` and `python3`.

### Windows, or with your agent

Ask your agent: *"Add the Herdr layout at github.com/joaovitorwoliveira/herdr-middle-earth"*. Herdr's `AGENTS.md` tells it how, and `RECIPE.md` lists the extra steps: the themes and the sounds and icons snippets.

### System banners (optional)

macOS:

```sh
brew install terminal-notifier
open "$(brew --prefix terminal-notifier)/terminal-notifier.app"   # allow notifications once
```

A Focus mode hides banners unless `terminal-notifier` is allowed in it.

Linux: needs `notify-send` (package `libnotify-bin` or `libnotify`). Windows: in-app toasts only.

Without these, you still get the in-app toasts and sounds.

### Model and context (optional)

Herdr doesn't report an agent's model or context use, so the cards read them off the agent's screen every 15 seconds. They recognize:

- **Claude Code:** a statusline with `ctx 27%` or a bar like `▓▓░░░░░░░░ 27%`, and the model name (`Opus 5.5`). Claude Code shows no statusline by default. Add one that prints `.model.display_name` and `.context_window.used_percentage` from the JSON it receives.
- **pi:** its footer (`12.6%/500k`, `(openai-codex) gpt-6.1-sol • medium`).
- **Codex and others:** `85% context left` or `Context left until auto-compact: 12%`.

When nothing matches, the card simply has no bar.

## Plan usage

The status bar's right side comes from VladTemp27's [usage-limits](https://github.com/VladTemp27/herdr-mods/tree/main/usage-limits) mod (Apache-2.0), vendored in `mods/usage-limits` with its `LICENSE` and `NOTICE`. It asks your own CLIs every 5 minutes: `claude` briefly with `--safe-mode` and no prompt, and `codex app-server`. Each CLI authenticates itself; the mod reads no tokens or credentials. No Claude settings or statusline needed. The helpers are patched to use a plain pipe instead of a FIFO so they also work on Windows (see `mods/usage-limits/VENDORED.md`).

On Windows the helpers run `sh`: add `C:\Program Files\Git\bin` to your user `Path` (a Herdr started from the Start menu or a launcher only sees `Git\cmd`), then restart whatever launches Herdr so it picks up the new `Path`.

## Editing the art

The agent sprites are 24x24 grids and the realm emblems 16x16, all in `tools/sprites.py`. To regenerate them, run:

```sh
python3 tools/sprites.py    # SVG sprites and realm emblems
python3 tools/banners.py    # PNG banners for notifications (needs Pillow)
python3 tools/header.py     # the cast strips at the top of this README (needs Pillow)
```

`RECIPE.md` describes the whole build, for anyone (or any agent) rebuilding it from scratch.

## Contributing

Issues and pull requests are welcome, and reports from Linux and Windows help the most. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to test a change.

## License

MIT. `mods/usage-limits` is Apache-2.0 (see its `LICENSE` and `NOTICE`).
