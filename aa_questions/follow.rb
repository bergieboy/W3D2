class Follow
  attr_accessor :user_id, :question_id
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| Follow.new(datum) }
  end

  def self.find_by_id(id)
    follow = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless follow.length > 0

    Follow.new(follow.first)
  end

  def self.followers_for_question_id(question_id)
    follow = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        questions
      JOIN
        question_follows
          ON questions.id = question_follows.question_id
      JOIN
        users
          ON users.id = question_follows.user_id
      WHERE
        questions.id = ?
    SQL
    return nil unless follow.length > 0

    User.new(follow.first)
  end

  def self.followed_questions_for_user_id(user_id)
    follow = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.associated_author
      FROM
        questions
      JOIN
        question_follows
          ON questions.id = question_follows.question_id
      JOIN
        users
          ON users.id = question_follows.user_id
      WHERE
        users.id = ?
    SQL
    return nil unless follow.length > 0

    Question.new(follow.first)
  end

  def self.most_followed_questions(n)
    follow = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.associated_author
      FROM
        questions
      JOIN
        question_follows
          ON questions.id = question_follows.question_id
      GROUP BY
        questions.id

      ORDER BY
        COUNT(questions.id) DESC
      LIMIT
        ?
    SQL
    return nil unless follow.length > 0

    follow.map { |question| Question.new(question) }
  end


  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end


end
