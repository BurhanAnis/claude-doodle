# Doodle

Sometimes it's faster to draw it than to explain it.

Doodle is a tiny sketch pad for macOS. Press **⌃⌥D** (Control + Option + D) anywhere, sketch,
press **Enter**, and your drawing is on the clipboard as an image, ready to paste into Claude,
ChatGPT, Slack, an email, or anything else that accepts images.

It was built for brainstorming with AI assistants in the terminal, where describing a layout or
a diagram in words takes a paragraph and drawing it takes ten seconds.

- Pen, line, arrow, box, oval, text and eraser, in five colours and five sizes
- Paste or drop a screenshot onto the canvas to draw on top of it
- The copied image is cropped to what you drew, so there's no big empty margin
- A copy of every doodle is saved to `~/Doodles`
- No app to install beyond Hammerspoon; it's one Lua file and one HTML page

## Requirements

- macOS
- [Hammerspoon](https://www.hammerspoon.org), a free, open-source automation tool for macOS.
  Doodle runs inside it.

## Install

Pick the section that matches you.

### I've never used Hammerspoon

1. **Install Hammerspoon.** With [Homebrew](https://brew.sh):

   ```sh
   brew install --cask hammerspoon
   ```

   Or download the latest release from
   [github.com/Hammerspoon/hammerspoon/releases](https://github.com/Hammerspoon/hammerspoon/releases),
   unzip it, and drag `Hammerspoon.app` into your Applications folder.

2. **Open Hammerspoon** from Applications. A hammer icon appears in your menu bar.

3. **Give it Accessibility permission.** In the Hammerspoon preferences window that opens, click
   **Enable Accessibility**, or go to **System Settings → Privacy & Security → Accessibility** and
   switch on Hammerspoon. Doodle needs this to put you back in the window you were working in
   after it closes.

4. **Tick "Launch Hammerspoon at login"** in the same preferences window, so the hotkey is always
   available.

5. **Download Doodle and tell Hammerspoon to load it.** Paste this into Terminal:

   ```sh
   git clone https://github.com/BurhanAnis/claude-doodle.git ~/claude-doodle
   mkdir -p ~/.hammerspoon
   echo 'dofile(os.getenv("HOME") .. "/claude-doodle/doodle.lua")' >> ~/.hammerspoon/init.lua
   ```

6. **Reload Hammerspoon.** Click the hammer icon in the menu bar and choose **Reload Config**.
That's it. Press **⌃⌥D** to try it.

### I already use Hammerspoon

1. Clone the repo:

   ```sh
   git clone https://github.com/BurhanAnis/claude-doodle.git ~/claude-doodle
   ```

2. Add this line to your `~/.hammerspoon/init.lua`:

   ```lua
   dofile(os.getenv("HOME") .. "/claude-doodle/doodle.lua")
   ```

3. Reload your config.

Doodle binds **⌃⌥D**. If that clashes with one of your own hotkeys, see
[Changing the hotkey](#changing-the-hotkey). It doesn't touch anything else in your config.

You can clone it somewhere other than `~/claude-doodle`; just point the `dofile` line at the
new location.

## Using it

1. Press **⌃⌥D**. A canvas opens in the middle of your screen.
2. Draw.
3. Press **Enter**. The canvas closes, you're back where you were, and the drawing is on your
   clipboard.
4. Paste it.

**Pasting into a terminal** (for example Claude Code): use **Control + V**, not Command + V.
Command + V is handled by the terminal app, which can only paste text, so an image never reaches
the program. Control + V goes straight to the program, which reads the image from the clipboard
itself. In normal apps, Command + V works as usual.

### Tools and shortcuts

| Key | Does |
|---|---|
| **P** | Pen |
| **L** | Line |
| **A** | Arrow |
| **R** | Box |
| **O** | Oval |
| **T** | Text: click where it should go, type, **Enter** to place, **Shift+Enter** for a new line |
| **E** | Eraser |
| **F** | Toggle filled boxes and ovals |
| **1–5** | Colour |
| **[ ]** | Smaller / bigger |
| **Shift** (while dragging) | Straight lines at 45° steps, squares and circles |
| **⌘Z** | Undo |
| **⌫** | Clear the canvas (undoable) |
| **⌘V** | Paste a screenshot to draw on |
| **Enter** | Copy and close |
| **Esc** | Close without copying |

Every tool is also a button on the toolbar.

### Drawing on a screenshot

1. Take a screenshot to the clipboard with **⌃⇧⌘4** (Control + Shift + Command + 4) and drag
   over the area you want.
2. Press **⌃⌥D**, then **⌘V**. The screenshot appears on the canvas.
3. Circle things, add arrows and notes, then press **Enter**.

You can also drag an image file onto the canvas. Screenshots always sit underneath your
drawing. Resize the canvas window before pasting if you want a large screenshot shown bigger.

### Where doodles are saved

Each copied doodle is also saved as a PNG in `~/Doodles`, named by date and time, in case you
copy something else before pasting.

## Changing the hotkey

Open `doodle.lua` and edit the line near the top:

```lua
hotkey = { { "ctrl", "alt" }, "D" },
```

Modifier names are `"cmd"`, `"ctrl"`, `"alt"` (Option) and `"shift"`. The window size and the
save folder are set in the same block. Reload Hammerspoon afterwards.

## Troubleshooting

**Nothing happens when I press the hotkey.** Click the hammer icon → **Console** and look for a
red error. The most common cause is the `dofile` path not matching where you cloned the repo.
Also check that Hammerspoon is running (hammer icon in the menu bar).

**The canvas opens but I'm not put back in my window afterwards.** Hammerspoon needs
Accessibility permission: System Settings → Privacy & Security → Accessibility.

**Pasting into the terminal does nothing.** Use Control + V, not Command + V (see
[Using it](#using-it)). Whether a terminal program accepts pasted images at all depends on the
program; Claude Code does.

**⌘V on the canvas says "No image on the clipboard".** Make sure you copied an image, not a
file. Screenshots taken with ⌃⇧⌘4 are copied as images; ⇧⌘4 alone saves a file instead, which
you can drag onto the canvas.

## Updating

```sh
cd ~/claude-doodle && git pull
```

Then reload Hammerspoon.

## Uninstalling

1. Remove the `dofile(...)` line from `~/.hammerspoon/init.lua` and reload Hammerspoon.
2. Delete the folder: `rm -rf ~/claude-doodle`.
3. Optionally delete your saved doodles in `~/Doodles`, and Hammerspoon itself if you don't use
   it for anything else.
