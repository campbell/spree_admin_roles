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

#        unless can?(:admin, record) || can?(:admin_all, record)
#          authorize! :admin, record
#        end

        authorize_admin!

        puts "**** #{action} for #{record} : #{can?(action, record)}"
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