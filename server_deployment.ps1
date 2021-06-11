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
    Write-Output "1. Install Active Directory - Adds DC, Forest, Rename Server, Install DNS Server"
    Write-Output "2. Change Static IP Address"
    Write-Output "3. Assign DNS"
    Write-Output "4. Add OU"
    Write-Output "5. Create Users"
    Write-Output "6. Install RADIUS"
    $userinput = Read-Host "Option:"

    if($userinput -eq 1){
        installAD
    }elseif ($userinput -eq 2) {
        setStatic
    }elseif ($userinput -eq 3) {
        setDNS
    }elseif ($userinput -eq 4) {
        createOU
    }elseif ($userinput -eq 5) {
        createUSER
    }elseif ($userinput -eq 6) {
        installRAD
    }else {
        echo "In correct Selection"
        mainmenu
    }
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
function setDNS {
    Set-DnsClientServerAddress -InterfaceIndex(Get-NetAdapter).InterfaceIndex -ServerAddresses "" 
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
    Install-ADDSForest -DomainName GlobeXPrimary.local -DomainNetbiosName GlobeXPrimary -IntallDNS
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