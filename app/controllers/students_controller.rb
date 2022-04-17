class StudentsController < ApplicationController
  before_action :set_student, :validates_user, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    user_role

    # Fetch all the students
    @students = Student.all

    # Admin - can view all the students
    if current_user.admin?
      @enrollments = Enrollment.where(courses_id: params['course_id'].to_i)
                               .where(status: params['enrollment_status']).all
      @current_student = Student.where(id: @enrollments.map {|s| s.students_id})

      if @current_student.size == 0 and params['course_id'].nil?
        @current_student = @students
      end

      @current_course = Course.find_by id: params['course_id']
    end

    # Fetch the current student to show on the the student's home page
    if current_user.student?
      @current_student = Student.where(users_id: current_user.id).all
    end

    if current_user.instructor?
      @current_course = Course.find_by id: params['course_id']
      @enrollments = Enrollment.where(courses_id: params['course_id'].to_i)
                             .where(status: params['enrollment_status']).all
      @current_student = Student.where(id: @enrollments.map {|s| s.students_id})
    end
  end

  # GET /students/1 or /students/1.json
  def show
    user_role
  end

  # GET /students/new
  def new
    user_role
    @student = Student.new
    @registration_required = true
  end

  # GET /students/1/edit
  def edit
    user_role
    @run_update = true
  end

  # POST /students or /students.json
  def create
    if current_user.student?
      @student = Student.new(student_params.merge(:users_id => current_user.id))

    elsif current_user.admin?
      email = student_params[:email]
      password = student_params[:password]
      @user = User.new(:email => email, :password => password, :password_confirmation => password, :role => 0)
      @user.save
      @new_user = User.find_by email: email
      @student = Student.new(:name => student_params[:name],
                             :date_of_birth => student_params[:date_of_birth],
                             :phone_number => student_params[:phone_number],
                             :major => student_params[:major],
                             :users_id => @new_user.id)
    end

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    if current_user.admin?
      users_id = @student.users_id
    end

    @enrollments = Enrollment.where(students_id: @student.id).all
    @enrollments.each { |enrollment| destroy_enrollment(enrollment) } unless @enrollments.nil?

    @student.destroy

    if current_user.admin?
      @delete_user = User.find_by id: users_id
      @delete_user.destroy
    end

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_enrollment(enrollment)
    course_id = enrollment.courses_id
    student_id = enrollment.students_id

    enrollment.destroy

    @course = Course.find_by id: course_id
    max_cap = Course.find_by(id: course_id).avaialable_waitlist_capacity
    max_waitlist_cap = Course.find_by(id: course_id).waitlist_capacity
    avl_waitlist_cap = Course.find_by(id: course_id).avaialable_waitlist_capacity
    avl_cap = Course.find_by(id: course_id).available_capacity

    if enrollment.status == "Enrolled"
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
    elsif enrollment.status == "Waitlist"
      Course.where(:id => course_id).update(:avaialable_waitlist_capacity => avl_waitlist_cap + 1)
      modifyCourseStatus course_id
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
  def set_student
    @student = Student.find(params[:id])
  end

  # Prevent students from visiting others profile by changing the url
  def validates_user
    if !current_user.admin? and Student.find_by(users_id: current_user.id).id.to_s != params[:id]
      redirect_to root_path
    end
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:name, :date_of_birth, :phone_number, :major, :email, :password)
  end
end
