class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    user_role
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
    user_role
  end

  # GET /admins/new
  def new
    user_role
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
    user_role
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params.merge(:users_id => current_user.id))

    respond_to do |format|
      if @admin.save
        format.html { redirect_to admin_url(@admin), notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admin_url(@admin), notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Method to display the role uf the current user on the screen
  def user_role
    if current_user
      if current_user.admin?
        @view_role = :Admin
      elsif current_user.instructor?
        @view_role = :Instructor
      else
        current_user.student?
        @view_role = :Student
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:name, :phone_number)
    end
end
