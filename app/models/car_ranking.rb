class CarRanking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  def self.insert_all(records, options)
    return [] if records.blank?

    normalized = normalize(records)
    super(normalized, options)
  end

  private_class_method def self.normalize(records)
    records.each do |record|
      time = Time.current
      record["created_at"] = time
      record["updated_at"] = time
    end
  end
end
