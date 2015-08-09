module S3Helper
  def s3_uploader_form(options = {})
    uploader = S3Signer.new(options)
    content_tag(:form, class: 's3_form_data', id: 'signed_s3') do
      uploader.fields.map do |name, value|
        hidden_field_tag(name, value)
      end.join.html_safe
    end
  end

  def s3_bucket_url ssl = true
    "http#{ssl ? 's' : ''}://s3.amazonaws.com/#{ENV['AWS_BUCKET']}/"
  end
end
