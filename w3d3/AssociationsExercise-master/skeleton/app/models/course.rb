# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  prereq_id     :integer
#  instructor_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Course < ActiveRecord::Base
  has_many(
    :enrollments,
    class_name: :Enrollment,
    foreign_key: :course_id,
    primary_key: :id
  )

  has_many :enrolled_students,
    # class_name: :User,
    through: :enrollments,
    source: :enrolled_student

  # belongs: foreign key lives in this/current row/record, points to another record
  # has: foreign key lives in another record, points to the current record

  belongs_to :prerequisites,
    class_name: :Course,
    foreign_key: :prereq_id,
    primary_key: :id

  belongs_to :instructor,
    class_name: :User,
    foreign_key: :instructor_id,
    primary_key: :id
end
