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
    Write-Output "4. Add OU"
    Write-Output "5. Create Users"
    Write-Output "6. Install RADIUS"
    $userinput = Read-Host "Option"

    if($userinput -eq 1){
        installAD
    }elseif ($userinput -eq 2) {
        setStatic
    }elseif ($userinput -eq 3) {
        optDNS
    }elseif ($userinput -eq 4) {
        createOU
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
function setStatic {
    New-NetIPAddress -IPAddress "" -PrefixLength 24 -DefaultGateway "" -InterfaceIndex(Get-NetAdapter).InterfaceIndex
}

##############################################################################
# Assign Window Server a DNS          
# set ip address between "" use a , for two addresses                                                            
##############################################################################
function optDNS {
    Write-Output "Checking if DNS Role is currently Installed"
    Get-WindowsFeature | where {($_.name -like "DNS")}
    $dnsopt1 = Read-Host "Does DNS need to be installed Y/N"
    if($dnsopt1 -eq "Y"){
        Install-WindowsFeature DNS -IncludeManagementTools
    }elseif ($dnsopt1 -eq "y"){
        Install-WindowsFeature DNS -IncludeManagementTools
    }elseif ($dnsopt1 -eq "N"){
        opt2DNS
    }elseif ($dnsopt1 -eq "n") {
        opt2DNS
    }else {
        Write-Output "Incorrect Selection"
        Write-Output " "
        optDNS
    }
}

function opt2DNS{
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
        opt2DNS
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
        setDNS
    }
}
##############################################################################
#  Create OUs                                                                          
##############################################################################
function createOU {
     
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