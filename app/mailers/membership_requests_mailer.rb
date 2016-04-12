class MembershipRequestsMailer < ApplicationMailer

  def new_membership_request(request)
    @request = request

    mail(
        to: @request.membership_type.status_email,
        subject: "New Membership Application: #{@request.user.firstname} #{@request.user.lastname}"
    ).deliver!
  end

  def cancelled_membership(request)
    @request = request

    mail(
        to: @request.membership_type.status_email,
        subject: "Cancelled #{@request.membership_type.name} membership: #{@request.user.firstname} #{@request.user.lastname}"
    ).deliver!
  end

  def request_accepted(request)
    @request = request

    mail(
        to: "#{@request.user.firstname} #{request.user.lastname} <#{@request.user.email}>",
        bcc: @request.membership_type.status_email,
        subject: "[Important] Bloom Membership Application"
    ).deliver!
  end

  def request_rejected(request)
    @request = request

    mail(
        to: "#{@request.user.firstname} #{request.user.lastname} <#{@request.user.email}>",
        bcc: @request.membership_type.status_email,
        subject: "[Important] Bloom Membership Application"
    ).deliver!
  end

  def coworking_confirmation(request)
    @request = request

    mail(
        to: "#{@request.user.firstname} #{request.user.lastname} <#{@request.user.email}>",
        bcc: @request.membership_type.success_email,
        subject: "[Important] Bloom Membership Confirmation"
    ).deliver!
  end
end
