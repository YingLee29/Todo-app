class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.bigint :sender_id, null: false
      t.bigint :receiver_id, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
