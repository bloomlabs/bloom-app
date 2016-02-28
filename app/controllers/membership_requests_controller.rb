class MembershipRequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_membership_request, only: [:show, :edit, :update, :destroy]
  before_action :workflow_redirect
  before_action :authenticate_user!

  # GET /membership_requests
  # GET /membership_requests.json
  def index
    if current_user.staff?
      @membership_requests = MembershipRequest.all
    else
      @membership_requests = MembershipRequest.where(user_id: current_user.id)
    end

  end

  # GET /membership_requests/1
  # GET /membership_requests/1.json
  def show
    # We redirect the person to the current step in their workflow
    redirect_to url_for(controller: 'membership_requests',
                        action: "workflow_#{@membership_request.workflow_state}",
                        id: @membership_request.id)
  end

  # GET /membership_requests/new
  def new
    @membership_request = MembershipRequest.new
  end

  # GET /membership_requests/1/edit
  def edit
  end

  # POST /membership_requests
  # POST /membership_requests.json
  def create
    @membership_request = current_user.membership_requests.build(membership_request_params)

    #TODO
    #Check the fields of the form to make sure they are legit by placing rules in the model

    respond_to do |format|
      if @membership_request.save
        format.html { redirect_to membership_request_path(@membership_request.id), notice: 'Membership request was successfully submitted.' }
        # Email bloom admin - or account notification or something...
        format.json { render :show, status: :created, location: @membership_request }
      else
        format.html { render :new }
        format.json { render json: @membership_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /membership_requests/1
  # PATCH/PUT /membership_requests/1.json
  def update
    respond_to do |format|
      if @membership_request.update(membership_request_params)
        format.html { redirect_to @membership_request, notice: 'Membership request was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership_request }
      else
        format.html { render :edit }
        format.json { render json: @membership_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /membership_requests/1
  # DELETE /membership_requests/1.json
  def destroy
    @membership_request.cancel!
    respond_to do |format|
      format.html { redirect_to dashboard_user_path(@membership_request.user), notice: 'Membership request was successfully cancelled' }
      format.json { head :no_content }
    end
  end

  # Workflow views

  def workflow_new
    if request.post?
      @membership_request.info = params[:info]
      if !params[:info].chomp
        @bad_startup_info = true
      else
        @membership_request.save!
        @membership_request.submit!
        redirect_to membership_request_path(@membership_request)
      end
    end
  end

  def workflow_book_interview
    if request.post?
      @membership_request.interview_book_info = params[:interview_book_info]
      @membership_request.save!

      @membership_request.book!
      redirect_to membership_request_path(@membership_request)
    end
  end

  def workflow_pending_decision

  end

  def workflow_payment_required
    @membership_type = @membership_request.membership_type
  end

  def workflow_active_membership

  end

  def workflow_rejected

  end

  def workflow_cancelled

  end

  def workflow_expired

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_membership_request
    @membership_request = MembershipRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_request_params
    params.require(:membership_request).permit(:membership_type_id, :startdate)
  end

  # Make sure user can only go to the stage of the workflow that they're on
  def workflow_redirect
    if action_name.starts_with?('workflow_')
      state = @membership_request.workflow_state

      if action_name != 'workflow_' + state
        redirect_to url_for(controller: 'membership_requests',
                            action: "workflow_#{@membership_request.workflow_state}",
                            id: @membership_request.id)
      end
    end
  end
end
