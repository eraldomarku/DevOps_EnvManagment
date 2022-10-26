$action=$args[0]

if($action="stop"){
    # To stop the D365FO environment
    Start-D365Environment -All
}
if($action="start"){
    # To start all D365FO related services again, to make the D365FO environment available again
    Stop-D365Environment -All
}