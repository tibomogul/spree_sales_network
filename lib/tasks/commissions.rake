namespace :spree_sales_network do
  namespace :commissions do
    desc "Authorize commissions"
    task authorize: :environment do
      until_date = Time.use_zone('Asia/Singapore'){ Date.yesterday.at_end_of_day.days_ago(7) }
      Spree::Commission.authorize_commissions(until_date)
    end
  end
end