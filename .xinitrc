[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &

wal -R -n &
sxhkd &
xset r rate 300 50 &
xcape -e 'Super_L=Escape' &
xcape -e 'Super_R=Escape' &
dwmblocks &

solidwallpaper; sleep 1s | dwmc xrdb; exec dwm
