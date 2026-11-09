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
  "Comet")
    icon_result="󰚩"
    ;;
  "Zen")
    icon_result="󰈹"
    ;;
  "WezTerm")
    icon_result="󰆍"
    ;;
  "Rex Beta" | "Rex")
    icon_result=$(printf '\363\261\215\242') # md-google_downasaur
    ;;
  "ChatGPT")
    icon_result=$(printf '\356\262\201') # cod-openai
    ;;
  "Claude")
    icon_result="󱙺"
    ;;
  *)
    icon_result="󰏗"
    ;;
  esac
}

icon_map "$1"
echo "$icon_result"