# frozen_string_literal: true

class Disputes::AppealsController < Disputes::BaseController
  before_action :set_strike

  def create
    authorize @strike, :appeal?

    @appeal = @strike.build_appeal(appeal_params.merge(account: current_account))

    if @appeal.save
      redirect_to settings_strike_path(@strike)
    else
      @statuses = @strike.statuses.with_includes

      render template: 'settings/strikes/show'
    end
  end

  private

  def set_strike
    @strike = current_account.strikes.find(params[:strike_id])
  end

  def appeal_params
    params.require(:appeal).permit(:text)
  end
end
