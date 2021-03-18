# Easily switch your environment between dark and light theme

This script switch the following components between the two modes:

- Gnome3
- vim and neovim
- gnome-terminal
- VSCode
- Firefox
- Gnome Chrome
- Emacs (Doom)

Tested on Fedora 33.

## Configuration

Firefox should be configured with:
- `widget.content.allow-gtk-dark-theme True` in `about:config`
- no specific theme, it should use system GTK
- Dark Reader extension enabled ( https://addons.mozilla.org/en-CA/firefox/addon/darkreader/ )
- Dark Reader mode should have "Use system color scheme"
Google Chrome should have:
- Dark Reader extensio enabled ( https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh?hl=en )
- Dark Reader's "Use system color scheme" does not work great, the best is to restart the browser with: google-chrome --force-dark-mode
Gnome Terminal:
- Should use a single profile, its color schemes will be adjusted on the fly
Gnome Shell theme:
- `dnf install -y gnome-shell-extension-user-theme gnome-shell-theme-flat-remix`
