class AddLatLngToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :lat, :decimal
    add_column :memberships, :lng, :decimal
  end
end
