# PowershellOauth
An extremely simple lightweight standalone Powershell script that lets you perform OAuth in the command line

Full script can be found [here](https://github.com/SteffenBlake/PowershellOauth/blob/master/OAUTH.ps1)

* Supports automatically opening the browser for the user to log in
* Uses the net core System.Net.HttpListener, which should be supported on any Windows 10 PC thats moderately up to date
* Doesnt require downloading or installing any third party tools or extra libraries, runs completely standalone purely off Powershell

## Future supports:
* Add support to Auto-Close browser after 5 seconds
* Add support for a customizable simple .html file for the landing page, so it looks pretty
* Add support for logging the OAuth code to a local file, so we can check if we already have OAuth done and dont repeatedly prompt the user everytime
