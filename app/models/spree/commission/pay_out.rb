module Spree
  class Commission < Spree::Base
    module PayOut
      extend ActiveSupport::Concern

      class_methods do
        def monthly_bounds(included_date=nil)
          if included_date.nil?
            included_date = Time.use_zone('Asia/Singapore'){ Date.current } 
          end
          raise ArgumentError, 'Argument is not a valid time' unless included_date.is_a?(Date)
          start_date = included_date.at_beginning_of_month.at_beginning_of_day
          end_date = included_date.at_end_of_month.at_end_of_day
          [start_date, end_date]
        end

        def monthly_total(user, included_date=nil)
          start_date, end_date = monthly_bounds(included_date)
          where(user_id: user.id).where("created_at >= ?", start_date).where("created_at <= ?", end_date).sum(:amount)
        end

        def monthly_transactions(user, included_date=nil)
          start_date, end_date = monthly_bounds(included_date)
          where(user_id: user.id).where("created_at >= ?", start_date).where("created_at <= ?", end_date)
        end

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

        def pay_commissions(until_date, simulation=true)
          raise ArgumentError, 'Argument is not a valid time' unless until_date.is_a?(ActiveSupport::TimeWithZone)
          category = Spree::StoreCreditCategory.find_by! name: "Points"
          credit_type = Spree::StoreCreditType.find_by! name: "Points"
          simulate = simulation
          transaction do
            member_ids_query = where.not(user_id: nil).where("created_at <= ?", until_date).where(state: 'authorized').distinct.select(:user_id).limit(1000)
            member_ids_subset = member_ids_query.pluck(:user_id)
            while !member_ids_subset.empty?
              member_ids_subset.each do |member_id|
                commission_q = where("created_at <= ?", until_date).where(state: 'authorized').where(user_id: member_id).distinct.select(:id).limit(100)
                commission_q_subset = commission_q.pluck(:id)
                while !commission_q_subset.empty?
                  subtotal = where(id: commission_q_subset).sum(:amount)

                  puts "Member: #{member_id}, Amount: #{subtotal}"
                  # create the credit here
                  credit = create_credit(member_id, category.id, credit_type.id, subtotal, "PHP")

                  puts "created credit"

                  # also, record which credit
                  where(id: commission_q_subset).update_all([
                    'state = ?, updated_at = ?, store_credit_id = ?',
                    'paid',
                    DateTime.current,
                    credit.id
                  ])

                  puts "updated commissions"

                  # query db for next set of IDs
                  commission_q_subset = commission_q.pluck(:id)
                end

                puts "finished member commissions"
              end
              # query the DB for more members, of course assumes state is transitioned,
              # else, this will never end!
              member_ids_subset = member_ids_query.pluck(:user_id)
            end
            raise ArgumentError, "SIMULATE ON" if simulate # roll it back
          end
        rescue
          puts "Simulation end" if simulate
        end

        def summarize
          # ActiveRecord::Base.connection.execute("select SUM(amount) AS total, user_id, GROUP_CONCAT(DISTINCT id SEPARATOR ',') AS comm_id from spree_commissions WHERE state = 'authorized' GROUP BY user_id")

          # https://dba.stackexchange.com/questions/86415/retrieving-n-rows-per-group
          # https://stackoverflow.com/questions/2560946/postgresql-group-concat-equivalent
          
          # https://stackoverflow.com/questions/2129693/using-limit-within-group-by-to-get-n-results-per-group
          # https://stackoverflow.com/questions/27524704/sql-query-to-limit-rows-within-a-group -- no row_number for mysql
        end

        def create_credit(member_id, category_id, credit_type_id, amount, currency)
          store_credit_params = {
            category_id: category_id,
            type_id: credit_type_id,
            user_id: member_id,
            amount: amount,
            created_by: Spree::StoreCredit.default_created_by,
            memo: "From points for the period",
            currency: currency
          }
          credit = Spree::StoreCredit.new(store_credit_params)
          credit.save!
          credit
        end
      end
  	end
  end
end
