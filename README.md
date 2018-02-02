# What does this do?

This script installs the recently released & stable versions of rubies including all their fix versions from the ruby community. The number of recent versions can be optionally provided in the argumen to this scripts, otherwise, the number of recent versions defaults to 2

# Why do I need this?

This script is mostly required in production environments of rails applications to maintain a limited set of recent versions of rubies at a given time. This is to promote teams to use only the latest versions of rubies when they are building their application on Jenkins or Spork

# How do I make use of this?

For now, put this script in your <YOUR_APPLICATION>_chef-repo/files/ and call this script with `ruby <YOUR_APPLICATION>_chef-repo/files/recent_rubies.rb <NO_OF_RECENT_VERSIONS>`. This will install, suppose for <NO_OF_RECENT_VERSIONS> = 2:
``` ruby
# rubies
=> ["2.5.0", "2.4.3", "2.4.2", "2.4.1", "2.4.0"]
```
