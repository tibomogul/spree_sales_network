module Spree
  module Admin
    class EncashmentsController < Spree::Admin::BaseController
      before_action :load_encashment, only: [:edit, :update]

      respond_to :html

      def index
        params[:q] ||= {}
        params[:q][:s] ||= 'created_at desc'

        if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
                                         Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                       rescue
                                         ''
                                       end
        end

        if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
                                         Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                       rescue
                                         ''
                                       end
        end

        @search = Spree::Encashment.preload(:user).accessible_by(current_ability, :index).ransack(params[:q])

        # lazy loading other models here (via includes) may result in an invalid query
        # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
        # see https://github.com/spree/spree/pull/3919
        @encashments = @search.result(distinct: true).
                  page(params[:page]).
                  per(params[:per_page] || Spree::Config[:admin_orders_per_page])
      end

      private

      def encashment_params
        # params[:created_by_id] = try_spree_current_user.try(:id)
        # params.permit(:created_by_id, :user_id, :store_id)
        params.permit(:user_id, :amount)
      end

      def load_encashment
        @encashment = Spree::Encashment.includes(:user).find(params[:id])
        authorize! action, @encashment
      end

    end
	end
end
