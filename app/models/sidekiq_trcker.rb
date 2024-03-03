class SidekiqTrcker < ApplicationRecord
	validates :job_id, presence: true

	enum status: %i[inprogress completed failed]
end
