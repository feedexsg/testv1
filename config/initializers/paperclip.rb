Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = "images/#{Rails.env}/:class/:id.:style.:extension"
