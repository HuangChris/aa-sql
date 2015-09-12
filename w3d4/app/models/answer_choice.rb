# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer          not null
#  answer_text :text             not null
#

class AnswerChoice < ActiveRecord::Base
  validates :question_id, :answer_text, presence: true

  belongs_to :question,
    class_name: :Question,
    primary_key: :id,
    foreign_key: :question_id

  has_many :responses,
    class_name: :Response,
    primary_key: :id,
    foreign_key: :choice_id

end
