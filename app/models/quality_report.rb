class QualityReport < ApplicationRecord
  belongs_to :user

  serialize :constraint_scores
  serialize :parameters
  serialize :lectures
end
