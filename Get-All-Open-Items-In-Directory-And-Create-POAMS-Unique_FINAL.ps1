## AUTHOR / TIMESTAMP:
## JLD

## PURPOSE:

### THE Purpose of this script is to take all open items from a directory of checklists, and then create an output file that can be copied/pasted into a POAM templated file to create a POAM for all open items.

## HOW TO USE:

## Run this script in a directory of checklists that needs POAMs created. Output file will be created in your chosen destination ($OutputPath)
## Copy everything besides the headers from the output file to a POAM templated file. Re-format POAM file to look nice. Done.


## MAKE CHANGES HERE SECTION ####

$DirectoryofChecklists = "" ## Change this value to the Directory you would like to run this script in. 


$OutputPath = "C:\Temp\" ## Output PATH (do not include filename or .csv extension)


$Outfilename = "Networking.csv"   ## Filename and .csv  IF you are only generating one file (you will be prompted)


## END MAKE CHANGES SECTION ####











$VulnStatus = "Open"




## BEGIN SCRIPT

[string]$ECDDate = (get-date).AddDays(90).ToSTring('MM-dd-yyyy')


cd $DirectoryofChecklists

$Allitems = Get-childitem -Path $DirectoryofChecklists -Filter *.ckl -Name




$NumerousOutput = read-host -prompt "Would you like to create separate POAM files, seperated by type of STIG? Type yes (or y) or no (or n)"

$Allobjects = @()

foreach ($CKL in $Allitems){

write-host -Foregroundcolor Cyan "Working on $CKL..."

[XML]$CKLdata = Get-Content $CKL # Convert file to XML object



$Eachvuln = $CKLData.Checklist.STIGs.iSTIG.VULN ## Grab each vulnerability from XML .ckl file and store in variable. We do this so we can access the 'Status' property to determine Open items.

foreach ($Diffvuln in $Eachvuln){

if ($Diffvuln.Status -eq $VulnStatus){

$Newestvuln = $Diffvuln ## Save the 'Open' items to a new variable name

$Childnodes = $NewestVuln.ChildNodes  ## Declare child nodes variable, this picks up all of the child nodes to the individual vulnerability item ($Newestvuln)

$RuleID = $Childnodes.item(3).Attribute_Data ## Access each childnode item's value with the index of the item #
$Vuln_Num = $Childnodes.item(0).Attribute_Data
$Severity = $Childnodes.item(1).Attribute_Data
$STIGRef = $Childnodes.item(22).Attribute_Data
$RuleTitle = $Childnodes.item(5).Attribute_data
$Vulndiscuss = $Childnodes.item(6).Attribute_data
$CCIRef = $Childnodes.item(27).Attribute_data


if ($Severity -match "High"){
$RawSevere = "I"
$ImpactSevere = "High"
}

if ($Severity -match "Medium"){
$RawSevere = "II"
$ImpactSevere = "Moderate"
}

if ($Severity -match "Low"){
$RawSevere = "III"
$ImpactSevere = "Low"
}




$Allobjects += New-Object PSObject -Property @{

CVD = $RuleTitle
SCN = $CCIRef
Office = ""
Security = $RuleID
Resources = ""
Scheduled = $ECDDate
Milestone = "Researching Vulnerability. ECD $ECDDate"
MilestoneTwo = ""
Source = $STIGRef
Status = "On-going"
Comment = "Researching impact from remediating vulnerability"
RawSeverity = $RawSevere
Mitigation = ""
Severity = $ImpactSevere
Relevance = $ImpactSevere
Likelihood = $ImpactSevere
Impact = $ImpactSevere
ImpactDesc = $Vulndiscuss
ResidRisk = $ImpactSevere


} ## end property builder object




} ## end if status equals open

} ## end inner foreach




}





# $AllObjects | Select-Object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk | sort-object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk | Export-csv -Path $FinalDestination -Append -NoTypeInformation

  ## end foreach different checklist



if ($NumerousOutput -match "Yes" -or $NumerousOutput -match "y"){

$StigFormat = $Stigref.Replace(" ", "")
$StigFormat1 = $StigFormat.Replace("/", "")
$StigFormat2 = $StigFormat1.Replace("(", "")
$StigFormat3 = $StigFormat2.Replace(")", "")
$StigFormat4 = $Stigformat3.Replace(":", "")
$StigFormat5 = $Stigformat4.Replace("ersion", "")
$Stigformat6 = $Stigformat5.Replace("elease", "")
$Stigformat7 = $Stigformat6.Replace(",", "")

$FinalDestination = $OutputPath + "POAM_" + $Stigformat7 + ".csv"


$AllObjects | Group-Object -Property Source | Foreach-Object {



$path = $OutputPath + "\" + "POAM-" + $_.name.Replace(":", "").Replace("/", "") + ".csv" 

$_.group | Sort-Object -Unique CVD | Select-Object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk | sort-object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk |  Export-Csv -Path $path -NoTypeInformation -Append


}

}




if ($NumerousOutput -match "No" -or $NumerousOutput -match "n"){

$FinalDestination = $OutputPath + "\" + $Outfilename


$AllObjects | Sort-Object -Unique CVD | Select-Object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk | sort-object -Property CVD, SCN, Office, Security, Resources, Scheduled, Milestone, MilestoneTwo, Source, status, Comment, RawSeverity, Mitigation, Severity, Relevance, Likelihood, Impact, ImpactDesc, ResidRisk | Export-csv -Path $FinalDestination -Append -NoTypeInformation

}
