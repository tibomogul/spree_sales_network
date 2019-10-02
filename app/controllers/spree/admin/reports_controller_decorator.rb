Spree::Admin::ReportsController.class_eval do

  def initialize
    super
    Spree::Admin::ReportsController.add_available_report!(:sales_total)
    Spree::Admin::ReportsController.add_available_report!(:paypal_payment_report)
  end

  def paypal_payment_report
    params[:q] = {} unless params[:q]

    params[:q][:updated_at_gt] = if params[:q][:updated_at_gt].blank?
                                     Time.zone.now.beginning_of_month
                                   else
                                     begin
                                        Time.zone.parse(params[:q][:updated_at_gt]).beginning_of_day
                                     rescue
                                        Time.zone.now.beginning_of_month
                                     end
                                   end

    if params[:q] && !params[:q][:updated_at_lt].blank?
      params[:q][:updated_at_lt] = begin
                                       Time.zone.parse(params[:q][:updated_at_lt]).end_of_day
                                     rescue
                                       ''
                                     end
    end

    params[:q][:s] ||= 'updated_at desc'

    @search = Spree::Payment.where(payment_method: 2, state: 'completed').ransack(params[:q])
    @payments = @search.result.page(params[:page]).
                  per(params[:per_page] || Spree::Config[:admin_orders_per_page])

  end

  private
end
