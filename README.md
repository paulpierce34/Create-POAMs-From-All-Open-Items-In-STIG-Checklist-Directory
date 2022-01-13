# Create-POAMs-From-All-Open-Items-In-STIG-Checklist-Directory
This script is used to pull all of the open items from every STIG checklist in a directory, and output them to a DFARS compliant templated POA&M (Plan of Action and Milestone) .csv file

REQUIREMENTS:
- STIG .ckl files (preferably more recent than not)
- Powershell

HOW TO USE:
- Open script in Powershell ISE
- Supply the following values in the 'Make Changes Here' section:

1.) Directory of STIG checklists (Variable name: $DirectoryofChecklists)
2.) Output filepath (Variable name: $OutputPath)
3.) Output filename (Variable name: $Outfilename)

- Execute script
