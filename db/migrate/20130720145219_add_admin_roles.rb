class AddAdminRoles < ActiveRecord::Migration

  def up
    Spree::AdminAbility::ADMIN_ROLES.each{|r| Spree::Role.create(name: r)}
  end

  def down
    Spree::AdminAbility::ADMIN_ROLES.each{|r| Spree::Role.destroy_all(name: r)}
  end
end
