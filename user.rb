require_relative 'questions_database'

class User < Table
  TABLE_NAME = 'users'

  def initialize(data)
    @id = data["id"]
    @fname = data["fname"]
    @lname = data["lname"]
  end

  def self.find_by_id(id)
    User.new(super(id))
  end

  def self.find_by_name(fname, lname)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, fname, lname).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(data)
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

end
