[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &

while true; do
	bar
	sleep 2
done &

xset r rate 300 50 &
xcape -e 'Super_L=Escape' &
xcape -e 'Super_R=Escape' &
dwmc xrdb &
exec dwm | $(sleep 0.5; bashwal &)
