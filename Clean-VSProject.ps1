#// Removes Obj/Bin/packages folders from VS project.

#// System.Windows.Forms.folderbrowserdialog has problems with PS. Fallback to COM
$shell = new-object -com Shell.Application

#// Invoke BrowseForFolder dialog
$folder = $shell.BrowseForFolder(0, "Select VS project's folder", 0, [Environment]::GetFolderPath("MyDocuments"))

if (($folder -ne $null) -and ($folder.Self.Path -ne "")) {    
    
    #// Delete Bin/Obj folders
    dir $folder.Self.Path -directory -Recurse -Include "obj","bin" | 
        % { Write-Host $_.FullName; $_ } | 
        Remove-Item -Force -Recurse

    #// Remove NuGet packages folder (it will be restored automatically)
    Remove-Item -Path ([System.IO.Path]::Combine($folder.Self.Path, "packages")) -Force -Recurse -ErrorAction SilentlyContinue
}

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
