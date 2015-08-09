class S3Signer
  def initialize(options)
    @key_starts_with = options[:key_starts_with] || "uploads/"
    @options = options.reverse_merge(
      aws_access_key_id: AWS.config.access_key_id,
      aws_secret_access_key: AWS.config.secret_access_key,
      bucket: options[:bucket] || ENV['AWS_BUCKET'],
      ssl: true,
      acl: "public-read",
      expiration: 10.hours.from_now.utc.iso8601,
      max_file_size: 500.megabytes,
      key_starts_with: @key_starts_with,
      key: key
    )
  end

  def fields
    {
      "key" => @options[:key] || key,
      "acl" => @options[:acl],
      "AWSAccessKeyId" => @options[:aws_access_key_id],
      "policy" => policy,
      "signature" => signature,
      "success_action_status" => "201",
      'X-Requested-With' => 'xhr',
      "Content-type" => ""
    }
  end

  def key
    timestamp = Time.now.to_i
    @key ||= "#{@key_starts_with}#{timestamp}-#{SecureRandom.hex}/${filename}"
  end

  def policy
    Base64.encode64(policy_data.to_json).gsub("\n", "")
  end

  def policy_data
    {
      expiration: @options[:expiration],
      conditions: [
        ["starts-with", "$key", @options[:key_starts_with]],
        ["starts-with", "$x-requested-with", ""],
        ["content-length-range", 0, @options[:max_file_size]],
        ["starts-with","$content-type", @options[:content_type_starts_with] ||""],
        {bucket: @options[:bucket]},
        {acl: @options[:acl]},
        {success_action_status: "201"}
      ] + (@options[:conditions] || [])
    }
  end

  def signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        @options[:aws_secret_access_key], policy
      )
    ).gsub("\n", "")
  end
end
