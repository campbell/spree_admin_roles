# Spree's rpsec controller tests get the Spree::ControllerHacks
# we don't need those for the anonymous controller here, so
# we call process directly instead of get
require 'spec_helper'

describe Spree::Admin::OverviewController do

  describe 'model_class' do
    it "returns spree_overview_controller" do
      expect(controller.model_class).to eq('spree_overview_controller')
    end
  end

end
