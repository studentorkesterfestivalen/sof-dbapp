class AddEnglishFieldsToFaqAndFaqGroups < ActiveRecord::Migration[5.0]
  def change
    change_table :faqs do |t|
      t.string :question_eng, null: false, default: ''
      t.text :answer_eng, null: false, default: ''
    end

    change_table :faq_groups do |t|
      t.string :name_eng, null: false, default: ''
    end
  end
end
