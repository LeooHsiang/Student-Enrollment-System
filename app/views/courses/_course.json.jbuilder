json.extract! course, :id, :name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :code, :capacity, :available_capacity, :waitlist_capacity, :avaialable_waitlist_capacity, :room, :created_at, :updated_at
json.url course_url(course, format: :json)
