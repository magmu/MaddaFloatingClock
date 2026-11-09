# Floating Clock

A customizable floating clock for macOS that stays on top of all windows. Click it to open a calendar.

Forked from [Madda Floating Clock by maddada](https://github.com/maddada/MaddaFloatingClock), which was itself based on [FloatClock by kolbusa](https://github.com/kolbusa/FloatClock). Thanks to both.

<br />

## How to install:
You just need the Xcode Command Line Tools. Run:
`xcode-select --install`

This opens a dialog to install the command line tools (includes Swift, git, make, etc.). It's about 1-2 GB and takes a few minutes.

After that completes, you can run:
`make install`

This command builds the .app file then moves it to your Applications folder.

You can add it to login items to make it auto start.

<br />

## Calendar:

Click the clock to open a calendar flyout (today's full date plus a month view you can page through). Click elsewhere or press Esc to close it.

<br />

## Upgrading from Madda Floating Clock

The app was renamed, so it installs alongside the old one instead of replacing it. Your settings carry over automatically on first launch. To clean up:

1. Quit the old clock (right-click it → Quit).
2. Delete `/Applications/Madda Floating Clock.app`.
3. Remove it from System Settings → General → Login Items, and add `Floating Clock` instead (or run `make register`).
4. If you used `make register` before, also run `launchctl unload ~/Library/LaunchAgents/MaddaFloatingClock.plist` and delete that file.

<br />

## Recommendation:

Hide the menu bar clock by switching this setting to analog.

<img width="500"  alt="2025-12-25_System Settings_03-48-46" src="https://github.com/user-attachments/assets/e746da60-16f2-4cae-b2fd-4e17b33168e5" />

<br />
<br />

## Features & Settings

- **Time format** - Customizable time display format (e.g., hh:mm a, HH:mm:ss)
- **Time font size** - Adjustable size for the time display
- **Show date** - Toggle date display on/off
- **Date format** - Customizable date format (e.g., EEE, MM-dd)
- **Date font size** - Independent size control for the date
- **Line spacing** - Adjust gap between time and date
- **Font selection** - Choose from 18 built-in fonts including SF Pro, Menlo, Helvetica
- **Text color** - Full color picker for customization
- **Opacity** - Transparency control (10-100%)
- **Text alignment** - Left, center, or right alignment
- **Chime reminder** - Audio chime at 5-60 minute intervals
- **Chime volume** - Adjustable volume (0-100%)
- **Calendar** - Click the clock to show a month calendar
- **Fixed position** - Pinned to the very bottom-right corner of the main display
- **Always on top** - Floats above all windows on all spaces
- **Menu bar icon** - Shows current day of week and date

<br />

## Position

The clock is always pinned to the bottom-right corner of the main display (the screen with the menu bar, set in System Settings > Displays). It sits in the true screen corner regardless of the Dock (a very wide Dock that reaches the corner can cover it) and re-pins itself automatically when displays are connected/disconnected, the resolution changes, or the Mac wakes from sleep.

<br />

## Build Instructions

Requires Swift

- Build: `make all`
- Clean: `make clean`
- Install: `make install`
- Add to login items: `make register`
- Remove from login items: `make unregister`
- Uninstall: `make uninstall`
