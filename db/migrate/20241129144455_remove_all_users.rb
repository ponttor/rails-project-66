class RemoveAllUsers < ActiveRecord::Migration[7.0]
  def up
    User.delete_all
  end
end
