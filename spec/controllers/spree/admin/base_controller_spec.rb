# Spree's rpsec controller tests get the Spree::ControllerHacks
# we don't need those for the anonymous controller here, so
# we call process directly instead of get
require 'spec_helper'

describe Spree::Admin::BaseController do

  controller(Spree::Admin::BaseController) do
    def index
      render :text => 'test'
    end
  end

  describe 'authorization' do
    it "checks for admins" do
      controller.should_receive :authorize_admin!
      controller.stub(:authorize!)
      process :index
    end

    it "checks resources" do
      controller.stub :authorize_admin!
      controller.should_receive(:authorize!).with(:index, Object)
      process :index
    end
  end

  describe 'authorize_admin!' do
    it 'checks if the user can access the main admin page' do
      controller.should_receive(:can?).with(:manage, 'spree_overview_controller').and_return(true)
      controller.stub(:authorize!).with(:index, Object)
      controller.authorize_admin!
    end

    it 'raises an exception for disallowed users' do
      controller.stub(:can?).and_return(false)
      expect { controller.authorize_admin! }.to raise_error(CanCan::AccessDenied)
    end

  end

end
