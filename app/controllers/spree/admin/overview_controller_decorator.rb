module Spree
  module Admin
    OverviewController.class_eval do
      def model_class
        'spree_overview_controller'
      end
    end
  end
end

