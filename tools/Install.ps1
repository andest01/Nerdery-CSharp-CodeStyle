#  Copyright (c) Adam Ralph. All rights reserved.

param($installPath, $toolsPath, $package, $project)
$sw = new-object system.IO.StreamWriter("c:\temp.txt")
$sw.writeline("Some sample text")

# remove content hook from project and delete file
$hookName = "StyleCop.MSBuild.ContentHook.txt"
$project.ProjectItems.Item($hookName).Remove();
Split-Path $project.FullName -parent | Join-Path -ChildPath $hookName | Remove-Item

# save any unsaved changes to project before we start messing about with project file
$project.Save()

# read in project XML
$projectXml = [xml](Get-Content $project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'

# remove current import nodes
$nodes = @(Select-Xml "//msb:Project/msb:Import[contains(@Project,'\packages\Nerdery.CSharpCodeStyle.')]" $projectXml -Namespace @{msb = $namespace} | Foreach {$_.Node})
if ($nodes)
{
    foreach ($node in $nodes)
    {
        $node.ParentNode.RemoveChild($node)
    }
}

# add debug properties
$debugNodes = @(Select-Xml "//msb:Project/msb:PropertyGroup[contains(@Condition,'Debug|AnyCPU')]/msb:StyleCopTreatErrorsAsWarnings" $projectXml -Namespace @{msb = $namespace} | Foreach {$_.Node})
if(-not $debugNodes)
{
	$treatErrorsAsWarnings = $projectXml.CreateElement('StyleCopTreatErrorsAsWarnings', $namespace)
	$treatErrorsAsWarnings.InnerText = 'true'
	@(Select-Xml "//msb:Project/msb:PropertyGroup[contains(@Condition,'Debug|AnyCPU')]" $projectXml -Namespace @{msb = $namespace} | Foreach {
		$_.Node.AppendChild($treatErrorsAsWarnings)
	})
}

# add release properties
$releaseNodes = @(Select-Xml "//msb:Project/msb:PropertyGroup[contains(@Condition,'Release|AnyCPU')]/msb:StyleCopTreatErrorsAsWarnings" $projectXml -Namespace @{msb = $namespace} | Foreach {$_.Node})
if(-not $releaseNodes)
{
	$treatErrorsAsWarnings = $projectXml.CreateElement('StyleCopTreatErrorsAsWarnings', $namespace)
	$treatErrorsAsWarnings.InnerText = 'false'
	@(Select-Xml "//msb:Project/msb:PropertyGroup[contains(@Condition,'Release|AnyCPU')]" $projectXml -Namespace @{msb = $namespace} | Foreach {
		$_.Node.AppendChild($treatErrorsAsWarnings)
	})
}

# work out relative path to targets
$absolutePath = Join-Path $toolsPath "StyleCop.targets"
$absoluteUri = New-Object -typename System.Uri -argumentlist $absolutePath
$projectUri = New-Object -typename System.Uri -argumentlist $project.FullName
$relativeUri = $projectUri.MakeRelativeUri($absoluteUri)
$relativePath = [System.URI]::UnescapeDataString($relativeUri.ToString()).Replace('/', '\');

# add new import
$import = $projectXml.CreateElement('Import', $namespace)
$import.SetAttribute('Project', $relativePath)
$projectXml.Project.AppendChild($import)

# save changes
$projectXml.Save($project.FullName)

$solutionRoot =$project.FullName.Substring(0, $project.FullName.Substring(0, $project.FullName.LastIndexOf("\")).LastIndexOf("\"))

#copy custom settings file if it doesn't exist yet

$customSettingsFileLocation = join-path $solutionRoot "Settings.StyleCop"
if(-not (Test-Path $customSettingsFileLocation)) 
{
	copy-item (join-path $toolsPath "Settings-ProjectOverrides.StyleCop") $customSettingsFileLocation
}

#copy resharper settings file to solution root
$resharperSettingsPath = Join-Path $toolsPath "ResharperSettings.DotSettings"
$solutionSln = ((gci $solutionRoot *.sln) | Select-Object -first 1)
if($solutionSln)
{
	copy-item $resharperSettingsPath (join-path $solutionRoot ([System.IO.Path]::GetFileNameWithoutExtension($solutionSln.Name)+".DotSettings"))
}


#create shortcut if it doesn't exist yet
$shortcutFileLocation = (join-path $project.FullName.Substring(0, $project.FullName.Substring(0, $project.FullName.LastIndexOf("\")).LastIndexOf("\")) "Edit-Style-Settings.lnk")
$sw.writeline($shortcutFileLocation)
if(-not (Test-Path $shortcutFileLocation))
{
$sw.writeline("creating shortcut")
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($shortcutFileLocation)
	$Shortcut.TargetPath = (join-path $toolsPath "StyleCopSettingsEditor.exe")
	$Shortcut.Arguments = "Settings.StyleCop"
	$Shortcut.Save()
$sw.writeline("done")
}