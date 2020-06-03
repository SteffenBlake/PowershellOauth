<# Include statements for .net Assemblies #>
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Runtime

<# Example here is for the Google v2 OAuth #>
$oAuthBaseUrl = "https://accounts.google.com/o/oauth2/v2/auth"
$client_id = "<YOUR CLIENT ID HERE, REMEMBER TO NEVER SHARE THIS PUBLICLY>"

<# The return URL + Port we will listen on #>
$redirect_uri = "http://localhost:8080/"

<# Feel free to customize your html response here #>
<# TODO: Support a simple HTML file you can edit and then serialize here #>
$webPageResponse = "<html><body>You can now close this page!</body></html>"

<# Encode and calc the length for use later #>
$webPageResponseEncoded =  [System.Text.Encoding]::UTF8.GetBytes($webPageResponse)
$webPageResponseLength = $webPageResponseEncoded.Length

<# Start up our lightweight HTTP Listener for the OAuth Response #>
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($redirect_uri)
$listener.Start()

<# Build our OAuth Query string #>
$uri = New-Object System.UriBuilder -ArgumentList $oAuthBaseUrl
$query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)

$query["client_id"] = $client_id
$query["redirect_uri"] = $redirect_uri

<# Customize values here for your OAuth of choice, in this case these are Google OAuth values #>
$query["response_type"] = "code"
$query["scope"] = "profile email"
$query["prompt"] = "select_account"

$uri.Query = $query.ToString()

<# Open up the browser for the User to OAuth in #>
Start $uri.Uri

<# Waits for a response from the OAuth website#>
$context = $listener.getContext()

<# You can fetch any other necessary response values here #>
$code = $context.Request.QueryString["code"]

<# Write out our landing page for the user #>
$response = $context.response
$response.ContentLength64 = $webPageResponseLength
$response.OutputStream.Write($webPageResponseEncoded, 0, $webPageResponseLength)
$response.OutputStream.Close()

<# Close the HTTP Listener #>
$listener.Stop()


<# And viola! We now have our OAuth code for use on the API of choice #>
$code

<# YOUR CODE HERE #>