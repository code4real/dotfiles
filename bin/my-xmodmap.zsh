# To see all the xmodmap mappings: xmodmap -pke

# To fully reset, for experimenting:
# setxkbmap -layout us

# Swap Caps_Lock and Control_L.
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add    Control = Control_L"

# Swap grave/asciitilde into Alt_R with Escape.
#xmodmap -e "remove  grave = grave"
#xmodmap -e "remove  asciitilde = asciitilde"
#xmodmap -e "remove  Alt = Alt_R"
xmodmap -e "keysym  Alt_R = grave asciitilde"
xmodmap -e "keycode 49 = Escape"
###xmodmap -e "add Alt = grave asciitilde"

# Compose key: Control_R
# http://superuser.com/questions/311612/how-to-get-alt-nnnn-keyboard-shortcuts-to-work-under-linux
#xmodmap -e "keycode 105 = Multi_key"
xmodmap -e "keysym Control_R = Multi_key"

# Other keys worth thinking about switching.
# Use xev to see keycodes/keysyms. On ario:
# KEYSYM      KEYCODE
# grave        49
# asciitilde   49
# Alt_R       108
# Super_L     133
# Menu        135
# Control_L    37
