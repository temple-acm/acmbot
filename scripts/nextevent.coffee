# Description:
#   Script to retrieve the next ACM event from our public calendar feed.
#
# Commands:
#   next <x> events - Retrieves the next <x> events, up to 5 to avoid spam
#   next event - returns the upcoming event from the current date.
#

feedparser = require "feedparser"
request = require "request"
entities = require "entities"


# Helper functions for the date parsing and the things

padDigit = (n) ->
    `(n < 10) ? ('0' + n) : n`

isoDateString = (d) ->
    return d.getUTCFullYear() + '-' + padDigit(d.getUTCMonth() + 1) + '-' + padDigit(d.getUTCDate()) + 'T' + padDigit(d.getUTCHours()) + ':' + padDigit(d.getUTCMinutes()) + ':' + padDigit(d.getUTCSeconds()) + 'Z'


module.exports = (robot) ->
    robot.respond /next (?:([2-9]|[1-9]\d+) events$|event$)/i, (msg) ->
        num_events = msg.match[1]

        if typeof(num_events) != 'undefined'
            if num_events > 5
                msg.send "You can't ask for that many events at once. Try checking the actual calendar, it'll be easier."
                return
        else
            num_events = 1


        isoDateTime = isoDateString(new Date())
        ACM_CALENDAR_URL = "https://www.google.com/calendar/feeds/tuacm%40temple.edu/public/basic?orderby=starttime&sortorder=ascending&start-min=#{isoDateTime}"

        parser = new feedparser()
        rssEntries = []
        events = []


        cal_req = request(ACM_CALENDAR_URL) # I think this automatically interpolates?
        cal_req.on 'response', () =>
                `this.pipe(parser);`
                return
        cal_req.on 'error', (cb) ->
                msg.send 'There was an error retrieving the calendar data. Try again later.'
                return

        parser.on 'readable', () ->
            rssEntry = ""
            while rssEntry = `this.read()`
                if `rssEntries.length < num_events`
                    rssEntries.push(rssEntry)

        .on 'end', () ->
            for entry in rssEntries
                event =
                    title: entities.decodeHTML(entry.title)
                data = entry.description.split('\n')
                for line in data
                    desc = line.match(/Event Description: (.*)/)
                    if desc
                        event.description = desc[1]
                    status = line.match(/Event Status: (.*)/)
                    if status
                        event.status = status[1]

                data = entry.summary.split('\n')
                for line in data
                    evt_when = line.match(/^(<br>)?When: (.*)$/)
                    evt_where = line.match(/^(<br>)?Where: (.*)$/)

                    if evt_when
                        event.when = entities.decodeHTML(evt_when[2])
                    if evt_where
                        event.where = entities.decodeHTML(evt_where[2])

                events.push(event)

            # Now we process the list for emitting into the channel
            finalMsg = ""
            for event in events
                finalMsg = finalMsg + "#{event.title} - #{event.description} : #{event.when} @ #{event.where}\n"
            msg.send finalMsg
            return
        return
    return


