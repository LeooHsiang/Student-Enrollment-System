class InstructorsController < ApplicationController
  before_action :set_instructor, :validates_user, only: %i[ show edit update destroy ]

  # GET /instructors or /instructors.json
  def index
    user_role
    @instructors = Instructor.all
    if current_user.instructor?
      @current_instructor = Instructor.where(users_id: current_user.id).all
    end
    if current_user.admin?
      @current_instructor = @instructors
    end
  end

  # GET /instructors/1 or /instructors/1.json
  def show
    user_role
  end

  # GET /instructors/new
  def new
    user_role
    @instructor = Instructor.new
    @registration_required = true
  end

  # GET /instructors/1/edit
  def edit
    user_role
    @run_update = true
  end

  # POST /instructors or /instructors.json
  def create

    if current_user.instructor?
      @instructor = Instructor.new(instructor_params.merge(:users_id => current_user.id))

    elsif current_user.admin?
      email = instructor_params[:email]
      password = instructor_params[:password]
      @user = User.new(:email => email, :password => password, :password_confirmation => password, :role => 1)
      @user.save
      @new_user = User.find_by email: email
      @instructor = Instructor.new(:name => instructor_params[:name], :department => instructor_params[:department], :users_id => @new_user.id)
    end

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully created." }
        format.json { render :show, status: :created, location: @instructor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1 or /instructors/1.json
  def update
    user_role

    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully updated." }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1 or /instructors/1.json
  def destroy
    if current_user.admin?
      users_id = @instructor.users_id
    end

    @courses = Course.where(instructors_id: @instructor.id).all

    unless @courses.nil?
      @enrollments = Enrollment.where(courses_id: @courses.map {|record| record.id}).all
      @enrollments.destroy_all unless @enrollments.nil?
    end

    @courses.destroy_all unless @courses.nil?

    @instructor.destroy

    if current_user.admin?
      @delete_user = User.find_by id: users_id
      @delete_user.destroy
    end

    respond_to do |format|
      format.html { redirect_to instructors_url, notice: "Instructor was successfully destroyed." }
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
  def set_instructor
    @instructor = Instructor.find(params[:id])
  end

  # Prevent instructors from visiting others profile by changing the url
  def validates_user
    if !current_user.admin? and Instructor.find_by(users_id: current_user.id).id.to_s != params[:id]
      redirect_to root_path
    end
  end

  # Only allow a list of trusted parameters through.
  def instructor_params
    params.require(:instructor).permit(:name, :department, :email, :password)
  end
end
