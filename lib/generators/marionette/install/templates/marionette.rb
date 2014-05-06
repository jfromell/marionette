<%= rails_application_name %>::Application.configure do
  config.marionette = {}

  config.marionette[:app_name] = '<%= suggested_app_name &>'
end