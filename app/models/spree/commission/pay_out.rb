module Spree
  class Commission < Spree::Base
    module PayOut
      extend ActiveSupport::Concern

      class_methods do
        # until_date = Time.use_zone('Asia/Singapore'){ Date.yesterday.at_end_of_day.days_ago(7) }
        def authorize_commissions(until_date)
          raise ArgumentError, 'Argument is not a valid time' unless until_date.is_a?(ActiveSupport::TimeWithZone) 
          transaction do
            q = where("created_at <= ?", until_date).where(state: 'eligible')
            q.update_all([
              'state = ?, updated_at = ?',
              'authorized',
              DateTime.current
            ])
          end
        rescue => e
          logger.error(Spree.t(:authorize_commissions_error))
          logger.error("#{e.to_yaml}")
        end

        def summarize
          # ActiveRecord::Base.connection.execute("select SUM(amount) AS total, user_id, GROUP_CONCAT(DISTINCT id SEPARATOR ',') AS comm_id from spree_commissions WHERE state = 'authorized' GROUP BY user_id")

          # https://dba.stackexchange.com/questions/86415/retrieving-n-rows-per-group
          # https://stackoverflow.com/questions/2560946/postgresql-group-concat-equivalent
          
          # https://stackoverflow.com/questions/2129693/using-limit-within-group-by-to-get-n-results-per-group
          # https://stackoverflow.com/questions/27524704/sql-query-to-limit-rows-within-a-group -- no row_number for mysql
        end
      end
  	end
  end
end
