require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Avaialable waitlist capacity", with: @course.avaialable_waitlist_capacity
    fill_in "Available capacity", with: @course.available_capacity
    fill_in "Capacity", with: @course.capacity
    fill_in "Code", with: @course.code
    fill_in "Description", with: @course.description
    fill_in "End time", with: @course.end_time
    fill_in "Name", with: @course.name
    fill_in "Room", with: @course.room
    fill_in "Start time", with: @course.start_time
    fill_in "Waitlist capacity", with: @course.waitlist_capacity
    fill_in "Weekday one", with: @course.weekday_one
    fill_in "Weekday two", with: @course.weekday_two
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Avaialable waitlist capacity", with: @course.avaialable_waitlist_capacity
    fill_in "Available capacity", with: @course.available_capacity
    fill_in "Capacity", with: @course.capacity
    fill_in "Code", with: @course.code
    fill_in "Description", with: @course.description
    fill_in "End time", with: @course.end_time
    fill_in "Name", with: @course.name
    fill_in "Room", with: @course.room
    fill_in "Start time", with: @course.start_time
    fill_in "Waitlist capacity", with: @course.waitlist_capacity
    fill_in "Weekday one", with: @course.weekday_one
    fill_in "Weekday two", with: @course.weekday_two
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    click_on "Destroy this course", match: :first

    assert_text "Course was successfully destroyed"
  end
end
