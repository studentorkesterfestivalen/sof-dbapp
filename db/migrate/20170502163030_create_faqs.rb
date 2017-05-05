class CreateFaqs < ActiveRecord::Migration[5.0]
  def change
    create_table :faq_groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :faqs do |t|
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
