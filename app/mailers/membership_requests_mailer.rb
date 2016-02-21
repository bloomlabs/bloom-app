class MembershipRequestsMailer < ApplicationMailer

  def interview_booked(user)
    @user = user
    mail(to: @user.email, subject: 'Membership Interview Booked!')
  end
end
