class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :nickname, :string
    add_column :users, :website, :string
    add_column :users, :display_name, :string

    ## Database authenticatable
    add_column :users, :encrypted_password, :string, null: false, default: ''

    ## Recoverable
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    ## Trackable
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :inet
    add_column :users, :last_sign_in_ip, :inet

    add_index :users, :reset_password_token, unique: true
    add_index :users, :uid, unique: true
  end
end

  #   create_table(:users) do |t|



  #     ## Database authenticatable
  #     t.string :email,              null: false, default: ""
  #     t.string :encrypted_password, null: false, default: ""

  #     ## Recoverable
  #     t.string   :reset_password_token
  #     t.datetime :reset_password_sent_at

  #     ## Rememberable
  #     t.datetime :remember_created_at

  #     ## Trackable
  #     t.integer  :sign_in_count, default: 0, null: false
  #     t.datetime :current_sign_in_at
  #     t.datetime :last_sign_in_at
  #     t.inet     :current_sign_in_ip
  #     t.inet     :last_sign_in_ip

  #     ## Confirmable
  #     # t.string   :confirmation_token
  #     # t.datetime :confirmed_at
  #     # t.datetime :confirmation_sent_at
  #     # t.string   :unconfirmed_email # Only if using reconfirmable

  #     ## Lockable
  #     # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
  #     # t.string   :unlock_token # Only if unlock strategy is :email or :both
  #     # t.datetime :locked_at


  #     t.timestamps
  #   end

  #   add_index :users, :email,                unique: true
  #   add_index :users, :reset_password_token, unique: true
  #   add_index :users, :uid,                  unique: true
  #   # add_index :users, :confirmation_token,   unique: true
  #   # add_index :users, :unlock_token,         unique: true
  # end
