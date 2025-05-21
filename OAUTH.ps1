<# Include statements for .net Assemblies #>
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Runtime

$appSettings = Get-Content "AppSettings.json" | ConvertFrom-Json

if (-Not (Test-Path $appSettings.Secrets)) {
    $secretsDir = $appSettings.Secrets | split-path -Parent
    $secretsFile = $appSettings.Secrets | split-path -Leaf
    <# Check if parent directory exists first before making our secrets file #>
    if (-Not (Test-Path $secretsDir)) { 
        New-Item -Path $secretsDir -ItemType "directory"
    }

    <# Create our template secrets file #>
    New-Item -Path $secretsDir -Name $secretsFile -ItemType "file" -Value (@{client_id = ""; client_secret=""; } | ConvertTo-Json)

    "No Secrets file found, automatically created a new one at the path. Please fill out it with proper info before proceeding!"
    Start-Process $appSettings.Secrets
    exit 1
}

$secrets = Get-Content $appSettings.Secrets | ConvertFrom-Json
$client_id = $secrets.client_id.Trim();
$client_secret = $secrets.client_secret.Trim();

if ([string]::IsNullOrEmpty($client_id) -or [string]::IsNullOrEmpty($client_secret)) {
    "Secret values need to be filled out before running, please double check your Client Id and your Client Secret"
    Start-Process $appSettings.Secrets
    exit 1
}

$code = ""

<#  Check if we have the OAuth Code saved already, if not, fetch it
    If $appSettings.Code is empty, the OAuth Code will be requested every time #>
if (($appSettings.Code -Ne "") -And (Test-Path $appSettings.Code)) {
    $code = Get-Content $appSettings.Code
} else {
    $webPageResponse = Get-Content $appSettings.Listener.LandingPage

    <# Encode and calc the length for use later #>
    $webPageResponseEncoded =  [System.Text.Encoding]::UTF8.GetBytes($webPageResponse)
    $webPageResponseLength = $webPageResponseEncoded.Length

    <# Start up our lightweight HTTP Listener for the OAuth Response #>
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($appSettings.Listener.RedirectURL)
    $listener.Start()

    <# Build our OAuth Query string #>
    $uri = New-Object System.UriBuilder -ArgumentList $appSettings.OAuth.BaseUrl
    $query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)

    $query["client_id"] = $client_id
    $query["redirect_uri"] = $appSettings.Listener.RedirectURL

    <# Customize values here for your OAuth of choice #>
    foreach ($additionalValue in $appSettings.OauthValues.PSObject.Properties){
        $query[$additionalValue.Name] = $additionalValue.Value
    }

    $uri.Query = $query.ToString()

    <# Open up the browser for the User to OAuth in #>
    Start-Process $uri.Uri

    <# Waits for a response from the OAuth website#>
    $context = $listener.getContext()

    <# You can fetch any other necessary response values here #>
    $code = $context.Request.QueryString["code"]

    <# Write out our landing page for the user #>
    $response = $context.response
    $response.ContentLength64 = $webPageResponseLength
    $response.ContentType = "text/html; charset=UTF-8"
    $response.OutputStream.Write($webPageResponseEncoded, 0, $webPageResponseLength)
    $response.OutputStream.Close()

    <# Close the HTTP Listener #>
    $listener.Stop()

    if ($appSettings.Code -Ne "") {
        $codeDir = $appSettings.Code | split-path -Parent
        $codeFile = $appSettings.Code | split-path -Leaf
        <# Check if parent directory exists first before making our secrets file #>
        if (-Not (Test-Path $codeDir)) { 
            New-Item -Path $codeDir -ItemType "directory"
        }

        <# Create our code file and cache the code for future runs#>
        New-Item -Path $codeDir -Name $codeFile -ItemType "file" -Value $code
    }
}

<# And viola! We now have our OAuth code for use on the API of choice #>
$code

<# YOUR SCRIPT HERE #>