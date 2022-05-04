class CreateQualityConstraints < ActiveRecord::Migration[7.0]
  def change
    create_table :quality_constraints do |t|
      t.string :title
      t.decimal :default_weight
      t.string :calculation_class

      t.timestamps
    end
  end
end
