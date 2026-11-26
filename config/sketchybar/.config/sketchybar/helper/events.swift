// Today's remaining timed events from the macOS calendar store (EventKit),
// the calendars MyCal and Calendar.app show, skipping all-day events and
// ones you declined. One line each, by start:
//   start epoch<TAB>end epoch<TAB>title<TAB>meeting URL
// The meeting URL (Zoom, Meet, Teams, Webex) is empty for non-meetings.
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
    clean(e.title ?? ""), meetingURL(e),
  ]
  print(fields.joined(separator: "\t"))
}
