// ...
//= require ./booking/moment.min.js
//= require ./booking/fullcalendar.min.js
//= require_self
$(document).ready(function () {
    var calendar = $('#calendar');
    calendar.fullCalendar({
        googleCalendarApiKey: 'AIzaSyARPG8GaKq6eJ7I6nu-oLV6IurQSu6K-js',
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
            calendar.fullCalendar('renderEvent',
                {
                    title: 'Available interview time',
                    start: start,
                    end: end
                }, true
            );
            calendar.fullCalendar('unselect');
        },
        allDaySlot: false,
        header: {left: '', center: '', right: ''}
    });
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

    var parseTime = function (inp) {
        var colon = inp.indexOf(':');
        var hour = parseInt(inp.substring(0, colon));
        var minute = parseInt(inp.substring(colon + 1, inp.length));
        return [hour, minute];
    };
    var adjustMomentToTime = function (inp, moment) {
        var time = parseTime(inp);
        return moment.hour(time[0]).minute(time[1]);
    };
    for (var i = 0; i < window.current_availability.length; i++) {
        var curr = window.current_availability[i];
        var start = adjustMomentToTime(curr.startTime, moment(new Date()));
        var end = adjustMomentToTime(curr.endTime, start.clone());
        calendar.fullCalendar('renderEvent', {
            start: start,
            end: end,
            title: 'Available interview time'
        }, true);
    }
});