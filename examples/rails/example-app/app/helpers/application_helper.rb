module ApplicationHelper
  def asset_tags
    @asset_tags ||= Pannier::Tags.new(Rails.application.config.pannier)
  end
end
