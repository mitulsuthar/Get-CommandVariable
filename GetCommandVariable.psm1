<#

.SYNOPSIS

Gives you a command decorated with $Parameters that it expects. 

.DESCRIPTION

The Get-CommandVariable command will generate the command using auto generated variables. 

.PARAMETER CommandName 

A single command for which you want to have $variables generated. 

.PARAMETER ListParameterSets

A PowerShell command can have multiple ParameterSet. 

ListParameterSets displays all the ParameterSets for a given command.

.PARAMETER ParameterSetName

To generate variables for a command for a given ParameterSet provide ParameterSetName as a string parameter. 

Use ListParameterSets to view available ParameterSets.

.PARAMETER ShowAll 

By default ShowAll parameter is false. ShowAll will generate variables for all the parameters except commonparameters. 

ShowAll=$false will generate variables for all the mandatory parameters.

.EXAMPLE

PS C:\> Get-CommandVariable -CommandName New-AzureRMWebApp

$ResourceGroupName = "" 
$Name = "" 
$Location = "" 

New-AzureRMWebApp  -ResourceGroupName $ResourceGroupName -Name $Name -Location $Location

.EXAMPLE 

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

.EXAMPLE 

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

.NOTES
Author: Mitul Suthar 
Twitter: @mitulsuthar

#>
Function Get-CommandVariable{
[cmdletbinding()]
Param
  (
     [parameter(Mandatory=$true)]
     [string]$CommandName,          
     [Switch]$ListParameterSets,
     [String]$ParameterSetName,
     [Switch]$ShowAll = $false
  )
$cmdObject = Get-Command -Name $CommandName
if([string]::IsNullOrEmpty($Prefix)){
   $Prefix = "" #Set Default Prefix here.
}
if($ListParameterSets)
{
    $cmdObject.ParameterSets | Select Name 
    return
}
function get-outputbyParameterSet{
    [cmdletbinding()]
    param(
        [string]$customparameterSetName
    )
    [string]$outputString
    [string]$outparameterString
    write-verbose "$customparameterSetName was selected" 
    $selectedParameterSet = $cmdObject.ParameterSets | ? { $_.Name -eq $customparameterSetName}    
    foreach($parameter in $selectedParameterSet[0].Parameters){
            if($ShowAll -eq $false){
               if($parameter.IsMandatory){
                   Write-Verbose "Generates variables for only mandatory parameters"                             
                   $parameterVariableName = [string]::Format("`${0}{1}",$Prefix, $parameter.Name)
                   $outparameterString += [string]::Format("{0} = `"`" {1}",$parameterVariableName,[Environment]::NewLine)
                   $outputString =  [System.string]::Format("{0} -{1} {2}",$outputString,$parameter.Name, $parameterVariableName)           
               }
            }else{
               if("ErrorAction","WarningAction","InformationAction","Verbose","Debug","ErrorVariable","WarningVariable","InformationVariable","OutVariable","OutBuffer","PipelineVariable" -notcontains $parameter.Name){               
               $parameterVariableName = [string]::Format("`${0}{1}",$Prefix, $parameter.Name)
               $outparameterString += [string]::Format("{0} = `"`" {1}",$parameterVariableName,[Environment]::NewLine)
               $outputString =  [System.string]::Format("{0} -{1} {2}",$outputString,$parameter.Name, $parameterVariableName)         
               }
            }
    }
    $outputString = [string]::Format("{0} {1}",$commandName,$outputString)
    write-host $outparameterString
    write-host $outputString
}
if(![String]::IsNullOrEmpty($ParameterSetName)){    
    get-outputbyParameterSet -customparameterSetName $ParameterSetName 
}else{
    Write-Verbose "Generating variables for DefaultParameterSet"
    if($cmdObject.DefaultParameterSet -eq $null){
      Write-Verbose "DefaultParameterSet property is null"
      $defaultParameterSetName =  $cmdObject.ParameterSets[0].Name
    }else{
    $defaultParameterSetName = $cmdObject.DefaultParameterSet
    }    
    get-outputbyParameterSet -customparameterSetName $defaultParameterSetName    
}
}
Export-ModuleMember Get-CommandVariable