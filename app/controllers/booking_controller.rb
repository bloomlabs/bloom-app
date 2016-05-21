class BookingController < ApplicationController
  def new
    Booking.new()
  end
end
