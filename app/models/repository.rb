# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, dependent: :destroy, class_name: 'Repository::Check'
end
