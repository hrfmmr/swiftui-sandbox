# swift-combine-sandbox

## Set up

### Configure Twitter OAuth Token
twsearch app uses Twitter API and you need to configure api credentials.

Set your [Twitter API's OAuth 2.0 Bearer Token](https://developer.twitter.com/en/docs/authentication/oauth-2-0/application-only) by following command.

```bash
plutil -replace 'twitter_oauth_token' -string '<YOUR_BEARER_TOKEN>' ./twsearch/prefs.plist
```
