require_relative 'questions_database'

class User < Table
  attr_reader :id
  attr_accessor :fname
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

  # def save
  #   db = QuestionsDatabase.instance
  #   if @id.nil?
  #     insert
  #   else
  #     update
  #   end
  # end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    # questions = authored_questions
    # sum = questions.inject(0) do |sum, question|
    #   question.num_likes + sum
    # end
    # sum / questions.count

    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, @id).first
      SELECT
        COUNT(question_likes.id) / CAST(COUNT(DISTINCT questions.id) AS FLOAT)
      FROM
        question_likes
      LEFT OUTER JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.user_id = ?
    SQL
  end

  private
  # def insert
  #   db = QuestionsDatabase.instance
  #   db.execute(<<-SQL, @fname, @lname)
  #     INSERT INTO
  #       users(fname, lname)
  #     VALUES
  #       (?, ?)
  #   SQL
  #   @id = db.last_insert_row_id
  # end
  #
  # def update
  #   db = QuestionsDatabase.instance
  #
  #   db.execute(<<-SQL, fname: @fname, lname: @lname, id: @id)
  #     UPDATE
  #       users
  #     SET
  #       fname = :fname,
  #       lname = :lname
  #     WHERE
  #       id = :id
  #   SQL
  # end

end
