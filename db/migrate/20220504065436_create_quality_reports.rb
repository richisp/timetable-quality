class CreateQualityReports < ActiveRecord::Migration[7.0]
  def change
    create_table :quality_reports do |t|
      t.belongs_to :user, foreign_key: true
      t.string :score
      t.text :constraint_scores
      t.text :parameters
      t.text :lectures

      t.timestamps
    end
  end
end
