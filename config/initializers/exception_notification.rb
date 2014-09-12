if Rails.env == 'production' || Rails.env == 'staging'|| Rails.env == 'development'

  exceptions = []
  exceptions << 'ActiveRecord::RecordNotFound'
  # exceptions << 'AbstractController::ActionNotFound'
  # exceptions << 'ActionController::RoutingError'
  exceptions << 'ActionController::InvalidAuthenticityToken'

  server_name = case Rails.env
                  when 'production'     then SITE_NAME
                  when 'staging'        then 'staging.'+SITE_NAME
                  when 'development'    then 'development-'+SITE_NAME
                  else
                    'unknown env '+SITE_NAME
                end

  Cgl::Application.config.middleware.use ExceptionNotification::Rack,
       email: {
           email_prefix:   "[#{server_name} error] ",
           sender_address: AUTO_EMAIL,
           exception_recipients: [ADMIN_EMAIL]
       },
       ignore_exceptions: exceptions
end