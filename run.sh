#!/bin/bash
set -e

sudo -v

PROJECT_DIR="$(pwd)"
RUN_MODE="${1:-debug}"   # debug or car
export DISTANCE_OPENXR_MERGE_VEHICLE_SPACE_EXTENSION=1
LIVE_DECODE_SHELL_PID="/tmp/ignite_live_decode_shell.pid"
ARHUD_SHELL_PID="/tmp/ignite_arhud_shell.pid"
PCAP_REPLAY_SHELL_PID="/tmp/ignite_pcap_replay_shell.pid"

LIVE_DECODE_TITLE="IGNITE_live_decode"
ARHUD_TITLE="IGNITE_AR_HUD"
PCAP_REPLAY_TITLE="IGNITE_pcap_replay"

cd "$PROJECT_DIR"

close_old_terminal() {
    local PID_FILE="$1"
    local NAME="$2"

    if [ -f "$PID_FILE" ]; then
        local PID
        PID="$(cat "$PID_FILE")"

        if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
            echo "Closing old $NAME terminal..."

            # Kill child processes inside that terminal first
            sudo pkill -TERM -P "$PID" 2>/dev/null || true
            sleep 1

            # Kill the shell itself, which closes the terminal window
            kill "$PID" 2>/dev/null || true
            sleep 1
        fi

        rm -f "$PID_FILE"
    fi
}

############################################
# Restart live_decode
############################################
close_old_terminal "$LIVE_DECODE_SHELL_PID" "live_decode"


gnome-terminal --title="$LIVE_DECODE_TITLE" -- env \
    PID_FILE="$LIVE_DECODE_SHELL_PID" \
    PROJECT_DIR="$PROJECT_DIR" \
    bash -c '
echo $$ > "$PID_FILE"
trap "rm -f \"$PID_FILE\"" EXIT

sudo ./live_decode

echo
echo "live_decode exited. Press Enter to close this terminal."
read -r
'


############################################
# Restart AR-HUD
############################################

close_old_terminal "$ARHUD_SHELL_PID" "AR-HUD"

gnome-terminal --title="$ARHUD_TITLE" -- env \
    PID_FILE="$ARHUD_SHELL_PID" \
    PROJECT_DIR="$PROJECT_DIR" \
    RUN_MODE="$RUN_MODE" \
    bash -c '
echo $$ > "$PID_FILE"
trap '\''rm -f "$PID_FILE"'\'' EXIT

while true
do
    echo
    set +e
    sudo -E ./AR-HUD --mode="$RUN_MODE"
    ARHUD_EXIT_CODE=$?
    set -e

    echo "AR-HUD exited with code: $ARHUD_EXIT_CODE"

    if [ "$ARHUD_EXIT_CODE" -eq 100 ]; then
        echo "OTA completed. Restarting AR-HUD..."
        sleep 1
        continue
    fi

    echo
    echo "AR-HUD exited. Press Enter to close this terminal."
    read -r
    break
done
'



############################################
# Restart pcap replay
############################################

if [ "$RUN_MODE" = "debug" ]; then

    close_old_terminal "$PCAP_REPLAY_SHELL_PID" "pcap replay"

    gnome-terminal --title="$PCAP_REPLAY_TITLE" -- env \
        PID_FILE="$PCAP_REPLAY_SHELL_PID" \
        PROJECT_DIR="$PROJECT_DIR" \
		DISTANCE_OPENXR_MERGE_VEHICLE_SPACE_EXTENSION=1 \
        bash -c '
echo $$ > "$PID_FILE"
trap "rm -f \"$PID_FILE\"" EXIT

echo "Enter PCAP broadcaster path:"
read -r PCAP_BROADCASTER

if [ ! -f "$PCAP_BROADCASTER" ]; then
    echo "Error: File does not exist: $PCAP_BROADCASTER"
	read -r
	exit 1
fi


echo "Enter PCAP file path:"
read -r PCAP_FILE

if [ ! -f "$PCAP_FILE" ]; then
    echo "Error: File does not exist: $PCAP_FILE"
	read -r
	exit 1
fi



cd "$PROJECT_DIR"
sudo python3 "$PCAP_BROADCASTER" \
    --file "$PCAP_FILE" \
    --loop 100

echo
echo "pcap replay exited. Press Enter to close this terminal."
read -r
'

elif [ "$RUN_MODE" = "car" ] || [ "$RUN_MODE" = "demo" ]; then
    echo "Car mode selected: skipping pcap replay."
    close_old_terminal "$PCAP_REPLAY_SHELL_PID" "pcap replay"

else
    echo "Invalid mode: $RUN_MODE"
    echo "Usage: $0 [debug|car]"
    exit 1
fi