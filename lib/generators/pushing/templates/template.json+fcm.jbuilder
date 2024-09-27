# Usage: rails g pushing:template json+fcm
#
# This will create a template.json+fcm.jbuilder file in your app's lib/generators/pushing/templates directory.
# You can customize this file to change the payload that will be sent to the FCM server.
# The payload will be built using the json object that is passed to the jbuilder template.
#
=begin
Minimum payload sample:
{
  "message":{
    "token":"bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
    "notification":{
      "body":"This is an FCM notification message!",
      "title":"FCM Message"
    }
  }
}
=end

# See https://firebase.google.com/docs/cloud-messaging/send-message or https://github.com/decision-labs/fcm/blob/master/lib/fcm.rb#L20-L48
json.name 'string'

json.data do
  json.something_key 'string'
end

# https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=ja#Notification
json.notification do
  ...
end

# https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=ja#androidconfig
json.android do
  ...
end

# https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=ja#webpushconfig
json.webpush do
  ...
end

# https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=ja#ApnsConfig
json.apns do
  ...
end

# https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=ja#FcmOptions
json.fcm_options do
  ...
end

# Union field target can be only one of the following:
json.token 'string'
json.topic 'string'
json.condition 'string'
# End of list of possible types for union field target
