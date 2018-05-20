#��ڂ̈����Ɏ����csv��csv�w�b�_��z��Ƃ��Ċi�[
$headerstr = Get-Content $args[1] | Select-Object -First 1
$headerarray = $headerstr.split(",")

#��r�Ώۂ��珜�O����w�b�_�̃��X�g
$excludeheader = @( `
  "CVE", `
  "CVSS", `
  "Risk", `
  "Host", `
  "Synopsis", `
  "Solution", `
  "See Also" `
  )

#������r�Ώۃ��X�g
$longheader = @( `
  "Plugin Output" `  #�������͂̂��߂��܂���r�ł��Ȃ��B������Ƃ��ĕʂɔ�r����
  )

#csv�ǂݍ���
$A = Import-Csv -Encoding UTF8 -Path $args[0]
$B = Import-Csv -Encoding UTF8 -Path $args[1]


##������
#Write-Output "�ȉ���csv�w�b�_�����O���Ĕ�r���܂��B"
#Write-Output $excludeheader
#Write-Output ""
#Write-Output "-------------------------"
#Write-Output ""
#
#for ( $rownumB=0; $rownumB -le $B.Count; $rownumB++ )
#  {
#  for ( $headernum=0; $headernum -le $headerarray.Count; $headernum++ )
#    {
#    if ( ! ($A.($headerarray[$headernum]) -contains $B[$rownumB].($headerarray[$headernum])) )
#      {
#        Write-Output $headerarray[$headernum]
#        Write-Host $B[$rownumB].($headerarray[$headernum]) -ForegroundColor Cyan
#      }
#    }
#  }
#
#exit

#main
Write-Output "�ȉ���csv�w�b�_�����O���Ĕ�r���܂��B"
Write-Output $excludeheader
Write-Output ""
Write-Output "-------------------------"
Write-Output ""

foreach ( $targetheader in $headerarray )
  {
  
  #������r�Ώۃ��X�g�ɂ���w�b�_�̔�r
  if ( $longheader -contains $targetheader )
    {
    
    $longA = [string]$A.$targetheader
    $longB = [string]$B.$targetheader
    #Compare-Object $longA $longB | Format-Table -Wrap -AutoSize 
      $longA > longA.txt
      $longB > longB.txt
      Compare-Object (Get-Content .\longA.txt) (Get-Content .\longB.txt) `
        | Format-Table -Wrap -AutoSize -Property SideIndicator,@{name="$targetheader";expression={$_.InputObject}}
      Remove-Item Long*.txt
    Write-Output "-------------------------"
    Write-Output ""
    continue
    }
  
  #��r���O�Ώۃ��X�g�ɂ���w�b�_�̓X�L�b�v
  if ( $excludeheader -contains $targetheader )
    {
    continue
    }
  
  #�ʏ�̔�r
  Compare-Object $A $B -Property $targetheader  `
    | Format-Table -Wrap -AutoSize -Property SideIndicator,$targetheader
  Write-Output "-------------------------"
  Write-Output ""
  
  }
