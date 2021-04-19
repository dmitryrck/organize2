class AddAdminUserToMovement < ActiveRecord::Migration[6.0]
  def change
    add_reference :movements, :admin_user
  end
end
