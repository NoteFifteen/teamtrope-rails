class AddNeedsAgreementToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :needs_agreement, :boolean, default: false, before: :created_at
  end
end
