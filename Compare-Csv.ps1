#二つ目の引数に取ったcsvのcsvヘッダを配列として格納
#[todo]ヘッダ比較して異なるならエラー返す
$headerstr = Get-Content $args[1] | Select-Object -First 1
$headerarray = $headerstr.split(",")

#比較対象から除外するヘッダのリスト
#[todo]スイッチにしたい
$excludeheader = @( `
  "CVE", `
  "CVSS", `
  "Risk", `
  "Host", `
  "Synopsis", `
  "Solution", `
  "See Also" `
  )

#長文比較対象リスト。セル単位ではなくセルの中身を一行ずつ比較する
#[todo]スイッチにしたい
$longheader = @( `
  "Plugin Output"
  )

#csv読み込み
$A = Import-Csv -Path $args[0]
$B = Import-Csv -Path $args[1]


Write-Output "以下のcsvヘッダを除外して比較します。"
Write-Output $excludeheader
Write-Output ""
Write-Output "-------------------------"
Write-Output ""

foreach ( $targetheader in $headerarray )
  {
  
  #長文比較対象リストにあるヘッダ列の比較。セル単位ではなくセルの中身の一行ずつ比較
  if ( $longheader -contains $targetheader )
    {
    
    #Windiows7対応。10のPSv5なら$A.$targetheaderでOK
    [string]( $A | Select-Object $targetheader | Format-Table -Wrap -AutoSize | Out-String ) > longA.txt
    [string]( $B | Select-Object $targetheader | Format-Table -Wrap -AutoSize | Out-String ) > longB.txt
      Compare-Object (Get-Content .\longA.txt) (Get-Content .\longB.txt) `
        | Format-Table -Wrap -AutoSize -Property SideIndicator,@{name="$targetheader";expression={$_.InputObject}}
      Remove-Item "long[A|B].txt"
    Write-Output "-------------------------"
    Write-Output ""
    continue
    }
  
  #比較除外対象リストにあるヘッダはスキップ
  if ( $excludeheader -contains $targetheader )
    {
    continue
    }
  
  #通常の比較。セル単位で比較
  Compare-Object $A $B -Property $targetheader  `
    | Format-Table -Wrap -AutoSize -Property SideIndicator,$targetheader
  Write-Output "-------------------------"
  Write-Output ""
  
  }
