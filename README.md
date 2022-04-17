# Student-Enrollment-System


This is the repository for the Project 2 for the subject CSC 517: Object Oriented Design and Development for Spring 22 semester. Project aims at creating a student enrollment application using Ruby on Rails, similar to the existing system in MyPack.

This README will document whatever steps are necessary to get the
application up and running.

Ruby version : 3.0.3

Rails version : 7.0.1

Application link : https://wolf-register-prod.herokuapp.com/


## Installation Instructions

### Install Ruby and Rails
  - [Installation Instructions](https://guides.rubyonrails.org/v5.1/getting_started.html)

### Postgres setup

execute the following commands to install dev environment for MacOS
```
brew install ruby
brew install sqlite
```

### Setup App

From the project root directory execute the following commands

```
bundle
rails db:migrate
rails db:seed 
```

### Run App

Run 'rails s' to start the app, then you can access the app under: http://localhost:3000

## Deployment Instructions

  - Resere a VCL VM 
  - Set it up: https://docs.google.com/document/d/10i91a8B6D7s5py7VwgE2UDxRIcJSdQKkt1h5g2m3YsA/edit
  - git clone git@github.ncsu.edu:dvnguye3/csc517-program2-eagle.git
  - From the project root directory run the following commands
    ```
    bundle
    rails db:migrate
    rails db:seed
    rails s -p 8080 -b 152.7.98.99 &
    ```

## Team Members

  - Rachel Hyo Son
  - Duy Nguyen
  - Leo Hsiang

Main page :
- Sign Up as instructor/student
- Login as instructor/student/admin
            
After Sign Up : Make sure you register with all the personal details before you can access other pages

Admin credentials :
email id - admin1@ncsu.edu
password - admin1

Course Status : OPEN, WAITLIST, CLOSED

Waitlist position : Available waitlist seats left while joining waitlist for a course
Eg - The capacity for a course is filled and the waitlist capacity is 5, if you're the first one to join the list then your waitlist position will be 5 and the next person to join the waitlist will have the waitlist position 4

Admin : 
- To view/edit admin profile go to Edit Profile
- Admin can create/read/update/delete students/instructors/courses
- Admin can enroll/unenroll students
- To create/view/edit/destroy a Student go to Students page
- To create/view/edit/destroy an Instructor go to Instructor page
- To create/view/edit/destroy a Course under an instructor go to Courses page
- To enroll a Student in a Course go to the Courses page and click on Enroll Students 
- To view students Enrolled in a course go to Courses page and click on Enrolled students
- To view students Waitlisted in a course go to Courses page and click on Waitlist students
- To unenroll a Student/drop from waitlist from a Course go to Students page and click on View Enrollments and delete the Enrollment
- To Sign Out go to WolfRegisterHome and then Sign Out

Students : 
- To view/edit Student profile go to Students page and click Show
- To view all the Courses go to the Course Page
- To enroll in a Course/join the waitlist go to Course Page click Enroll and then Create Enrollment and the student will be enrolled/added to waitlist depending on course status
- To unenroll/drop from waitlist from a Course go to Students page and click on View Enrollments and delete the Enrollment 
- To Sign Out go to WolfRegisterHome and then Sign Out

Instructors : 
- To view/edit Instructor profile go to Instructors page and click Show/Edit
- To view all the Courses under that Instructor go to the Course Page
- To create/view/edit/destroy a Course under that Instructor go to Courses page
- To view students Enrolled in the Courses under that Instructor go to Courses page and click on Enrolled students associated with each Course
- To view students Waitlisted in the Courses under that Instructor go to Courses page and click on Waitlist students associated with each Course
- To enroll a Student in a Course under that Instructor go to the Courses page and click on Enroll Students associated with each Course
- To unenroll a Student from a Course under that Instructor go to Courses page and click on Enrolled Students then click View Enrollments and delete the Enrollment
- To drop a Student from Waitlist of a Course go to Courses page and click on Waitlist Students then click View Enrollments and delete the Enrollment
- To Sign Out go to WolfRegisterHome and then Sign Out

Testing Code is available in the rspec_branch. Kindly look for it there. It is exact replica of the main branch with the rspec test cases. Checkout to this branch and test.
For Running the test cases, just just run rspec after setting your environemnt variable to test environemnt.