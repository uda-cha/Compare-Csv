#二つ目の引数に取ったcsvのcsvヘッダを配列として格納
$headerstr = Get-Content $args[1] | Select-Object -First 1
$headerarray = $headerstr.split(",")

#比較対象から除外するヘッダのリスト
$excludeheader = @( `
  "CVE", `
  "CVSS", `
  "Risk", `
  "Host", `
  "Synopsis", `
  "Solution", `
  "See Also" `
  )

#長文比較対象リスト
$longheader = @( `
  "Plugin Output" `  #長い文章のためうまく比較できない。文字列として別に比較する
  )

#csv読み込み
$A = Import-Csv -Encoding UTF8 -Path $args[0]
$B = Import-Csv -Encoding UTF8 -Path $args[1]


##整備中
#Write-Output "以下のcsvヘッダを除外して比較します。"
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
Write-Output "以下のcsvヘッダを除外して比較します。"
Write-Output $excludeheader
Write-Output ""
Write-Output "-------------------------"
Write-Output ""

foreach ( $targetheader in $headerarray )
  {
  
  #長文比較対象リストにあるヘッダの比較
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
  
  #比較除外対象リストにあるヘッダはスキップ
  if ( $excludeheader -contains $targetheader )
    {
    continue
    }
  
  #通常の比較
  Compare-Object $A $B -Property $targetheader  `
    | Format-Table -Wrap -AutoSize -Property SideIndicator,$targetheader
  Write-Output "-------------------------"
  Write-Output ""
  
  }
