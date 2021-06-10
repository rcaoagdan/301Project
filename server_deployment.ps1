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

##############################################################################
# Assign Windows Server Static IPv4 Address                                                                         
##############################################################################


##############################################################################
# Assign Windows Server VM a DNS                                                                           
##############################################################################


##############################################################################
# Rename Windows Server                                                                           
##############################################################################


##############################################################################
# Install AD Domain-Services        
# Add Domain Controller
# Add AD Forest                                                                   
##############################################################################

Install-WindowsFeature AD-Domain-Services
ADD-WindowsFeature RSAT-Role-Tools
ADD-WindowsFeature gpmc
Import-Module ADDSDeployment
Install-ADDSForest `
-DomainName "corp.GlobeXPrimary.local" `
-DomainNetbiosName "GlobeXPrimary" `
-SafeModeAdministratorPassword $pass`
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

##############################################################################
#  Create OUs                                                                          
##############################################################################


##############################################################################
#  Add Users                                                                           
##############################################################################


##############################################################################
# RADIUS                                                                        
##############################################################################


##############################################################################
#  Main                                                                          
##############################################################################


##############################################################################
#  End                                                                        
##############################################################################