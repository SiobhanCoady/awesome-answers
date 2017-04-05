# This is our Question model. It inherits from 'ApplicationRecord', which inherits
# from 'ActiveRecord::Base', which is a class that comes from Rails.
# All the functionalities we're going to be using in our Question model come from
# 'ActiveRecord::Base', which leverages Ruby's meta programming features.
class Question < ApplicationRecord
  has_many :answers

  # has_many :answers adds the following instance methods to this model,
  # Questions:
  # answers
  # answers<<(object, ...)
  # answers.delete(object, ...)
  # answers.destroy(object, ...)
  # answers=(objects)
  # answers_singular_ids
  # answers_singular_ids=(ids)
  # answers.clear
  # answers.empty?
  # answers.size
  # answers.find(...)
  # answers.where(...)
  # answers.exists?(...)
  # answers.build(attributes = {}, ...)
  # answers.create(attributes = {})
  # answers.create!(attributes = {})
  # http://guides.rubyonrails.org/association_basics.html#has-many-association-reference

  # as of Rails 5, belongs_to :subject will enforce a validation that the
  # association must be present by default (subject required). To make it optional
  # give 'belongs_to' a second argument, 'optional: true'
  belongs_to :subject, optional: true

  belongs_to :user, optional: true

  validates(:title, { presence: { message: 'must be present!' },
  # can use your own message instead of just 'true'
                      uniqueness: true })
  validates(:body, { presence: true, length: { minimum: 5 } })
  validates(:view_count, { presence: true,
                           numericality: { greater_than_or_equal_to: 0 } })

  # this is used fo custom-validation method. We expect to have a method called
  # 'no_monkey' defined, ideally in the private section of the class.
  validate :no_monkey

  after_initialize :set_defaults
  before_validation :titleize_title

  # class method... (do not have to call .new to use)
  def self.recent_five
    order(created_at: :desc).limit(5)
  end
  # can also write the above as...
  # scope :recent_five, lambda { order(created_at: :desc).limit(5) }

  def self.recent(number)
    order(created_at: :desc).limit(number)
  end

  private

  def titleize_title
    self.title = title.titleize if title.present?
  end

  def set_defaults
    self.view_count ||= 0 # set equal to zero if no number provided
  end

  def no_monkey
    if title.present? && title.downcase.include?('monkey')
      # This will make the record invalid. Even if there is one error on the
      # record by using 'errors.add', then the record won't save because it
      # won't be valid.
      errors.add(:title, 'cannot include monkey!')
    end
  end

end
