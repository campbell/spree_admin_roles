module Spree
  module Admin
    module Orders
      CustomerDetailsController.class_eval do
        def model_class
          'spree_customer_details_controller'
        end
      end
    end
  end
end

