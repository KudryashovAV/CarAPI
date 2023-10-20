class CreateCarRankingsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :car_rankings do |t|
      t.references :user, null: false
      t.references :car, null: false
      t.decimal :rank_score, precision: 10, scale: 10

      t.timestamps
    end
  end
end
