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
        Write-Output "Installing Active Directory `n"
        installAD
    }elseif ($userinput -eq 2) {
        Write-Output " "
        printIPset
    }elseif ($userinput -eq 3) {
        Write-Output " "
        checkDNSstat
    }elseif ($userinput -eq 4) {
        Write-Output " "
        manageOU
    }elseif ($userinput -eq 5) {
        Write-Output " "
        createUSER
    }elseif ($userinput -eq 6) {
        Write-Output " "
        installRAD
    }else {
        Write-Output "In correct Selection `n"
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

function printIPset {
    Write-Output " The Current IP settings"
    Get-NetIPAddress -AddressFamily IPv4
    manageIP
}
function manageIP {
    $ipOPT = Read-Host "Shall set a Static IP address Y/N?"
    if($ipOPT  -eq "Y"){
        setStaticIP
    }elseif ($ipOPT  -eq "y") {
        setStaticIP
    }elseif($ipOPT  -eq "N"){
        Write-Output "Returning to Main Menu"
        Write-Output " "
        mainmenu
    }elseif ($ipOPT  -eq "n") {
        Write-Output "Returning to Main Menu"
        Write-Output " "
        mainmenu
    }else{
        Write-Output "Incorrect Selection `n"
        manageIP
    }
}
function setStaticIP{
    Write-Output "Enter Static IP:"
    $staticIPadd = Read-Host " "
    Write-Output "Enter Gateway:"
    $gatewayIP = Read-Host " "
    confrimIP
}

function confrimIP {
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
        Write-Output "Incorrect Selection `n"
        confrimIP
    }
}

##############################################################################
# Assign Window Server a DNS          
# set ip address between "" use a , for two addresses                                                            
##############################################################################
function checkDNSstat {
    Write-Output "Checking if DNS Role is currently Installed"
    Get-WindowsFeature | where {($_.name -like "DNS")}
    manageDNS
}
function manageDNS {
    $dnsopt1 = Read-Host "Does DNS need to be installed Y/N "
    if($dnsopt1 -eq "Y"){
        Install-WindowsFeature DNS -IncludeManagementTools
        Write-Output "DNS Server Installed `n "
        mainmenu
    }elseif ($dnsopt1 -eq "y"){
        Install-WindowsFeature DNS -IncludeManagementTools
        Write-Output " DNS Server Installed `n"
        mainmenu
    }elseif ($dnsopt1 -eq "N"){
        currentDNS
    }elseif ($dnsopt1 -eq "n") {
       currentDNS     
    }else {
        Write-Output "Incorrect Selection"
        manageDNS
    }
}

function currentDNS {
    Write-Output "Current DNS Settings "
    Get-DnsClientServerAddress -AddressFamily IPv4 -InterfaceIndex(Get-NetAdapter).InterfaceIndex
    manage2DNS
}
function manage2DNS{
    $dnsopt2 = Read-Host "Shall We Assign a DNS Y/N"
    if($dnsopt2 -eq "Y"){
        setDNS
    }elseif ($dnsopt2 -eq "y") {
        setDNS
    }elseif($dnsopt2 -eq "N"){
        Write-Output "Returning to Main Menu"
        mainmenu
    }elseif ($dnsopt2 -eq "n") {
        Write-Output "Returning to Main Menu"
        mainmenu
    }else{
        Write-Output "Incorrect Selection `n"
        manage2DNS
    }
}
        

function setDNS{

    Write-Output "Please Enter IP Address for DNS"
    $servIP = Read-Host " "
    Write-Output "Please Enter Secondary IP Address for DNS"
    $servIP2 = Read-Host " "
    confirmDNS
}
function confirmDNS {
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
        Write-Output "Incorrect Selection `n"
        confirmDNS
    }
}

##############################################################################
#  Manage OUs                                                                          
##############################################################################
function manageOU {
     Write-Output "Manage Oganizational Units `n"
     Write-Output "1. List Current OUs"
     Write-Output "2. Add OU"
     Write-Output "3. Delete OU"
     Write-Output "4. Return To Main Menu"
     $OUopt = Read-Host "Option "
     if ($OUopt -eq 1){
         Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
         manageOU
     }elseif ($OUopt -eq 2) {
         addOU
     }elseif ($OUopt -eq 3) {
         delOU 
     }elseif ($OUopt -eq 4) {
         mainmenu
     }else{
         Write-Output "Inocrrect Selection"
         manageOU
     }
     
}

function addOU {
    $ouNAME = Read-Host "Enter Organizational Unit Name "
    New-ADOrganizationalunit -Name $ouName
    Get-ADOrganizationalUnit -Identity "OU=$ouName,DC=GlobeXPrimary,DC=Local"
    $ouOPT2 = Read-Host "Would you like to add another Y/N?"
    if ($OUopt2 -eq "Y"){
        addOU
    }elseif ($OUopt2 -eq "y") {
        addOU
    }elseif ($OUopt2 -eq "N") {
        manageOU
    }elseif ($OUopt2 -eq "n") {
       manageOU
    }else{
        Write-Output "Inocrrect Selection"
        manageOU
    }
}

function delOU {
    $ouDEL = Read-Host "Enter Organizational Unit Name "
    Get-ADOrganizationalUnit -Identity "OU=$ouDEL,DC=GlobeXPrimary,DC=Local" | set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false
    Remove-ADOrganizationalunit -Identity "OU=$ouDEL,DC=GlobeXPrimary,DC=Local" -Confirm:$false
    $ouOPT3 = Read-Host "Would you like to Remove another Y/N?"
    if ($OUopt3 -eq "Y"){
        addOU
    }elseif ($OUopt3 -eq "y") {
        addOU
    }elseif ($OUopt3 -eq "N") {
        manageOU
    }elseif ($OUopt3 -eq "n") {
       manageOU
    }else{
        Write-Output "Inocrrect Selection"
        manageOU
    }
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