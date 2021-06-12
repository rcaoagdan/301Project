##############################################################################
#                       Windows Server Deployment                            #
##############################################################################
# Purpose : Automate a new installation of Windows Server, fully standsup all
#   requisites to mkae the server into a Domain Controler. The Script should: 
#   -Assigns the Windows Server VM a static IPv4 address
#   -Assigns the Windows Server VM a DNS
#   -Renames the Windows Server VM
#   -Installs AD-Domain-Services
#   -Creates an AD Forest
#   -Creates Organizational Units (OU)
#   -Creates users
#   -RADIUS

######################################################################################################
# main menu                                                                   
########################################################################################################
function mainmenu {
    Write-Output "Select Option below:"
    Write-Output "1. Install Active Directory - Adds DC, Forest, Rename Server"
    Write-Output "2. Change Static IP Address"
    Write-Output "3. Manage DNS"
    Write-Output "4. Manage Organizational Unit"
    Write-Output "5. Mange Users"
    Write-Output "6. Install RADIUS"
    $userinput = Read-Host "Option"

    if($userinput -eq 1){
        installAD
    }elseif ($userinput -eq 2) {
        setStaticIP
    }elseif ($userinput -eq 3) {
        manageDNS
    }elseif ($userinput -eq 4) {
        manageOU
    }elseif ($userinput -eq 5) {
        createUSER
    }elseif ($userinput -eq 6) {
        installRAD
    }else {
        Write-Output "In correct Selection"
        mainmenu
    }
}

##############################################################################
# Install AD Domain-Services        
# Add Domain Controller
# Add AD Forest        
# Renames Server   
##############################################################################
function installAD {

    Get-WindowsFeature -Name AD-Domain-Services | Install-WindowsFeature
    Import-Module ADDSDeployment
    Install-ADDSForest -DomainName GlobeXPrimary.local -DomainNetbiosName GlobeXPrimary 

}


##############################################################################
# Assign Windows Server Static IPv4 Address   
# Insert IP addressess where ""                                                                     
##############################################################################
function setStaticIP{

    Write-Output "Enter Static IP:"
    $staticIPadd = Read-Host " "
    Write-Output "Enter Gateway:"
    $gatewayIP = Read-Host " "
    Write-Output " The Static IP is : $staticIPadd and the Gateway : $gatewayIP"
    $statConfirm = Read-Host "Confirm Y/N | M for main menu"
    if($statConfirm -eq "Y"){
        New-NetIPAddress -IPAddress "$staticIPadd" -PrefixLength 24 -DefaultGateway "$gatewayIP" -InterfaceIndex(Get-NetAdapter).InterfaceIndex
    }elseif ($statConfirm -eq "y") {
        New-NetIPAddress -IPAddress "$staticIPadd" -PrefixLength 24 -DefaultGateway "$gatewayIP" -InterfaceIndex(Get-NetAdapter).InterfaceIndex
    }elseif ($statConfirm -eq "N") {
        setStaticIP
    }elseif ($statConfirm -eq "n") {
        setStaticIP
    }elseif ($statConfirm -eq "M") {
        mainmenu
    }elseif ($statConfirm -eq "m") {
        mainmenu
    }else {
        Write-Output "Incorrect Selection"
        Write-Output " "
        setStaticIP
    }
    
}


##############################################################################
# Assign Window Server a DNS          
# set ip address between "" use a , for two addresses                                                            
##############################################################################
function manageDNS {

    Write-Output "Checking if DNS Role is currently Installed"
    Get-WindowsFeature | where {($_.name -like "DNS")}
    $dnsopt1 = Read-Host "Does DNS need to be installed Y/N | M for main menu"
    if($dnsopt1 -eq "Y"){
        Install-WindowsFeature DNS -IncludeManagementTools
        Write-Output " "
        manageDNS
    }elseif ($dnsopt1 -eq "y"){
        Install-WindowsFeature DNS -IncludeManagementTools
        Write-Output " "
        manageDNS
    }elseif ($dnsopt1 -eq "N"){
        manage2DNS
    }elseif ($dnsopt1 -eq "n") {
        manage2DNS
    }elseif ($dnsopt1 -eq "M") {
        mainmenu
    }elseif ($dnsopt1 -eq "m") {
        mainmenu
    }else {
        Write-Output "Incorrect Selection"
        Write-Output " "
        dnsMainreturn
    }
}

function manage2DNS{

    $dnsopt2 = Read-Host "Shall We Assign a DNS Y/N"
    if($dnsopt2 -eq "Y"){
        setDNS
    }elseif ($dnsopt2 -eq "y") {
        setDNS
    }elseif($dnsopt2 -eq "N"){
        Write-Output "Returning to Main Menu"
        Write-Output " "
        mainmenu
    }elseif ($dnsopt2 -eq "n") {
        Write-Output "Returning to Main Menu"
        Write-Output " "
        mainmenu
    }else{
        Write-Output "Incorrect Selection"
        Write-Output " "
        dnsMainreturn
    }
}
        

function setDNS{

    Write-Output "Please Enter IP Address for DNS"
    $servIP = Read-Host " "
    Write-Output "Please Enter Secondary IP Address for DNS"
    $servIP2 = Read-Host " "
    Write-Output "$servIP & $servIP2 will be set for DNS"
    $dnsopt3 = Read-Host "Confirm Y/N"
    if ($dnsopt3 -eq "Y") {
        Set-DnsClientServerAddress -InterfaceIndex(Get-NetAdapter).InterfaceIndex -ServerAddresses "$servIP,$servIP2" -PassThru 
    }elseif ($dnsopt3 -eq "y") {
        Set-DnsClientServerAddress -InterfaceIndex(Get-NetAdapter).InterfaceIndex -ServerAddresses "$servIP,$servIP2" -PassThru 
    }elseif ($dnsopt3 -eq "N") {
        setDNS
    }elseif ($dnsopt3 -eq "n") {
        setDNS
    }else{
        Write-Output "Incorrect Selection"
        Write-Output " "
        dnsMainreturn
}

function dnsMainreturn {
    $dnsReturn = Read-Host "Do you want to return to main menu Y/N?"
    if ($dnsReturn -eq "Y") {
        mainmenu
    }elseif ($dnsReturn -eq "y") {
        mainmenu
    }elseif ($dnsReturn -eq "N") {
        manageDNS
    }elseif ($dnsReturn -eq "n") {
        manageDNS
    }else {
        Write-Output "Incorrect selection"
        Write-Output " "
        dnsMainreturn
    }
    
}
}
##############################################################################
#  Create OUs                                                                          
##############################################################################
function manageOU {
     Write-Output "Hello "
     Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
}


##############################################################################
#  Add Users                                                                           
##############################################################################
function createUSER {

}

##############################################################################
# RADIUS                                                                        
##############################################################################
function installRAD {

}

##############################################################################
#  Main                                                                          
##############################################################################
mainmenu
##############################################################################
#  End                                                                        
##############################################################################