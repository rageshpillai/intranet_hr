# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :leave_application do |l|
    start_at Date.today + 2
    end_at Date.today + 3
    number_of_days 2
    reason "Sick"
    contact_number "1234567890"
  end
  factory :casual_leave_application, class: LeaveApplication do |l|
    start_at Date.today + 2
    end_at Date.today + 3
    number_of_days 2
    reason "casual leave application"
    contact_number "1234567890"
  end
  
  factory :privilege_leave_application, class: LeaveApplication do |l|
    start_at Date.today + 2
    end_at Date.today + 3
    number_of_days 2
    reason "privilege leave application"
    contact_number "1234567890"
  end
end
