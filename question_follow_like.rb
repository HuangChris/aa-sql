require_relative 'questions_database'

class QuestionFollow < Table
  TABLE_NAME = 'question_follows'

  def initialize(data)
    @id = data["id"]
    @question_id = data["question_id"]
    @user_id = data["user_id"]
  end

  def self.find_by_id(id)
    QuestionFollow.new(super(id))
  end

  def self.followers_for_question(question_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, question_id)
      SELECT
        user.*
      FROM
        user
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL

    data.map { |record| User.new(record) }
  end

  def self.followed_questions_for_user_id(user_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL

    data.map { |record| Question.new(record) }
  end

  def self.most_followed_questions(n)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, n)
      SELECT
        questions.title, COUNT(question_follows.id)
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      GROUP BY
        questions.title
      ORDER BY
        COUNT(question_follows.id)
      LIMIT
        ?
    SQL

    data.map { |record| Question.new(record) }
  end
end


class QuestionLike < Table
  TABLE_NAME = 'question_likes'

  def initialize(data)
    @id = data["id"]
    @question_id = data["question_id"]
    @user_id = data["user_id"]
  end

  def self.find_by_id(id)
    QuestionLike.new(super(id))
  end

  def self.likers_for_question_id(question_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    data.map { |record| User.new(record) }
  end

  def self.num_likes_for_question_id(question_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, question_id).first
      SELECT
        COUNT(question_likes.id) AS num_likes
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      HAVING
        questions.id = ?
    SQL

    data[0]
  end

  def self.liked_questions_for_user_id(user_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    data.map { |record| Question.new(record) }
  end

  def self.most_liked_questions(n)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.title
      ORDER BY
        COUNT(question_likes.id)
      LIMIT
        ?
    SQL

    data.map { |record| Question.new(record) }
  end
end
