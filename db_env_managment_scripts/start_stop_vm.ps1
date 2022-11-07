
param ($command, $client_id, $client_secret, $username, $password, $ProjectId, $EnvironmentId)

$url="https://login.microsoftonline.com/common/oauth2/token"

$body = @{
    grant_type='password'
    client_id=$client_id
    client_secret=$client_secret
    resource='https://lcsapi.lcs.dynamics.com'
    username=$username
    password=$password
}

$contentType = 'application/x-www-form-urlencoded'

$tokenResponse = Invoke-RestMethod -Method 'POST' -Uri $url -Body $body -ContentType $contentType
$BearerToken = $tokenResponse.access_token

if($command -eq "stop"){
    # To stop the D365FO environment
    Invoke-D365LcsEnvironmentStop -ProjectId $ProjectId -EnvironmentId $EnvironmentId -BearerToken $BearerToken -LcsApiUri "https://lcsapi.lcs.dynamics.com"
}
if($command -eq "start"){
    # To start vm
    Invoke-D365LcsEnvironmentStart -ProjectId $ProjectId -EnvironmentId $EnvironmentId -BearerToken $BearerToken -LcsApiUri "https://lcsapi.lcs.dynamics.com"
}