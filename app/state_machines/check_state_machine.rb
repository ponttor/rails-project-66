# frozen_string_literal: true

module CheckStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :created, initial: true
      state :fetching, :fetched, :checking, :checked, :parsing, :parsed, :finished, :failed

      event :start_fetch do
        transitions from: :created, to: :fetching
      end

      event :complete_fetch do
        transitions from: :fetching, to: :fetched
      end

      event :start_check do
        transitions from: :fetched, to: :checking
      end

      event :complete_check do
        transitions from: :checking, to: :checked
      end

      event :start_parse do
        transitions from: :checked, to: :parsing
      end

      event :complete_parse do
        transitions from: :parsing, to: :parsed
      end

      event :finish do
        transitions from: :parsed, to: :finished
      end

      event :fail do
        transitions to: :failed
      end
    end
  end
end
