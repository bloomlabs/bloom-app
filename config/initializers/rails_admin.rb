module RailsAdmin
  module Config
    module Actions
      # common config for custom actions
      class WorkflowAction < RailsAdmin::Config::Actions::Base
        register_instance_option :member do
          true
        end
        register_instance_option :only do
          MembershipRequest
        end
        register_instance_option :visible? do
          authorized? && bindings[:object].class == MembershipRequest && bindings[:object].current_state == :pending_decision
        end
        register_instance_option :controller do
          object = bindings[:object]
        end
      end
      class Accept < WorkflowAction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :link_icon do
          'fa fa-thumbs-up'
        end
        register_instance_option :controller do
          Proc.new do
            object.accept!
            flash[:notice] = 'Application accepted'
            redirect_to show_path
          end
        end
      end
      class Reject < WorkflowAction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :link_icon do
          'fa fa-thumbs-down'
        end
        register_instance_option :controller do
          Proc.new do
            object.reject!
            flash[:notice] = 'Application rejected'
            redirect_to show_path
          end
        end
      end
    end
  end
end

RailsAdmin.config do |config|

  config.compact_show_view = false

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan, AdminAbility

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    history_index
    history_show

    accept
    reject
  end
end

