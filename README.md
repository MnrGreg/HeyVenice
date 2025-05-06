## Venice AI Shortcut
  - A powerful, private, uncensored voice assistant using Venice AI

### Quick Install

1. Download the shortcut version from the link below 
2. Open the shortcut and allow access to api.venice.ai
3. To quickly launch the shortcut, press the side button and say "Hey Venice" instead of "Hey Siri"
4. To have Hey Venice always respond aloud, set Settings > Siri > Siri Responses to "Prefer Spoken Responses"


### Verify shortcut source code
  - Don't blindy install shortcuts from untrusted sources. First verify the shortcut source code.

1. Run `shortcut-extractor.sh https://www.icloud.com/shortcuts/<shortcut-id>` to download the shortcut source code from the Apple
2. Compare the downloaded Apple shortcut with the source in this repo `diff -r Hey_Venice.xml "Hey Venice.xml"`


### Changelog

Version 0.0.3 - https://www.icloud.com/shortcuts/ca97a9f44aaa4fe2886b7091a7f7e303
- changed default model to venice-uncensored [Dolphin Mistral 24B Venice Edition]
- fixed followup question duplication on Apple Watch
- toggle websearch with “on|off|auto” default is on

Version 0.0.2 - https://www.icloud.com/shortcuts/44a6eb44936d4cd4a35c47a81b0aa12f
- updated model to deepseek-r1-671b
- fixed followup question processing bugs
- reduced prompt pause from 2 seconds to 1 second
- text is used for input and response unless voice is used to start the shortcut

Version 0.0.1
- using model deepseek-r1-llama-70b
