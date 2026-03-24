#!/bin/bash
# =============================================================================
# Claude Code Notification Hook
# =============================================================================
# Sends macOS native notifications when Claude Code needs attention.
# Used as a workaround for terminals that don't support OSC9 notifications
# (e.g., Zed terminal).
#
# Receives JSON on stdin with fields: title, message, notification_type

input=$(cat)
title=$(echo "$input" | jq -r '.title // "Claude Code"')
message=$(echo "$input" | jq -r '.message // "Attention needed"')

osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
