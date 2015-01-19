class Cglmailer < ActionMailer::Base
  include MakeXlsx

  default from: AUTO_EMAIL


  def welcome_email(user)
    mail(to: user[:email], cc: ADMIN_EMAIL, subject: "Вы зарегистрированы на сайте #{FIRM_NAME}").deliver
  end

  def docs_email(bill,user)
    mail.attachments[make_file_name(bill)] = File.read(make_url_name(bill))
    mail(to: user[:email], cc: DEPOT_EMAIL, subject: "Накладная No #{make_bill_number(bill)} на получение товара").deliver && File.delete(make_url_name(bill))
  end

end

