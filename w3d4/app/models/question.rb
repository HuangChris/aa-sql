# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  created_at    :datetime
#  updated_at    :datetime
#  poll_id       :integer          not null
#  question_text :text             not null
#

class Question < ActiveRecord::Base
  validates :poll_id, :question_text, presence: true

  has_many :answer_choices,
    class_name: :AnswerChoice,
    primary_key: :id,
    foreign_key: :question_id

  belongs_to :poll,
    class_name: :Poll,
    primary_key: :id,
    foreign_key: :poll_id

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    answer_hash = {}
    answers = self.answer_choices.includes(:responses)
    answers.each do |choice|
      answer_hash[choice.answer_text] = choice.responses.count
    end
    answer_hash.max_by {|k,v| v}
  end
end
