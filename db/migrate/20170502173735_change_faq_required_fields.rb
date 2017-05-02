class ChangeFaqRequiredFields < ActiveRecord::Migration[5.0]
  def change
    change_column_null :faqs, :answer, false
    change_column_null :faqs, :question, false
  end
end
