class AddNameContentPictureToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :name, :string
    add_column :groups, :picture, :string
    add_column :groups, :content, :string
  end
end
