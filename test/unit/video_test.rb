require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  fixtures :videos, :presenters, :events

  model_template_for Video do
    {
      :title => 'Writing Modular Ruby Code: Lessons Learned from Rails 3',
      :event_id => events(:mwrc2010).id,
      :recorded_at => Time.zone.now,
      :available => true,
      :streaming_asset_id => 1
    }
  end

  test_validations_for :title, :presence
  test_validations_for :recorded_at, :presence

  test "slug should return" do
    v = videos(:valid)

    assert v.slug
  end

  test "views exist" do
    v = videos(:valid)

    assert v.views, 0
  end
end
