class AddParentConstraint < ActiveRecord::Migration[6.0]
  def change
    execute %[
      alter table movements add constraint parent_constraint check (id != parent_id);
    ]
  end
end
