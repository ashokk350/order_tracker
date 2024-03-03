class CreateSidekiqTrckers < ActiveRecord::Migration[6.1]
  def change
    create_table :sidekiq_trckers do |t|
      t.string :job_id
      t.integer :status
      t.string :worker

      t.timestamps
    end
  end
end
