class Admin::MembershipRequestsController < AdminController
  before_action :set_membership_request, only: [:show, :update]

  def index
    @membership_requests_pending = MembershipRequest.where(workflow_state: 'pending_decision')
    @membership_requests_active = MembershipRequest.where(workflow_state: 'active_membership')
    @membership_requests_closed = MembershipRequest.where(closed: true)
    @membership_types = MembershipType.all
  end

  def show
  end

  def reset_community_members
    c = 0
    MembershipRequest.where(membership_type: MembershipType.find_by!(name: 'Community Member'), workflow_state: 'active_membership').find_each do |e|
      e.expire!
      c += 1
    end
    flash[:info] = "Expired #{c} community members."
    redirect_to action: 'index'
  end

  def update
    if @membership_request.current_state != :pending_decision
      render json: nil, status: 500
      return
    end

    decision = params[:decision]

    case decision
      when 'accept'
        flash[:info] = 'Request accepted'
        @membership_request.accept!
      when 'reject'
        flash[:info] = 'Request rejected'
        @membership_request.reject!
      else
        render json: nil, status: 500
        return
    end

    redirect_to admin_membership_requests_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_membership_request
    @membership_request = MembershipRequest.find(params[:id])
  end
end
