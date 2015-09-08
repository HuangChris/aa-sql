require_relative 'questions_database'

class Question < Table
  TABLE_NAME = 'questions'

  def initialize(data)
    @id = data["id"]
    @title = data["title"]
    @user_id = data["user_id"]
    @body = data["body"]
  end

  def self.find_by_id(id)
    Question.new(super(id))
  end

  def self.find_by_title(title)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, title).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        title = ?
    SQL

    Question.new(data)
  end

  def self.find_by_user_id(user_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, user_id).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        user_id = ?
    SQL

    Question.new(data)
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_user_id(@user_id)
  end

  def followers
    QuestionFollow.find_by_question_id(@id)
  end
end
