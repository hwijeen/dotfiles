#!/usr/bin/env bash

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

get_remote_info() {
  local command=$1

  local cmd=$({ pgrep -flaP `tmux display-message -p "#{pane_pid}"` ; ps -o command -p `tmux display-message -p "#{pane_pid}"` ; } | xargs -I{} echo {} | grep ssh | sed -E 's/^[0-9]*[[:blank:]]*ssh //')
  local cmd=$(echo $cmd|sed 's/\-p\s*'"$port"'//g')

  local host=$(echo $cmd | awk '{print $NF}'|cut -f2 -d@)

  echo $host
}

get_joined_info() {
  local pane_pid=$(tmux display-message -p "#{pane_pid}")

  # Look for srun in child processes of pane_pid
  local cmd=$(ps -ef | awk -v ppid=$pane_pid '$3 == ppid && /srun.*jobid/' | grep -v grep)

  local jobid=$(echo "$cmd" | grep -o '\--jobid [0-9]*' | awk '{print $2}')

  local node_info=$(squeue -j "$jobid" --noheader | awk '{print $8}')

  echo "$node_info"
}

get_info() {
  # If command is ssh do some magic
  if join_connected; then
     echo $(get_joined_info)
  elif ssh_connected; then
    echo $(get_remote_info)
  else
    echo $($1)
  fi
}

ssh_connected() {
  # Get current pane command
  local cmd=$(tmux display-message -p "#{pane_current_command}")

  [ $cmd = "ssh" ] || [ $cmd = "sshpass" ] || [ $cmd == "srun" ]
}

join_connected() {
  # Get current pane command
  local cmd=$(tmux display-message -p "#{pane_current_command}")

  [ $cmd = "srun" ]
}
