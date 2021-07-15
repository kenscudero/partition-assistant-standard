# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
if ( -not ( Test-Path -Path "$env:ProgramData\Chocolatey" ) ) {
	Write-Error -Message  "Chocolatey is not installed"	-ErrorAction Stop
}

import-module au

#$domain		   = 'https://m.majorgeeks.com'
#$releases	   = $domain + '/mg/get/aomei_partition_assistant,1.html'
#$domain		   = 'https://www2.aomeisoftware.com'
#$releases	   = $domain + '/download/pa/PAssist_Std.exe'

$domain			= 'https://www.aomeitech.com'
$releases		= $domain + '/download.html#pa'

$regexFileType	= '\.' + 'exe'
$applBits		= '32'
$applFileName	= 'PAssist_Std.exe'

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
	#echo "releases=$releases"
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
	#echo "download_page=$download_page"
	#echo "regexFileType=$regexFileType"
	#echo "applBits=$applBits"
	$p = ( "$download_page.Links".split('<').split('>') | Select-String -Pattern $regexFileType )
	#echo "p=$p"
	$p = "$p".split(' ') | Select-String -Pattern $regexFileType
	#echo "p=$p"
	$ub = $applBits
	#echo "ub = $($ub)"
	$filetype = ( ( ( "$p".ToUpper().split('"') -match('\.' ) )[0] ).split('\.') )[-1]
	#echo "filetype = $($filetype)"
	$url = ( "$p".split('"') -match $filetype.ToLower() -match $applFileName.ToLower() )[0]
	#echo "url = $($url)"
	$version = ( ( ( ( "$download_page.Content" ).split('<').split('>').ToLower() ) | Select-String -Pattern ' v[0-9]' )[1] )
	#echo "version = $($version)"
	$version = ( "$version".split(' ') )[3].replace('v','')
	#echo "version = $($version)"
	$s ="URL$applBits = '$($url)'; Version = '$($version)'; FileType = '$($filetype)';"
	Invoke-Expression "@{ $s }"
}

au_GetLatest
update
