param ([switch]$serve = $false)


function Import-ModuleSafe([string] $name)
{
    $module = Get-InstalledModule -Name $name;
    if ($null -eq $module)
    {
        Install-Module -Name $name -Scope CurrentUser -Force
    }
    Import-Module $name
}

# 'npm init' might be necessary to use vscode integration

Import-ModuleSafe 'powershell-yaml'
Import-ModuleSafe 'docfx-toc-generator'

. "$PSScriptRoot\docfx-toc-generator.ps1"

Build-TocHereRecursive


if (!(Test-Path ../../.output/gh-pages))  {
  git clone https://github.com/royalapplications/docs.git ./../.output/gh-pages
  cd ../../.output/gh-pages
  git checkout gh-pages
}

cd $PSScriptRoot
docfx $PSScriptRoot\docfx.json

if ($serve) {
  docfx $PSScriptRoot\docfx-serve.json --serve
}
