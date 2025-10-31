#!/bin/bash
export HOME=/config

#!/bin/sh

# 配置RemoteControl mod
configure_remote_control_mod() {
  # 如果没有默认管理员配置或配置文件不存在则退出
  if [ -z "${REMOTE_CONTROL_DEFAULT_ADMINS}" ] || [ ! -f "/data/Stardew/Stardew Valley/Mods/RemoteControl/config.json" ]; then
    return
  fi

  # 临时文件处理，确保操作原子性
  local config_file="/data/Stardew/Stardew Valley/Mods/RemoteControl/config.json"
  local temp_file="${config_file}.tmp"
  
  # 添加默认管理员到管理员列表
  jq ".admins[.admins | length] |= . + ${REMOTE_CONTROL_DEFAULT_ADMINS}" "$config_file" > "$temp_file"
  
  # 验证修改后的配置是否有效
  if jq -e . "$temp_file" >/dev/null 2>&1; then
    mv -f "$temp_file" "$config_file"
    echo "Successfully added default admins to RemoteControl config"
  else
    echo "Error: Failed to modify RemoteControl config. Invalid JSON generated."
    rm -f "$temp_file"
  fi
}

# Initialize mods directory
init_mods_dir() {
  local mods_dir="/data/Stardew/Stardew Valley/Mods"
  local default_mods="/data/default-mods"
  
  if [ -z "$(ls -A "$mods_dir")" ] && [ -n "$(ls -A "$default_mods")" ]; then
    log "Mods directory is empty, attempting to load default mods..."
    cp -a "$default_mods/." "$mods_dir/"
  fi
}

# Process a single mod
process_mod() {
  local mod_path="$1"
  local mod=$(basename "$mod_path")
  
  # Normalize mod name to environment variable format
  local var="ENABLE_$(echo "${mod^^}" | tr -cd '[A-Z]')_MOD"
  
  # Remove mod if not enabled
  if [ "${!var}" != "true" ]; then
    log "Removing ${mod_path} (${var}=${!var})"
    rm -rf "$mod_path"
    return
  fi
  
  # Configure mod
  if [ -f "${mod_path}/config.json.template" ]; then
    log "Configuring ${mod_path}config.json"
    local config_file="${mod_path}config.json"
    
    # Generate config only if it doesn't exist or is empty
    if [ "$(cat "$config_file" 2> /dev/null)" == "" ]; then
      envsubst < "${mod_path}/config.json.template" > "$config_file"
    fi
  fi
}

# Process all mods
process_all_mods() {
  local mods_dir="/data/Stardew/Stardew Valley/Mods"
  
  for mod_path in "$mods_dir"/*/; do
    if [ -d "$mod_path" ]; then
      process_mod "$mod_path"
    fi
  done
}
# 执行所有mod配置
main() {
  init_mods_dir
  process_all_mods
  configure_remote_control_mod
  # 可以添加其他mod配置函数调用
}

main