class QualityReport < ApplicationRecord
  belongs_to :user, required: false

  serialize :constraint_scores
  serialize :parameters
  serialize :lectures
end
