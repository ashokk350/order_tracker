require 'csv'

class CsvGeneratorWorker
	include Sidekiq::Worker
	BATCH_SIZE = 1000

	def perform(user_id)
		sidekiq_tracker = SidekiqTrcker.create(job_id: jid, status: SidekiqTrcker.statuses[:inprogress], worker: self.class.to_s)

		user = User.find_by(id: user_id)
		return unless user

		file_path = Rails.root.join('public', "#{user.username}_orders.csv")
		CSV.open(file_path, 'w') do |csv|
			# Setting up herders(column names) of CSV file.
	    csv << ['USERNAME', 'USER_EMAIL', 'PRODUCT_CODE', 'PRODUCT_NAME', 'PRODUCT_CATEGORY', 'ORDER_DATE']

	    # Finding the orders for user and selecting the required data.
      Order.joins(:user, order_details: :product)
				   .where(user_id: user_id)
           .select('orders.id, users.username, users.email, products.code, products.name, products.category, orders.order_date')
           .find_each(batch_size: BATCH_SIZE) do |record|

        # Setting up value in each row. Value of each column in row should match with the header's column position.
	      csv << [record['username'], record['email'], record['code'], record['name'], record['category'], record['order_date']]
      end
    end

    # Updating the status of sidekiq job if it's completed. to make sure, file is ready for download
    sidekiq_tracker.update(status: SidekiqTrcker.statuses[:completed])
  rescue => e
  	# Updating the status of sidekiq job if it's failed.
  	sidekiq_tracker.update(status: SidekiqTrcker.statuses[:failed])
	end
end