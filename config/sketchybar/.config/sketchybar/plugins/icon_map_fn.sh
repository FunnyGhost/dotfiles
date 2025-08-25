#!/bin/bash

function icon_map() {
  case "$1" in
  "Brave Browser")
    icon_result="󰇧"
    ;;
  "Cursor")
    icon_result="󰘦"
    ;;
  "Ghostty")
    icon_result="󰊠"
    ;;
  "Slack")
    icon_result="󰒱"
    ;;
  "Mail" | "Mailspring" | "MailMate" | "Superhuman" | "Spark" | "邮件")
    icon_result="󰇮"
    ;;
  "Calendar" | "日历" | "Fantastical" | "Cron" | "Amie" | "Calendrier" | "Notion Calendar")
    icon_result="󰃭"
    ;;
  "Dia")
    icon_result="󰖟"
    ;;
  *)
    icon_result="󰏗"
    ;;
  esac
}

icon_map "$1"
echo "$icon_result"