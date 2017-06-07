class CustomMailer < ApplicationMailer
	default from: 'notifications@example.com'
 
  def contact(contact)
    @contact = contact
    mail(to: @contact.email, cc: "jatin@maropost.com", subject: 'Thank You ? For visit Maropost Demo')
  end

  def registration(user)
  	@user = user
  	mail(to: @user.email, subject: 'Thank You for registration to Maropost Demo.')
  end
end
