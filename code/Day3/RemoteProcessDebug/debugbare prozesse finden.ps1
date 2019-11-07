Get-ChildItem -Path "\\.\pipe\" -Filter '*pshost*' |
    ForEach-Object {
        $id = $_.Name.Split('.')[2]
        if ($id -ne $pid)
        {
            Get-Process -ID $id 
        }
    }