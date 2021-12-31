[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &

while true; do
           sbar
           sleep 2
done &

dunst &
sxhkd &
xset r rate 300 50 &
xcape -e 'Super_L=Escape' &
xcape -e 'Super_R=Escape' &
dwmc xrdb &
exec dwm | bashwal
