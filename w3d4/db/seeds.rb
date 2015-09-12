# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

chris = User.create!(user_name: "Chris")
leah = User.create!(user_name: "Leah")
poll = Poll.create!(title: "What's for lunch", author_id: chris.id)
question = Question.create!(poll_id: poll.id, question_text: "What's for lunch?")
answer_choice_1 = AnswerChoice.create!(question_id: question.id, answer_text: "subway")
answer_choice_2 = AnswerChoice.create!(question_id: question.id, answer_text: "chinese")
response = Response.create!(user_id: leah.id, choice_id: answer_choice_1.id)
