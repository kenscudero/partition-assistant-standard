# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop'

$toolsDir	= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName	= 'partition-assistant-standard'
$url		= 'https://www2.aomeisoftware.com/download/pa/PAssist_Std.exe'
$fileType	= ( $(Split-Path -leaf $url) -split('\.') )[-1].ToUpper()
$checksum	= '77FF884495E01A20B6E461CDB1ABFD97AD99344D1E232603A9454C64B3507661'

$packageArgs = @{
  packageName		= $packageName
  unzipLocation		= $toolsDir
  fileType		= $fileType

  url			= $url

  softwareName		= 'AOMEI Partition Assistant Standard*'

  checksum		= $checksum
  checksumType		= 'sha256' #default is md5, can also be sha1, sha256 or sha512

  silentArgs		= '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

  validExitCodes	= @(0)
}

Install-ChocolateyPackage @packageArgs
