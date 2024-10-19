# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include CheckStateMachine

  belongs_to :repository, inverse_of: :checks, class_name: 'Repository'
end
