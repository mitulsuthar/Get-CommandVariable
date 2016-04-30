# Get-CommandVariable
Gives you a command decorated with $Parameters that it expects. 

###EXAMPLE
```powershell
PS C:\> Get-CommandVariable -CommandName New-AzureRMWebApp

$ResourceGroupName = "" 
$Name = "" 
$Location = "" 

New-AzureRMWebApp  -ResourceGroupName $ResourceGroupName -Name $Name -Location $Location
```
###EXAMPLE 
```powershell
PS C:\>Get-CommandVariable -CommandName New-AzureRmWebApp -ShowAll

$ResourceGroupName = ""
$Name = ""
$Location = ""
$AppServicePlan = ""
$SourceWebApp = ""
$TrafficManagerProfileId = ""
$IgnoreSourceControl = ""
$IgnoreCustomHostNames = ""
$AppSettingsOverrides = ""
$AseName = ""
$AseResourceGroupName = ""
$IncludeSourceWebAppSlots = ""

New-AzureRmWebApp  -ResourceGroupName $ResourceGroupName -Name $Name -Location $Location -AppServicePlan $AppServicePlan -SourceWebApp $SourceWebApp -TrafficManagerProfileId 
$TrafficManagerProfileId -IgnoreSourceControl $IgnoreSourceControl -IgnoreCustomHostNames $IgnoreCustomHostNames -AppSettingsOverrides $AppSettingsOverrides -AseName $AseName -AseResourceGroupName $AseResourceGroupName -IncludeSourceWebAppSlots $IncludeSourceWebAppSlots
```
###EXAMPLE 

```powershell
PS C:\>Get-CommandVariable -CommandName Get-AzureRMVMSize -ListParameterSets
Name                                
----                                
ListVirtualMachineSizeParamSet      
ListAvailableSizesForAvailabilitySet
ListAvailableSizesForVirtualMachine 


PS C:\>Get-CommandVariable -CommandName Get-AzureRMVMSize -ParameterSetName ListAvailableSizesForVirtualMachine
$ResourceGroupName = "" 
$VMName = "" 

Get-AzureRMVMSize  -ResourceGroupName $ResourceGroupName -VMName $VMName
```
###NOTES
Author: Mitul Suthar 
Twitter: @mitulsuthar