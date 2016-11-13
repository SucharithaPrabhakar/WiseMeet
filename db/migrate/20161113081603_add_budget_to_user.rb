class AddBudgetToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_budget, :float
    add_column :users, :budget_change_reason, :string
  end
end
