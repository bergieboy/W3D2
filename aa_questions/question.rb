class Question
  attr_accessor :title, :body, :associated_author

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0

    Question.new(question.first)
  end

  def self.most_followed(n)
    Follow.most_followed_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @associated_author = options['associated_author']
  end

  def self.find_by_author_id(associated_author)
    question = QuestionDBConnection.instance.execute(<<-SQL, associated_author)
      SELECT
        *
      FROM
        questions
      WHERE
        associated_author = ?
    SQL
    return nil unless question.length > 0

    question.map { |quest| Question.new(quest) }

  end

  def author
    author = QuestionDBConnection.instance.execute(<<-SQL, @associated_author)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless author.length > 0

    User.new(author.first)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Follow.followers_for_question_id(@id)
  end

  def likers
    Like.likers_question_id(@id)
  end

  def num_likes
    Like.num_likes_for_question_id(@id)
  end

end
