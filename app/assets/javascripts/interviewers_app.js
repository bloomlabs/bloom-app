// ...
//= require ./booking/moment.min.js
//= require ./booking/fullcalendar.min.js
//= require_self
$(document).ready(function () {
    var calendar = $('#calendar');
    calendar.fullCalendar({
        events: {},
        defaultView: 'agendaWeek',
        selectable: true,
        unselectAuto: false,
        selectOverlap: false,
        eventStartEditable: true,
        eventOverlap: false,
        selectHelper: true,
        editable: true,
        minTime: "08:00:00",
        maxTime: "20:00:00",
        scrollTime: "00:00:00",
        eventConstraint: {
            start: '00:01',
            end: '23:59'
        },
        selectConstraint: {
            start: '00:01',
            end: '23:59'
        },
        eventClick: function (event) {
            calendar.fullCalendar('removeEvents', event._id);
            return false;
        },
        eventSources: [function (start, end, tz, callback) {
            var evs = [];
            for (var i = 0; i < window.current_availability.length; i++) {
                var avail = window.current_availability[i];
                evs.push({
                    title: 'Available interview time',
                    start: setMomentDateAndTime(avail.day, avail.startTime),
                    end: setMomentDateAndTime(avail.day, avail.endTime)
                });
            }
            callback(evs);
        }],
        viewRender: function (view, element) {
            view.timeGrid.computeSelection = function (span0, span1) {
                var span = this.computeSelectionSpan(span0, span1);
                if (span && (!this.view.calendar.isSelectionSpanAllowed(span) || span.start.dayOfYear() != span.end.dayOfYear())) {
                    return false;
                }
                return span;
            };
            $(".fc-button").hover(function () {
                $(this).removeClass('fc-state-default')
            }, function () {
                $(this).addClass('fc-state-default');
            });
        },
        select: function (start, end, jsEvent, view) {
            window.s = start;
            calendar.fullCalendar('renderEvent',
                {
                    title: 'Available interview time',
                    start: start,
                    end: end
                }, true);
            calendar.fullCalendar('unselect');
        },
        allDaySlot: false,
        header: {left: '', center: '', right: ''}
    });

    function parseHourMinute(raw) {
        var colon = raw.indexOf(':');
        return [parseInt(raw.substring(0, colon)), parseInt(raw.substring(colon + 1, raw.length))];
    }

    function setMomentDateAndTime(day, raw) {
        var today = moment(new Date());
        var tm = parseHourMinute(raw);
        return today.day(day).hour(tm[0]).minute(tm[1]);
    }

    $("#save").click(function () {
        var events = calendar.fullCalendar('clientEvents');
        var data = [];
        for (var i = 0; i < events.length; i++) {
            var event = events[i];
            data.push({
                day: event.start.day(),
                startTime: event.start.format("HH:mm"),
                endTime: event.end.format("HH:mm")
            });
        }
        $("#availability").val(JSON.stringify(data));
    });
});