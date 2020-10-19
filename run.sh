#!/bin/bash
# SPDX short identifier: MIT
function adjust_vim() {
    sed -i "s,\\(set background=\\).*,\\1$1," ~/.vimrc
    sed -i "s,\\(set background=\\).*,\\1$1," ~/.config/nvim/init.vim
}

function adjust_konsole() {
    for a in $(qdbus |grep konsole); do
        for s in $(qdbus ${a}|grep /Sessions/); do
            qdbus ${a} ${s} org.kde.konsole.Session.setProfile $1
        done
    done
}

function light() {
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
    crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-application-prefer-dark-theme 0

    cat ~/.config/Code/User/settings.json | jq -r '."workbench.colorTheme" = $v' --arg v 'Default Light+' > ~/.config/Code/User/settings.new.json
    cp --backup ~/.config/Code/User/settings.new.json ~/.config/Code/User/settings.json
    gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-Blue-fullPanel"
    gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Blue-fullPanel"

    # KDE
    adjust_konsole Light
    lookandfeeltool --apply org.kde.breeze.desktop
}

function dark() {
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
    crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-application-prefer-dark-theme 1
    cat ~/.config/Code/User/settings.json | jq -r '."workbench.colorTheme" = $v' --arg v 'Default Dark+' > ~/.config/Code/User/settings.new.json
    cp --backup ~/.config/Code/User/settings.new.json ~/.config/Code/User/settings.json
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Dark-fullPanel"

    # KDE
    adjust_konsole Dark
    lookandfeeltool --apply org.kde.breezedark.desktop
}

eval "gnome_terminal=$(gsettings get org.gnome.Terminal.ProfilesList default)"
echo "To restore the current gnome-terminal theme:"
for key in $(gsettings list-keys org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/|grep color); do
    echo "    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$gnome_terminal/ ${key}"
done

echo "To restore the wallpaper:"
echo "    gsettings set org.gnome.desktop.background picture-uri $(gsettings get org.gnome.desktop.background picture-uri)"

gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings reset org.gnome.shell.extensions.user-theme name
gsettings reset org.gnome.desktop.interface gtk-theme
$1
