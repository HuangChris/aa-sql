require_relative 'questions_database'

class Reply < Table
  TABLE_NAME = 'replies'

  def initialize(data)
    @id = data["id"]
    @question_id = data["question_id"]
    @parent_id = data["parent_id"]
    @user_id = data["user_id"]
    @body = data["body"]
  end

  def save
    db = QuestionsDatabase.instance
    if @id.nil?
      db.execute(<<-SQL, question_id: @question_id, parent_id: @parent_id, user_id: @user_id, body: @body)
        INSERT INTO
          replies(question_id, parent_id, user_id, body)
        VALUES
          (:question_id, :parent_id, :user_id, :body)
      SQL
      @id = db.last_insert_row_id

    else
      db.execute(<<-SQL, question_id: @question_id, parent_id: @parent_id, user_id: @user_id, body: @body, id: @id)
        UPDATE
          replies
        SET
          question_id = :question_id,
          parent_id = :parent_id,
          user_id = :user_id,
          body = :body
        WHERE
          id = :id
      SQL
    end
  end

  def self.find_by_id(id)
    Reply.new(super(id))
  end

  def self.find_by_question_id(question_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
      data.map { |record| Reply.new(record) }
  end

  def self.find_by_user_id(user_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    data.map { |record| Reply.new(record) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    data.map { |record| Reply.new(record) }
  end
end
