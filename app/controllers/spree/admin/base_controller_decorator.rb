module Spree
  module Admin
    BaseController.class_eval do

#      if Rails.env.development?
#        rescue_from CanCan::AccessDenied do |exception|
#          Rails.logger.debug "**** Access denied on #{exception.action} #{exception.subject.inspect} (SpreeAdminRoles:BaseControllerDecorator)"
#        end
#      end

      def authorize_admin
        if respond_to?(:model_class, true) && model_class
          record = model_class
        else
          record = Object
        end

        authorize_admin!

        authorize! action, record

      end

      def authorize_admin!
        unless can? :manage, 'spree_overview_controller'
          raise CanCan::AccessDenied.new("Not authorized!", :manage, 'spree_overview_controller')
        end
      end

    end
  end
end