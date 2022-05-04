class QualityReport < ApplicationRecord
  belongs_to :user

  serialize :constraint_scores, :parameters, :lectures
end
