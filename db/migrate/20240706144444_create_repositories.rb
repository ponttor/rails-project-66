# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.integer :github_id, null: false
      t.string :full_name
      t.string :language
      t.string :clone_url
      t.string :ssh_url
      t.string :commit_id
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :repositories, :github_id, unique: true
  end
end
