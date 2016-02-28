class MembershipRequestsMailer < ApplicationMailer

  def interview_booked(user)
    @user = user

    mail(
        to: @user.email,
        subject: 'Membership Interview Booked!'
    ).deliver!
  end

  def new_membership_application(request)
    @request = request

    mail(
        to: 'memberships@bloom.org.au',
        subject: "New Membership Application: #{@request.user.firstname} #{@request.user.lastname}"
    ).deliver!
  end
end
