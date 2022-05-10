class CalculateQuality
  def initialize(lectures, parameters)
    @lectures = lectures
    @parameters = parameters
  end

  def execute
    constraint_scores = calculate_constraint_scores

    { score: apply_weights(constraint_scores), constraint_scores: }
  end

  def calculate_constraint_scores
    result = {}

    QualityConstraint.all.each do |constraint|
      result[constraint.title] = send(constraint.title.to_sym)
    end

    result
  end

  def apply_weights(constraint_scores)
    constraint_scores.sum do |constraint_title, value|
      value * weights[constraint_title] / weights.sum { |_, v| v }
    end
  end

  def weights
    result = {}

    QualityConstraint.all.each do |constraint|
      result[constraint.title] = (@parameters[constraint.title].presence || constraint.default_weight).to_f
    end

    result
  end

  def gaps_between_lectures
    gaps_count = @lectures.sum do |day|
      day.map { |a| a.present? ? a.gsub(' ', '_') : ' ' }.join.strip.squish.count(' ')
    end

    1 - normalize(gaps_count, @lectures.sum { |day| day.compact.size } - 1, 0)
  end

  def lecture_distribution
    lecture_counts = @lectures.map { |day| day.compact.size }
    sd = standard_deviation(lecture_counts)

    1 - normalize(sd, standard_deviation([lecture_counts.sum, 0, 0, 0, 0]), 0)
  end

  def lecture_shifts
    lecture_span = @lectures.sum do |day|
      day.map { |a| a.present? ? a.gsub(' ', '_') : ' ' }.join.strip.length
    end

    1 - normalize(lecture_span, 50, @lectures.sum { |day| day.compact.size })
  end

  def standard_deviation(array)
    mean = array.sum(0.0) / array.size
    sum = array.sum(0.0) { |element| (element - mean)**2 }
    variance = sum / (array.size - 1)

    Math.sqrt(variance)
  end

  def normalize(value, maximum, minimum)
    (value - minimum) / (maximum - minimum).to_f
  end
end
