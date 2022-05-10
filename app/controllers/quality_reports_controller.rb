require 'csv'

class QualityReportsController < ApplicationController
  before_action :require_user_logged_in!, only: %i[index]
  before_action :set_quality_report, only: %i[show destroy]

  def index
    @quality_reports = QualityReport.where(user_id: Current.user.id)
  end

  def show; end

  def new
    @quality_report = QualityReport.new
  end

  def create
    lectures = CSV.table(quality_report_params[:lectures], headers: false, col_sep: ',').transpose
    parameters = quality_report_params.except(:lectures).to_h
    quality_result = CalculateQuality.new(lectures, parameters).execute

    new_params = {
      user_id: Current.user.id,
      score: quality_result[:score],
      constraint_scores: quality_result[:constraint_scores],
      parameters: parameters,
      lectures: lectures
    }

    @quality_report = QualityReport.new(new_params)

    respond_to do |format|
      if @quality_report.save
        format.html { redirect_to @quality_report, notice: 'Quality Report was successfully created.' }
        format.json { render :index, status: :created, location: @quality_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quality_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quality_report.destroy

    respond_to do |format|
      format.html { redirect_to quality_reports_url, notice: 'Quality Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_quality_report
    @quality_report = QualityReport.find(params[:id])
  end

  def quality_report_params
    params.require(:quality_report).permit(QualityConstraint.all.pluck(:title).map(&:to_sym) << :lectures)
  end
end
