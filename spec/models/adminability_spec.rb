require 'spec_helper'
require 'cancan/matchers'
#require 'spree/core/testing_support/bar_ability'

describe Spree::AdminAbility do
  let(:user) { create(:user) }
  let(:ability) { Spree::Ability.new(user) }
  let(:token) { nil }
  let(:admin_roles) { [Spree::Role.new(name: 'admin:orders')]   }

  before do
    user.spree_roles.clear
    Spree::Ability.register_ability(Spree::AdminAbility)
  end

  TOKEN = 'token123'

  after(:each) {
    user.spree_roles = []
  }

  shared_examples_for 'access granted' do
    it 'should allow read' do
      ability.should be_able_to(:read, resource, token) if token
      ability.should be_able_to(:read, resource) unless token
    end

    it 'should allow create' do
      ability.should be_able_to(:create, resource, token) if token
      ability.should be_able_to(:create, resource) unless token
    end

    it 'should allow update' do
      ability.should be_able_to(:update, resource, token) if token
      ability.should be_able_to(:update, resource) unless token
    end
  end

  shared_examples_for 'access denied' do
    it 'should not allow read' do
      ability.should_not be_able_to(:read, resource)
    end

    it 'should not allow create' do
      ability.should_not be_able_to(:create, resource)
    end

    it 'should not allow update' do
      ability.should_not be_able_to(:update, resource)
    end
  end

  shared_examples_for 'index allowed' do
    it 'should allow index' do
      ability.should be_able_to(:index, resource)
    end
  end

  shared_examples_for 'no index allowed' do
    it 'should not allow index' do
      ability.should_not be_able_to(:index, resource)
    end
  end

  shared_examples_for 'create only' do
    it 'should allow create' do
      ability.should be_able_to(:create, resource)
    end

    it 'should not allow read' do
      ability.should_not be_able_to(:read, resource)
    end

    it 'should not allow update' do
      ability.should_not be_able_to(:update, resource)
    end

    it 'should not allow index' do
      ability.should_not be_able_to(:index, resource)
    end
  end

  shared_examples_for 'read only' do
    it 'should not allow create' do
      ability.should_not be_able_to(:create, resource)
    end

    it 'should not allow update' do
      ability.should_not be_able_to(:update, resource)
    end

    it 'should allow index' do
      ability.should be_able_to(:index, resource)
    end
  end

  context 'for admin protected resources' do
    let(:admin_page) { 'spree_overview_controller' }
    let(:customer_details_page) { 'spree_customer_details_controller' }
    let(:resource_order) { Spree::Order.new }
    let(:resource_payment) { Spree::Payment.new }
    let(:resource_shipment) { Spree::Shipment.new }
    let(:resource_adjustment) { Spree::Adjustment.new }
    let(:resource_return_authorization) { Spree::ReturnAuthorization.new }
    let(:resource_product) { Spree::Product.new }
    let(:resource_taxon) { Spree::Taxon.new }
    let(:resource) { Object.new }
    let(:resource_user) { Spree::User.new }
    let(:fakedispatch_user) { Spree.user_class.new }
    let(:fakedispatch_ability) { Spree::Ability.new(fakedispatch_user) }

    context 'with admin:orders user' do
      it 'should be able to admin' do
        user.spree_roles = admin_roles #<< Spree::Role.find_or_create_by_name('admin')
        ability.should be_able_to :manage, resource_order
        ability.should be_able_to :manage, resource_payment
        ability.should be_able_to :manage, resource_shipment
        ability.should be_able_to :manage, resource_adjustment
        ability.should be_able_to :manage, resource_return_authorization
        ability.should be_able_to :manage, resource_return_authorization

        ability.should_not be_able_to :manage, resource
        ability.should_not be_able_to :manage, resource_user
        ability.should_not be_able_to :manage, resource_taxon
        ability.should_not be_able_to :manage, resource_product
      end
    end

    context 'with normal user' do
      it 'should be able to admin on the order and shipment pages' do
        ability.should_not be_able_to :manage, resource_order
        ability.should_not be_able_to :manage, resource_payment
        ability.should_not be_able_to :manage, resource_shipment
        ability.should_not be_able_to :manage, resource_adjustment
        ability.should_not be_able_to :manage, resource_return_authorization
        ability.should_not be_able_to :manage, resource_return_authorization
        ability.should_not be_able_to :manage, resource_taxon
        ability.should_not be_able_to :manage, resource_product
      end
    end

    # Attempt to ensure that we didn't change any other permissions
    context 'for Order' do
      let(:resource) { Spree::Order.new }

      context 'requested by same user' do
        before(:each) { resource.user = user }
        it_should_behave_like 'access granted'
        it_should_behave_like 'no index allowed'
      end

      context 'requested by other user' do
        before(:each) { resource.user = Spree.user_class.new }
        it_should_behave_like 'create only'
      end

      context 'requested with proper token' do
        let(:token) { 'TOKEN123' }
        before(:each) { resource.stub :token => 'TOKEN123' }
        it_should_behave_like 'access granted'
        it_should_behave_like 'no index allowed'
      end

      context 'requested with inproper token' do
        let(:token) { 'FAIL' }
        before(:each) { resource.stub :token => 'TOKEN123' }
        it_should_behave_like 'create only'
      end
    end

  end

end
