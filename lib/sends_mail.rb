class SendsMail
  def self.mail(message)
    Pony.mail(to: "imtay.wade@gmail.com",
              from: "#{ message.email }",
              body: "#{ message.body }",
              subject: "#{ message.name } has contacted you",
              via: :smtp,
              via_options: {
                address: 'smtp.sendgrid.net',
                port: '587',
                enable_starttls_auto: true,
                user_name: ENV['SENDGRID_USERNAME'],
                password: ENV['SENDGRID_PASSWORD'],
                authentication: :plain,
                domain: ENV['SENDGRID_DOMAIN']
              })
  end
end
