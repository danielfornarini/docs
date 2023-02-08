if defined?(ActionMailer)
  module MailerHelpers
    def find_mail_to(email)
      ActionMailer::Base.deliveries.find { |mail|
        mail.to.include?(email)
      }
    end
  end
end
