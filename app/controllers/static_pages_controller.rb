class StaticPagesController < ApplicationController
    before_action :check_pending_status
  
    def pending_approval
      @user = current_user
    end
  
    private
  
    def check_pending_status
      unless current_user.pending?
        redirect_to root_path, notice: "Your account has already been approved."
      end
    end
  end