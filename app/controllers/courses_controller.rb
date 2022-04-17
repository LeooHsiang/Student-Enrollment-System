class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    user_role
    @courses = Course.all
    @instructor = Instructor.find_by users_id: current_user.id
    @instructors = Instructor.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    user_role
  end

  # GET /courses/new
  def new
    user_role
    @course = Course.new
    @instructors = Instructor.all
  end

  # GET /courses/1/edit
  def edit
    user_role
    @instructors = Instructor.all
  end

  # POST /courses or /courses.json
  def create
    @status = Status.find_by status_name: 'OPEN'
    @instructors = Instructor.all

    if current_user.admin?
      @course = Course.new(course_params.merge(:instructors_id => params['instructors_id'],
                                               :statuses_id => @status.id,
                                               :available_capacity => course_params['capacity'],
                                               :avaialable_waitlist_capacity => course_params['waitlist_capacity']))
    else
      @instructor = Instructor.find_by users_id: current_user.id
      @course = Course.new(course_params.merge(:instructors_id => @instructor.id,
                                               :statuses_id => @status.id,
                                               :available_capacity => course_params['capacity'],
                                               :avaialable_waitlist_capacity => course_params['waitlist_capacity']))
    end

    # set instructor_id and status_id

    respond_to do |format|
      if @course.weekday_one.eql? @course.weekday_two
        format.html { redirect_to new_course_path, notice: "Weekday One and Weekday two cannot be the same" }
      elsif @course.weekday_one.eql? "NIL"
        format.html { redirect_to new_course_path, notice: "Weekday One cannot be NIL" }
      elsif @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    # Instructor removes a course
    # => first remove all enrollments, then the course

    @enrollments = Enrollment.where(courses_id: @course.id).all
    @enrollments.destroy_all unless @enrollments.nil?
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
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
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :code, :capacity, :available_capacity, :waitlist_capacity, :avaialable_waitlist_capacity, :room)
    end
end
