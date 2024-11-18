# frozen_string_literal: true

class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.boolean :passed
      t.string :aasm_state
      t.integer :offenses_count
      t.string :commit_id
      t.json :check_results
      t.references :repository, foreign_key: true, null: false

      t.timestamps
    end
  end
end
