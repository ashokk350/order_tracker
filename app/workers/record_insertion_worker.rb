class RecordInsertionWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(table_name, headers, csv_rows)
		return if table_name.blank? || headers.blank? || csv_rows.blank?
	  model = table_name.classify.constantize

		csv_rows = CSV.parse(csv_rows.join, headers: headers)

		# It is preparing array of valid record and import them in bulk.
		csv_rows = if table_name == 'orders'
			map_columns(csv_rows)
		else
		  csv_rows.map do |row|
		  	# Initialize a hash with respective model class and vaidating the initialized record.
		  	record = model.new(row.to_h.transform_keys(&:downcase)) if row
		  	record if record.valid?
		  end
		end

		# Importing records in bulk.
	  model.import(csv_rows.compact, recursive: true)
	end

	def map_columns(csv_rows)
		# Getting email ids and product codes from batch of csv rows
		emails = csv_rows.map { |row| row['USER_EMAIL']}
		product_codes = csv_rows.map { |row| row['PRODUCT_CODE'] }

		# Finding the users and products based on email ids and product codes. 
		users = User.where(email: emails).pluck(:email, :id).to_h
		products = Product.where(code: product_codes).pluck(:code, :id).to_h

		orders = []
		csv_rows.map do |csv_row|
			# Checking user and product should exist in database before creating order and order_details data in database.
			if users[csv_row['USER_EMAIL']] && products[csv_row['PRODUCT_CODE']]
				# Setting up database user id for email mentied in csv_rwo. 
				order = Order.new(user_id:  users[csv_row['USER_EMAIL']], order_date: csv_row['ORDER_DATE'])
				# Setting up database produtct_id for product code mentied in csv_rwo.
				order.order_details.build(product_id: products[csv_row['PRODUCT_CODE']])
				orders << order if order.valid?
			end
		end

		orders
	end
end


