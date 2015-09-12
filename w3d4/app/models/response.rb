# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          not null
#  choice_id  :integer          not null
#

class Response < ActiveRecord::Base
  validates :user_id, :choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :user_cant_answer_own_question

  belongs_to :answer_choice,
    class_name: :AnswerChoice,
    primary_key: :id,
    foreign_key: :choice_id

  belongs_to :respondent,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id

  has_one :question,
    through: :answer_choice,
    source: :question

  has_one :poll,
    through: :question,
    source: :poll




  def sibling_responses
    return question.responses if id.nil?
    question.responses.where("responses.id <> ?", self.id)
  end

  private
  def respondent_has_not_already_answered_question
    if self.sibling_responses.any? do |response|
      response.user_id == self.user_id
      end

      errors[:user_id] << "Can't answer a question twice"
    end
  end

  def user_cant_answer_own_question
    if self.poll.author_id == self.user_id
      errors[:user_id] << "Can't answer your own question"
    end
  end

end
