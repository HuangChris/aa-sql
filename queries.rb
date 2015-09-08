require_relative 'questions_database'
require_relative 'user'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow_like'

p Question.find_by_user_id(1)
p User.find_by_id(1)
p Reply.find_by_question_id(1)
p Reply.find_by_user_id(1)
p QuestionFollow.most_followed_questions(1)
p QuestionFollow.most_followed_questions(3)
