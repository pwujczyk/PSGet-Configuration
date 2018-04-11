#
# Module manifest for module 'module'
#
# Generated by: pwujczyk
#
# Generated on: 3/8/2018 8:08:43 PM
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Get-Configuration.psm1'

# Version number of this module.
ModuleVersion = '0.0.7'

# ID used to uniquely identify this module
GUID = '323f8f7c-12a7-48d6-9324-1e6a1631646f'

# Author of this module
Author = 'Paweł Wujczyk'

# Description of the functionality provided by this module
Description = 'Module expose methods to get and set configuration in key-value format. It allows to store information in XML or in SQL (still in testing phase)'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('SQLCommands')

# Functions to export from this module
FunctionsToExport = @('Get-Configuration','Set-Configuration','Set-ConfigurationSqlSource','Set-ConfigurationXmlSource','Get-ConfigurationSource','Clear-Configuration')

# HelpInfo URI of this module
HelpInfoURI = 'http://www.productivitytools.tech/powershell-configuration/'

PrivateData = @{
    
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Configuration','SQL', "XML", "Key", "Value")
    
        # A URL to the main website for this project.
        ProjectUri = 'http://www.productivitytools.tech/powershell-configuration/'
    
            } # End of PSData hashtable
    } # End of PrivateData hashtable   
}
