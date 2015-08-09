# Uploading to S3 Client Side

This is an experiment trying to upload a base64 image (from a canvas) to S3.
It uses rails to create the presigned url and a simple XMLHttpRequest to send the image to S3 without using the server (saves some server memory :3)

Really cool example for uploading assets from Angular/Ember/Any client-side framework

### Setup
Create an config/application.yml file based on the sample provided within that folder, with your S3 credentials.
Then just run `bundle install` and `rails server`.

### Files to notice
Logic and stuff can be found here:

```
config/initializers/aws.rb
app/helpers/s3_helper.rb
app/services/s3_signer.rb
app/views/uploads/index.html.erb
app/assets/javascript/uploads.js.erb
```

Feel free to contribute with new issues/pull requests :)
