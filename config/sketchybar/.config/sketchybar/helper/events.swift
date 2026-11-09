// Today's remaining timed events from Calendar.app (EventKit), from every
// calendar in it, skipping all-day events and ones you declined.
// One line each, by start:
//   start epoch<TAB>end epoch<TAB>title<TAB>meeting URL<TAB>event URL
// The meeting URL (Zoom, Meet, Teams, Webex) is empty for non-meetings; the
// event URL opens the event in Calendar.app.
// Exits 2 when Calendar access isn't granted.
//
// Built on first use by plugins/calendar.sh, with Info.plist embedded:
// macOS needs its usage description before it will ask for access.

import EventKit
import Foundation

let store = EKEventStore()
let asked = DispatchSemaphore(value: 0)
var granted = false
store.requestFullAccessToEvents { ok, _ in
  granted = ok
  asked.signal()
}
asked.wait()
guard granted else { exit(2) }

let meeting = #"https://[^\s<>"']*(zoom\.us/j/|meet\.google\.com/|teams\.microsoft\.com/l/meetup-join|teams\.live\.com/meet|webex\.com/)[^\s<>"']*"#

func meetingURL(_ e: EKEvent) -> String {
  for text in [e.url?.absoluteString, e.location, e.notes].compactMap({ $0 }) {
    if let r = text.range(of: meeting, options: .regularExpression) { return String(text[r]) }
  }
  return ""
}

// Undocumented, but what Calendar.app itself answers to
func eventURL(_ e: EKEvent) -> String {
  let id = e.eventIdentifier.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
  return "ical://ekevent/\(id)?method=show&options=more"
}

func clean(_ s: String) -> String {
  s.components(separatedBy: .newlines).joined(separator: " ").replacingOccurrences(of: "\t", with: " ")
}

let now = Date()
let start = Calendar.current.startOfDay(for: now)
let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

let events = store.events(matching: store.predicateForEvents(withStart: start, end: end, calendars: nil))
  .filter { !$0.isAllDay && $0.endDate > now }
  .filter { $0.attendees?.first(where: { $0.isCurrentUser })?.participantStatus != .declined }
  .sorted { $0.startDate < $1.startDate }

for e in events {
  let fields = [
    String(Int(e.startDate.timeIntervalSince1970)), String(Int(e.endDate.timeIntervalSince1970)),
    clean(e.title ?? ""), meetingURL(e), eventURL(e),
  ]
  print(fields.joined(separator: "\t"))
}
