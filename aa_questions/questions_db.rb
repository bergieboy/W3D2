require 'sqlite3'
require 'singleton'
require 'byebug'
require_relative 'question'
require_relative 'user'
require_relative 'reply'
require_relative 'follow'
require_relative 'like'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

# class Question
#   attr_accessor :title, :body, :associated_author
#
#   def self.all
#     data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
#     data.map { |datum| Question.new(datum) }
#   end
#
#   def self.find_by_id(id)
#     question = QuestionDBConnection.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         id = ?
#     SQL
#     return nil unless question.length > 0
#
#     Question.new(question.first)
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @title = options['title']
#     @body = options['body']
#     @associated_author = options['associated_author']
#   end
#
#   def self.find_by_author_id(associated_author)
#     question = QuestionDBConnection.instance.execute(<<-SQL, associated_author)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         associated_author = ?
#     SQL
#     return nil unless question.length > 0
#
#     question.map { |quest| Question.new(quest) }
#
#   end
#
#   def author
#     author = QuestionDBConnection.instance.execute(<<-SQL, @associated_author)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         id = ?
#     SQL
#     return nil unless author.length > 0
#
#     User.new(author.first)
#   end
#
#   def replies
#     Reply.find_by_question_id(@id)
#   end
#
# end
#
# class User
#   attr_accessor :fname, :lname
#
#   def self.all
#     data = QuestionDBConnection.instance.execute("SELECT * FROM users")
#     data.map { |datum| User.new(datum) }
#   end
#
#   def self.find_by_id(id)
#     user = QuestionDBConnection.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         id = ?
#     SQL
#     return nil unless user.length > 0
#
#     User.new(user.first)
#   end
#
#   def self.find_by_name(fname, lname)
#     user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         fname = ? AND lname = ?
#     SQL
#     return nil unless user.length > 0
#
#     User.new(user.first)
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @fname = options['fname']
#     @lname = options['lname']
#   end
#
#   def authored_questions
#     Question.find_by_author_id(@id)
#   end
#
#   def authored_replies
#     Reply.find_by_user_id(@id)
#   end
#
#
# end
#
# class Reply
#   attr_accessor :question_id, :user_id, :parent_id, :body
#
#   def self.all
#     data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
#     data.map { |datum| Reply.new(datum) }
#   end
#
#   def self.find_by_id(id)
#     reply = QuestionDBConnection.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         id = ?
#     SQL
#     return nil unless reply.length > 0
#
#     Reply.new(reply.first)
#   end
#
#   def self.find_by_user_id(user_id)
#     reply = QuestionDBConnection.instance.execute(<<-SQL, user_id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         user_id = ?
#     SQL
#     return nil unless reply.length > 0
#
#     reply.map { |rep| Reply.new(rep) }
#   end
#
#   def self.find_by_question_id(question_id)
#     reply = QuestionDBConnection.instance.execute(<<-SQL, question_id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         question_id = ?
#     SQL
#     return nil unless reply.length > 0
#
#     reply.map { |rep| Reply.new(rep) }
#   end
#
#
#   def initialize(options)
#     @id = options['id']
#     @user_id = options['user_id']
#     @question_id = options['question_id']
#     @parent_id = options['parent_id']
#     @body = options['body']
#   end
#
#   def author
#     author = QuestionDBConnection.instance.execute(<<-SQL, @user_id)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         id = ?
#     SQL
#     return nil unless author.length > 0
#
#     User.new(author.first)
#   end
#
#   def question
#     question = QuestionDBConnection.instance.execute(<<-SQL, @question_id)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         id = ?
#     SQL
#     return nil unless question.length > 0
#
#     Question.new(question.first)
#   end
#
#   def parent_reply
#     parent = QuestionDBConnection.instance.execute(<<-SQL, @parent_id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         id = ?
#     SQL
#     return nil unless parent.length > 0
#
#     Reply.new(parent.first)
#   end
#
#   def child_replies
#     children = QuestionDBConnection.instance.execute(<<-SQL, @id)
#       SELECT
#         *
#       FROM
#         replies
#       WHERE
#         parent_id = ?
#     SQL
#     return nil unless children.length > 0
#
#     children.map { |child| Reply.new(child) }
#   end
#
# end
#
# class Follow
#   attr_accessor :user_id, :question_id
#   def self.all
#     data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
#     data.map { |datum| Follow.new(datum) }
#   end
#
#   def self.find_by_id(id)
#     follow = QuestionDBConnection.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         question_follows
#       WHERE
#         id = ?
#     SQL
#     return nil unless follow.length > 0
#
#     Follow.new(follow.first)
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @user_id = options['user_id']
#     @question_id = options['question_id']
#   end
#
# end
#
# class Like
#   attr_accessor :user_id, :question_id
#   def self.all
#     data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
#     data.map { |datum| Like.new(datum) }
#   end
#
#   def self.find_by_id(id)
#     like = QuestionDBConnection.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         question_likes
#       WHERE
#         id = ?
#     SQL
#     return nil unless like.length > 0
#
#     Like.new(like.first)
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @user_id = options['user_id']
#     @question_id = options['question_id']
#   end
# end
