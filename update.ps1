# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
if ( -not ( Test-Path -Path "$env:ProgramData\Chocolatey" ) ) {
	Write-Error -Message  "Chocolatey is not installed"	-ErrorAction Stop
}

import-module au

$domain		= 'https://www.diskpart.com'
$releases	= $domain + '/download-home.html'

$regexFileType	= '\.' + 'exe'
$applBits	= '32'
$applFilePath	= '/download/pa/'

function global:au_SearchReplace {
	@{
		".\tools\chocolateyInstall.ps1" = @{
			"($i)(^\s*url\s*=\s*)('.*')"			= "`$1'$($Latest.URL32)'"
			"($i)(^\s*checksum\s*=\s*)('.*')"		= "`$1'$($Latest.Checksum32)'"
			"($i)(^\s*filetype\s*=\s*)('.*')"		= "`$1'$($Latest.FileType)'"
		}
	}
}

function global:au_GetLatest {
	$myFuncName = $MyInvocation.MyCommand
	Write-Verbose "$($myFuncName):releases=$releases"
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
	Write-Verbose "$($myFuncName):download_page=$download_page"
	Write-Verbose "$($myFuncName):regexFileType=$regexFileType"
	Write-Verbose "$($myFuncName):applBits=$applBits"
	$p = ( "$download_page.Links".split('<').split('>') | Select-String -Pattern $regexFileType )
	Write-Verbose "$($myFuncName):p=$p"
	$p = "$p".split(' ') | Select-String -Pattern $regexFileType
	Write-Verbose "$($myFuncName):p=$p"
	$ub = $applBits
	Write-Verbose "$($myFuncName):ub = $($ub)"
	$filetype = ( ( Split-Path ( ( "$p".ToUpper().split('"') -match('\.' ) )[0] ) -leaf ).split('.') )[-1]
	Write-Verbose "$($myFuncName):filetype = $($filetype)"
	$url = ( ( "$p".split('"') -match $filetype.ToLower() ) -match $applFilePath.ToLower() )[0]
	Write-Verbose "$($myFuncName):url = $($url)"
	$version = ( ( "$download_page.Links".split('"').ToLower() ).split('</i>') ) -match ' v[0-9]'
	Write-Verbose "$($myFuncName):version = $($version)"
	$version = ( "$version".split('>').split('v') )[-1]
	Write-Verbose "$($myFuncName):version = $($version)"
	$s ="URL$applBits = '$($url)'; Version = '$($version)'; FileType = '$($filetype)';"
	Write-Verbose "$($myFuncName):s=$s"
	Invoke-Expression "@{ $s }"
}

#au_GetLatest
update
