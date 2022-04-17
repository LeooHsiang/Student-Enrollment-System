class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    user_role

    @enrollments = Enrollment.all
    @courses = Course.all
    @students = Student.all
    @instructor = Instructor.find_by users_id: current_user.id
    @student = Student.find_by id: params['student_id']
    @current_course = Course.find_by id: params['course_id']

    # When student tries to enroll in a course
    if current_user.student?
      @current_course = Course.where(id: params['course_id']).all
      @courses = @current_course
      @student = Student.find_by users_id: current_user.id
    end

    if current_user.admin?
      if params['course_id'].nil?
        @current_enrollment = Enrollment.where(students_id: params['student_id']).all
      else
        @current_course = Course.where(id: params['course_id']).all
        @current_enrollment = Enrollment.where(courses_id: params['course_id'], students_id: params['student_id']).all
      end
    end

  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    user_role
  end

  # GET /enrollments/new
  def new
    user_role

    @enrollment = Enrollment.new
    @courses = Course.all
    @instructor = Instructor.find_by users_id: current_user.id
    @student = Student.find_by users_id: current_user.id
    @students = Student.all
  end

  # GET /enrollments/1/edit
  def edit
    user_role
  end

  # POST /enrollments or /enrollments.json
  def create
    # check current user is admin or instructor or student

    # Case 1: student
    # fetch student id from current user
    @enrollment = Enrollment.new(enrollment_params)

    # Checking the status of the course as OPEN or WAITLIST
    @course = Course.find_by id: enrollment_params["courses_id"]
    course_id = @course.id

    if current_user.instructor? || current_user.admin?
      @student = Student.find_by id: params['student_id']
    end

    if @course.available_capacity > 0
      @enrollment.status = "Enrolled"
    elsif @course.waitlist_capacity > 0
      @enrollment.status = "Waitlist"
      @enrollment.waitlist_position = @course.waitlist_capacity
    end

    respond_to do |format|

        # Check if the course is open or not
        if @course.statuses_id == Status.find_by_status_name("CLOSED").id
          format.html { redirect_to new_enrollment_path, notice: "The course is closed, You cannot register!" }

       # Check if the enrollment already exists
        elsif @existing_enrollment = Enrollment.where(students_id: @student.id, courses_id: course_id).all.length > 0
         format.html { redirect_to new_enrollment_path, notice: "Enrollment already exists, Please select some other course" }

      elsif @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }

        @course = Course.find_by id: course_id
        if @enrollment.status == "Enrolled"
          Course.where(:id => course_id).update(:available_capacity => @course.available_capacity - 1)
          modifyCourseStatus course_id
        elsif @enrollment.status == "Waitlist"
          Course.where(:id => @course.id).update(:avaialable_waitlist_capacity => @course.avaialable_waitlist_capacity - 1)
          modifyCourseStatus course_id
        end

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    course_id = @enrollment.courses_id
    student_id = @enrollment.students_id

    @enrollment.destroy

    @course = Course.find_by id: course_id
    max_cap = Course.find_by(id: course_id).avaialable_waitlist_capacity
    max_waitlist_cap = Course.find_by(id: course_id).waitlist_capacity
    avl_waitlist_cap = Course.find_by(id: course_id).avaialable_waitlist_capacity
    avl_cap = Course.find_by(id: course_id).available_capacity

    if @enrollment.status == "Enrolled"
      if max_waitlist_cap == avl_waitlist_cap #means no one is waitlisted
        Course.where(:id => course_id).update(:available_capacity => avl_cap + 1)
      elsif max_waitlist_cap > avl_waitlist_cap
        # get student_id of the student with highest waitlist number
        @waitlisted_student_enrollment = Enrollment.where(:courses_id => course_id).order('waitlist_position DESC').limit(1)
        waitlisted_student_id = @waitlisted_student_enrollment.map { |record| record.students_id }.first()

        # enroll that student
        Enrollment.where(:courses_id => course_id).where(:students_id => waitlisted_student_id).update(:status => "Enrolled")
        Enrollment.where(:courses_id => course_id).where(:students_id => waitlisted_student_id).update(:waitlist_position => nil)

        Course.where(:id => course_id).update(:avaialable_waitlist_capacity => avl_waitlist_cap + 1)
      end

      modifyCourseStatus course_id
    elsif @enrollment.status == "Waitlist"
      Course.where(:id => course_id).update(:avaialable_waitlist_capacity => avl_waitlist_cap + 1)
      modifyCourseStatus course_id
    end

    @student = Student.find_by id: student_id

    respond_to do |format|
      format.html { redirect_to enrollments_url(:student_id => student_id, :course_id => course_id), notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def modifyCourseStatus(course_id)
    @course = Course.find_by id: course_id
    if(@course.available_capacity == 0 && @course.avaialable_waitlist_capacity == 0)
      @status = Status.find_by status_name: "CLOSED"
      Course.where(:id => course_id).update(:statuses_id => @status.id)
    elsif(@course.available_capacity == 0 && @course.avaialable_waitlist_capacity > 0)
      @status = Status.find_by status_name: "WAITLIST"
      Course.where(:id => course_id).update(:statuses_id => @status.id)
    else(@course.available_capacity > 0)
      @status = Status.find_by status_name: "OPEN"
      Course.where(:id => course_id).update(:statuses_id => @status.id)
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
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      @student = Student.find_by users_id: current_user.id
      params["student_id"] = @student.id if current_user.student?
      params.require(:enrollment).permit(:status, :waitlist_position).merge(courses_id: params["course_id"]).merge(students_id: params["student_id"])
    end
end
