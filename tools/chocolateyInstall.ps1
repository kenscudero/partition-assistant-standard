# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir	= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName	= 'partition-assistant-standard'
$url		= 'https://www2.aomeisoftware.com/download/pa/PAssist_Std.exe'
$fileType	= ( $(Split-Path -leaf $url) -split('\.') )[-1].ToUpper()
$checksum	= '997AA6EDA9B9D91875C8A3464BA8AD65891315BD10067D58E23AD61E1910A5C5'

$packageArgs = @{
  packageName		= $packageName
  unzipLocation		= $toolsDir
  fileType		= $fileType

  url			= $url

  softwareName		= 'AOMEI Partition Assistant Standard*'

  # Checksums are now required as of 0.10.0.
  # To determine checksums, you can get that from the original site if provided.
  # You can also use checksum.exe (choco install checksum) and use it
  # e.g. checksum -t sha256 -f path\to\file
  checksum		= $checksum
  checksumType		= 'sha256' #default is md5, can also be sha1, sha256 or sha512

  #EXE
  silentArgs		= '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

  validExitCodes	= @(0)
}

Install-ChocolateyPackage @packageArgs
