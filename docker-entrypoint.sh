#!/bin/bash
export HOME=/config

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}



# Modify launch command
modify_launch_command() {
  local launcher="/data/Stardew/Stardew Valley/StardewValley"
  
  # Backup original file
  cp "$launcher" "${launcher}.bak"
  
  # Use safer sed replacement
  sed -i -e 's|env TERM=xterm $LAUNCHER "$@"$|env SHELL=/bin/bash TERM=xterm xterm -e "/bin/bash -c \\"$LAUNCHER \\"\\"\$@\\"\\""/|' "$launcher"
}

# Main function
main() {
  log "Initialization started..."
  
  # Run additional configuration steps for specific mods
  /opt/configure-mods.sh
  
  # Start log monitoring
  /opt/tail-smapi-log.sh &
  
  # Prepare to launch the game
  export XAUTHORITY=~/.Xauthority
  TERM=
  
  modify_launch_command
  
  log "Launching the game..."
  bash -c "/data/Stardew/Stardew\ Valley/StardewValley"
  
  # Keep the container running
  log "Game launched, keeping the process running..."
  sleep infinity
}

# Execute main function
main