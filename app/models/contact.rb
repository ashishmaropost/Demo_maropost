class Contact < ApplicationRecord
	validates :email, email_format: { message: "doesn't look like an email address" }
	validates :mobile_number, :presence => true,
                 :numericality => true,
                 :length => { :minimum => 7, :maximum => 10 }
end
