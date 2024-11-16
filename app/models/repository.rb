# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  RUBY = :ruby
  JAVASCRIPT = :javascript

  belongs_to :user
  has_many :checks, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true

  enumerize :language, in: [RUBY, JAVASCRIPT]
end
