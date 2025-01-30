class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :check_user_approval, if: :user_signed_in?

    def after_confirmation_path_for(resource_name, resource)
      pending_approval_path
    end

    def after_sign_in_path_for(resource)
        root_path
    end

    def check_user_approval
      return if request.path == destroy_user_session_path
    
      return if request.path.start_with?('/pending_approval')
  
      if current_user.pending?
        redirect_to pending_approval_path
      end
    end
end
