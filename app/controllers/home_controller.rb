class HomeController < ApplicationController
  def index
    if current_user
      if current_user.admin?
        @view_role = :Admin
        @user = Admin.where(users_id: current_user.id).all
      elsif current_user.instructor?
        @view_role = :Instructor
        @user = Instructor.where(users_id: current_user.id).all
      else current_user.student?
        @view_role = :Student
      @user = Student.where(users_id: current_user.id).all
      end

      if @user.size == 0
        @registration_required = true
      else
        @registration_required = false
      end

    end
  end
end