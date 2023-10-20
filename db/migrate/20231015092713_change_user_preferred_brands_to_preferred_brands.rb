class ChangeUserPreferredBrandsToPreferredBrands < ActiveRecord::Migration[6.1]
  def change
    rename_table :user_preferred_brands, :preferred_brands
  end
end
