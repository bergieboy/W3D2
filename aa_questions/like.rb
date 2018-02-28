class Like
  attr_accessor :user_id, :question_id
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| Like.new(datum) }
  end

  def self.find_by_id(id)
    like = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    return nil unless like.length > 0

    Like.new(like.first)
  end

  def self.likers_question_id(question_id)
    likers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        questions
      JOIN
        question_likes
          ON questions.id = question_likes.question_id
      JOIN
        users
          ON users.id = question_likes.user_id
      WHERE
        questions.id = ?
    SQL
    return nil unless likers.length > 0

    likers.map { |liker| User.new(liker) }
  end

  def self.num_likes_for_question_id(question_id)
    likers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_id) AS 'Num_likes'
      FROM
        questions
      JOIN
        question_likes
          ON questions.id = question_likes.question_id
      WHERE
        question_id = ?
    SQL
    likers
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.associated_author
      FROM
        questions
      JOIN
        question_likes
          ON questions.id = question_likes.question_id
      JOIN
        users
          ON users.id = question_likes.user_id
      WHERE
        users.id = ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Question.new(question) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
