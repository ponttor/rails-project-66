# frozen_string_literal: true

class RemoveCommitId < ActiveRecord::Migration[7.0]
  def change
    remove_column :repositories, :commit_id, :string
  end
end
