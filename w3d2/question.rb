require_relative 'questions_database'

class Question < Table
  TABLE_NAME = 'questions'

  def initialize(data)
    @id = data["id"]
    @title = data["title"]
    @user_id = data["user_id"]
    @body = data["body"]
  end

  def save
    db = QuestionsDatabase.instance
    if @id.nil?
      db.execute(<<-SQL, title: @title, user_id: @user_id, body: @body)
        INSERT INTO
          questions(title, user_id, body)
        VALUES
          (:title, :user_id, :body)
      SQL
      @id = db.last_insert_row_id

    else
      db.execute(<<-SQL, title: @title, user_id: @user_id, body: @body, id: @id)
        UPDATE
          questions
        SET
          title = :title,
          user_id = :user_id,
          body = :body
        WHERE
          id = :id
      SQL
    end
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
    data = db.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        user_id = ?
    SQL

    data.map { |record| Question.new(record) }
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

  def most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end


end
