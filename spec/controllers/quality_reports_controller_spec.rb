require 'rails_helper'

RSpec.describe QualityReportsController, type: :controller do
  describe 'GET index' do
    let!(:user) { create(:user) }
    let(:users_quality_reports) { create_list(:quality_report, 3, user_id: user.id) }
    let(:other_users_quality_reports) { create_list(:quality_report, 2) }

    before { session[:user_id] = user.id }

    it 'displays all user\'s quality reports' do
      get :index
      expect(assigns(:quality_reports)).to eq(users_quality_reports)
    end
  end

  describe 'POST create' do
    let(:rows) do
      [
        ['a', 'a', 'a', 'a', 'a'],
        [nil, nil, nil, 'a', nil],
        ['a', 'a', nil, 'a', nil],
        ['a', nil, nil, 'a', nil],
        [nil, nil, nil, nil, nil]
      ]
    end

    let(:file_path) { 'tmp/test.csv' }
    let!(:csv) { CSV.open(file_path, 'w') { |csv| rows.each { |row| csv << row } } }

    before do
      constraints = %w[gaps_between_lectures lecture_distribution lecture_shifts]

      constraints.each { |constraint| QualityConstraint.create(title: constraint, default_weight: 1) }
    end

    let(:params) do
      result = { lectures: file_path }

      QualityConstraint.all.pluck(:title).each do |contraint|
        result[contraint.to_sym] = 1.0
      end

      { quality_report: result }
    end

    it 'creates quality report' do
      expect { post(:create, params:) }.to change(QualityReport, :count)
    end

    it 'takes less than 5 seconds to run' do
      start = DateTime.now.to_i
      post(:create, params:)
      duration = DateTime.now.to_i - start

      expect(duration).to be < 5
    end
  end
end
