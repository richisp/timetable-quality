FactoryBot.define do
  factory :quality_report do
    score { 0.827 }
    constraint_scores { { 'gaps_between_lectures' => 0.8, 'lecture_distribution' => 0.7, 'lecture_shifts' => 0.9 } }
    parameters { { 'gaps_between_lectures' => '1.0', 'lecture_distribution' => '1.0', 'lecture_shifts' => '1.0' } }

    lectures do
      [
        ['a', nil, 'a', 'a', nil],
        ['a', nil, 'a', nil, nil],
        ['a', nil, nil, nil, nil],
        ['a', 'a', 'a', 'a', nil],
        ['a', nil, nil, nil, nil]
      ]
    end
  end
end
