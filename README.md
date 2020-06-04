# PowershellOauth
An extremely simple lightweight standalone Powershell script that lets you perform OAuth in the command line

Full script can be found [here](https://github.com/SteffenBlake/PowershellOauth/blob/master/OAUTH.ps1)

* Supports automatically opening the browser for the user to log in
* Uses the net core System.Net.HttpListener, which should be supported on any Windows 10 PC thats moderately up to date
* Doesnt require downloading or installing any third party tools or extra libraries, runs completely standalone purely off Powershell
* Configuration performed via a secondary AppSettings.json file, easy to configure!
* Secrets are stored in a seperate Secrets.json file, so you are less likely to accidently commit secrets to github!
* Caches the OAuth code so it wont open a browser every single time you run it!
* Customizable html landing page!

## Support Checklist:
- [x] ~~Add support to Auto-Close browser after 5 seconds~~  (Not supported by browsers anymore!)
- [x] Add support for a customizable simple .html file for the landing page
- [x] Add support for caching the OAuth Code
- [x] Move configuration to a json file
- [x] Support loading a Secrets.json file
- [ ] More to come? (Open to suggestions!)

