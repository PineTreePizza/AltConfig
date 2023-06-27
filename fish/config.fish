if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_prompt
    set -l textcol  black
    set -l bgcol    blue
    set -l arrowcol blue
    set_color $arrowcol -b normal
    echo -n ""
    set_color $textcol -b $bgcol
    echo -n "󰌢  "(basename $PWD)" "
    set_color $arrowcol -b normal
    echo -n " "
end

set fish_greeting
#function fish_greeting

#	function center_text
#  		set -l textwidth (string length $argv[1])
#  		set -l spaces (math "($COLUMNS - $textwidth)/2")
#  		printf "%"$spaces"s" $argv[1]
#	end
	
#  set_color red -b normal
#  center_text " "
#  set_color black -b red
# 	echo -n "YOU WILL SUFFER"
#  set_color red -b normal
#  echo ""
#  echo ""
#end

set -Ux QT_QPA_PLATFORMTHEME qt6ct