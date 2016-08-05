// ...
//= require ./booking/moment.min.js
//= require ./booking/fullcalendar.min.js
//= require ./booking/gcal.js
//= require_self
$(document).ready(function () {
    var startTime = null, endTime = null;
    var $payBtn = $("#pay");
    var $payBtns = $("#pay,#superuser_book");
    var $calendar = $("#calendar");
    $calendar.fullCalendar({
        googleCalendarApiKey: 'AIzaSyARPG8GaKq6eJ7I6nu-oLV6IurQSu6K-js',
        events: {
            googleCalendarId: $calendar.data('calendar-id')
        },
        defaultView: 'agendaWeek',
        selectable: true,
        unselectAuto: false,
        selectOverlap: false,
        selectHelper: true,
        editable: false,
        eventLimit: true,
        minTime: "08:00:00",
        maxTime: "20:00:00",
        height: "auto",
        scrollTime: "00:00:00",
        selectConstraint: {
            start: '00:01',
            end: '23:59'
        },
        viewRender: function (view, element) {
            view.timeGrid.computeSelection = function (span0, span1) {
                var span = this.computeSelectionSpan(span0, span1);
                if (span && (!this.view.calendar.isSelectionSpanAllowed(span) || span.end - span.start > 10800000
                    || span.start.clone().toDate() < new Date(moment(new Date()).format('YYYY-MM-DDTHH:mm')))) {
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
            $("#timeFrom").val(start.format("HH:mm"));
            $("#timeTo").val(end.format("HH:mm"));
            $("#date").val(start.format("YYYY-MM-DD"));
            startTime = start;
            endTime = end;
            var duration = (endTime - startTime) / (60 * 60 * 1000);
            if (remainingFreeTime - duration > 0) {
                $payBtn.html("Book");
            } else {
                $payBtn.html("Pay");
            }
            $payBtns.attr('disabled', $("#title").val() ? false : true);
        },
        unselect: function (view, jsEvent) {
            startTime = null;
            endTime = null;
            $payBtns.attr('disabled', true);
        },
        allDaySlot: false,
        header: {left: 'agendaWeek,month', center: 'title', right: 'prev,next'}
    });

    var handler = StripeCheckout.configure({
        key: stripeKey,
        image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
        locale: 'auto',
        token: function (token) {
            $("#stripeToken").val(token.id);
            $("#stripeEmail").val(token.email);
            submitForm();
        }
    });
    $('#title').change(function () {
        if (this.value) {
            $payBtns.attr('disabled', startTime ? false : true);
        } else {
            $payBtns.attr('disabled', true);
        }
    });

    function submitForm() {
        var $form = $("#form");
        $payBtn.text("Processing...")
        $.post({
            url: $form.attr('action'),
            data: $form.serialize(),
            dataType: 'json'
        }).done(function (data) {
            if (data.error) {
                alert(data.error);
            } else {
                window.location.href = "/booking/" + data.id + "/confirmation";
            }
        }).error(function (data) {
            alert("An error occurred. Your card has not been charged.");
            console.log(data);
        }).always(function () {
            $payBtns.attr('disabled', false);
            $payBtn.text('Pay')
        });
    }

    $("#superuser_book").on('click', function (e) {
        e.preventDefault();
        $("#superuser").val('true');
        submitForm();
    });

    $payBtn.on('click', function (e) {
        e.preventDefault();
        $payBtns.attr('disabled', true);
        var duration = ((endTime - startTime) / (60 * 60 * 1000)) - remainingFreeTime;
        if (duration < 0) {
            submitForm();
            return;
        }
        handler.open({
            name: 'Bloom room booking',
            description: 'Booking the ' + window.roomName,
            currency: 'AUD',
            label: 'Pay',
            email: window.previousEmail,
            amount: duration * window.roomPricing
        });
    });

    $(window).on('popstate', function () {
        handler.close();
    });
});