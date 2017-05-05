class ChangeFaqGroupNameNullFalse < ActiveRecord::Migration[5.0]
  def change
    change_column_null :faq_groups, :name, false
  end
end
