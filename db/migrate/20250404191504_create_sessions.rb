class CreateSessions < ActiveRecord::Migration[8.0]
  def up
    create_table :sessions do |t|
      t.belongs_to :resource, polymorphic: true, null: false
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :sessions, [:resource_type, :resource_id]
  end

  def down
    remove_index :sessions, name: :index_sessions_on_resource_type_and_resource_id
    drop_table :sessions
  end
end
