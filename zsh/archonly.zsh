# ------- alert if long since last pacman action ---------
last_update=$(awk 'END{sub(/\[/,""); sub(/\]/,""); print $1}' /var/log/pacman.log)

# get time from last pacman -Syu
diff=$(datediff --format="%d" $last_update now)

# if there is more than 3 days since last update
if (( $diff > 3 )); then
    # compare todays date to previously stored
    cmp -s $XDG_DATA_HOME/curdate <(date +%D)
    # we only want to alert once per day

    # check return value of cmp. 0 if they were the same,
    # so we should not alert
    if [ $? -ne 0 ]; then
        # if not, tell how long since last
        echo -e "Last update: $diff days ago"
        # write new date, so that this does not happen again today
        date +%D > $XDG_DATA_HOME/curdate
    fi
fi

catimg -w 100 $XDG_CONFIG_HOME/zsh/cat.jpg
echo "                Erm, what the flip?"
