class RemoveAllUsers < ActiveRecord::Migration[7.0]
  def up
    User.destroy_all
  end
end
