# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :name
      t.string :email
      t.string :image_url
      t.string :token

      t.timestamps
    end
  end
end
