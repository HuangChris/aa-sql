require_relative 'questions_database'
require_relative 'user'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow_like'

# p Question.find_by_user_id(1)
# p User.find_by_id(1)
# p Reply.find_by_question_id(1)
# p Reply.find_by_user_id(1)
# p QuestionFollow.most_followed_questions(1)
# p QuestionFollow.most_followed_questions(3)
# p QuestionLike.likers_for_question_id(1)
# p QuestionLike.num_likes_for_question_id(1)
# p QuestionLike.liked_questions_for_user_id(2)
# p QuestionLike.most_liked_questions(2)
# p a = User.find_by_id(1)
# p a.average_karma

a = User.new({"id" => nil, "fname" => "first_name","lname" => "last_name"})
a.save
p a.id
puts "save1 inserted properly"

a.fname = "Not_first_name"
p a
a.save

p a.id

# p Question.where("title LIKE '%Test%' AND id = 1")
# p Question.find_by_title_and_user_id("Test Question", 1)
# p Question.where({"title" => "Test Question", "user_id" => 1})
