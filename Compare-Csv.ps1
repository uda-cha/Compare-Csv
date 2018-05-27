#��ڂ̈����Ɏ����csv��csv�w�b�_��z��Ƃ��Ċi�[
#[todo]�w�b�_��r���ĈقȂ�Ȃ�G���[�Ԃ�
$headerstr = Get-Content $args[1] | Select-Object -First 1
$headerarray = $headerstr.split(",")

#��r�Ώۂ��珜�O����w�b�_�̃��X�g
#[todo]�X�C�b�`�ɂ�����
$excludeheader = @( `
  "CVE", `
  "CVSS", `
  "Risk", `
  "Host", `
  "Synopsis", `
  "Solution", `
  "See Also" `
  )

#������r�Ώۃ��X�g�B�Z���P�ʂł͂Ȃ��Z���̒��g����s����r����
#[todo]�X�C�b�`�ɂ�����
$longheader = @( `
  "Plugin Output"
  )

#csv�ǂݍ���
$A = Import-Csv -Path $args[0]
$B = Import-Csv -Path $args[1]


Write-Output "�ȉ���csv�w�b�_�����O���Ĕ�r���܂��B"
Write-Output $excludeheader
Write-Output ""
Write-Output "-------------------------"
Write-Output ""

foreach ( $targetheader in $headerarray )
  {
  
  #������r�Ώۃ��X�g�ɂ���w�b�_��̔�r�B�Z���P�ʂł͂Ȃ��Z���̒��g�̈�s����r
  if ( $longheader -contains $targetheader )
    {
    
    #Windiows7�Ή��B10��PSv5�Ȃ�$A.$targetheader��OK
    [string]( $A | Select-Object $targetheader | Format-Table -Wrap -AutoSize | Out-String ) > longA.txt
    [string]( $B | Select-Object $targetheader | Format-Table -Wrap -AutoSize | Out-String ) > longB.txt
      Compare-Object (Get-Content .\longA.txt) (Get-Content .\longB.txt) `
        | Format-Table -Wrap -AutoSize -Property SideIndicator,@{name="$targetheader";expression={$_.InputObject}}
      Remove-Item "long[A|B].txt"
    Write-Output "-------------------------"
    Write-Output ""
    continue
    }
  
  #��r���O�Ώۃ��X�g�ɂ���w�b�_�̓X�L�b�v
  if ( $excludeheader -contains $targetheader )
    {
    continue
    }
  
  #�ʏ�̔�r�B�Z���P�ʂŔ�r
  Compare-Object $A $B -Property $targetheader  `
    | Format-Table -Wrap -AutoSize -Property SideIndicator,$targetheader
  Write-Output "-------------------------"
  Write-Output ""
  
  }
