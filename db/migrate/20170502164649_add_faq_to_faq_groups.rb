class AddFaqToFaqGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :faqs, :faq_group, index: true
  end
end
