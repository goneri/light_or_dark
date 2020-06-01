#!/bin/bash
# Firefox should have:
#   widget.content.allow-gtk-dark-theme True
#   no specific theme
#   Dark Reader mode should have "Use system color scheme"
#   about:newtab still comes with a default blank background, I use use the following addon
#   to load Google (which has a dark theme just fine) instead: https://addons.mozilla.org/en-CA/firefox/addon/new-tab-override/
# Google Chrome should have:
#   Dark Reader's "Use system color scheme" does not work great, the best is to
#   restart the browser with: google-chrome --force-dark-mode
# Gnome Terminal
#   Should use a single profile, its color schemes will be adjusted on the fly
# Gnome Shell theme:
#   dnf install -y gnome-shell-extension-user-theme.noarch gnome-shell-theme-flat-remix.noarch
function adjust_vim() {
    sed -i "s,\\(set background=\\).*,\\1$1," ~/.vimrc
    sed -i "s,\\(set background=\\).*,\\1$1," .config/nvim/init.vim
}

function light() {
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"

    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ foreground-color 'rgb(0,0,0)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-foreground-color '#ffffff'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ bold-color-same-as-fg true
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-colors-set false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-background-color '#000000'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ bold-color 'rgb(0,0,0)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-foreground-color '#ffffff'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-colors-set false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ background-color 'rgb(255,255,221)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-background-color '#000000'

    adjust_vim light

    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/fedora-workstation/corn.jpg
    crudini --set .config/gtk-3.0/settings.ini Settings gtk-application-prefer-dark-theme 0

    cat ~/.config/Code/User/settings.json | jq -r '."workbench.colorTheme" = $v' --arg v 'Default Light+' > ~/.config/Code/User/settings.new.json
    cp --backup ~/.config/Code/User/settings.new.json ~/.config/Code/User/settings.json
    gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-fullPanel"
}

function dark() {
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

    # Tango dark
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ foreground-color ''
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-foreground-color '#ffffff'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ bold-color-same-as-fg true
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-colors-set false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-background-color '#000000'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ bold-color 'rgb(0,0,0)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ cursor-foreground-color '#ffffff'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-colors-set false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ background-color 'rgb(46,52,54)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ highlight-background-color '#000000'

    adjust_vim dark

    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/fedora-workstation/aurora-over-iceland.png
    crudini --set .config/gtk-3.0/settings.ini Settings gtk-application-prefer-dark-theme 1
    cat ~/.config/Code/User/settings.json | jq -r '."workbench.colorTheme" = $v' --arg v 'Default Dark+' > ~/.config/Code/User/settings.new.json
    cp --backup ~/.config/Code/User/settings.new.json ~/.config/Code/User/settings.json
    gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Dark-fullPanel"
}

eval "gnome_terminal=$(gsettings get org.gnome.Terminal.ProfilesList default)"
echo "To restore the current gnome-terminal theme:"
for key in $(gsettings list-keys org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/|grep color); do
    echo "    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ ${key}"
done

echo "To restore the wallpaper:"
echo "    gsettings set org.gnome.desktop.background picture-uri $(gsettings get org.gnome.desktop.background picture-uri)"


$1
