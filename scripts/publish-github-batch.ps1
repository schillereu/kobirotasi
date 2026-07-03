$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$gh = "C:\Program Files\GitHub CLI\gh.exe"
$repo = "kobirotasi"
$owner = (& $gh api user --jq .login).Trim()
$fullRepo = "$owner/$repo"
$description = "KOBI'ler icin teknoloji araci kesif ve karsilastirma sitesi."

try {
    & $gh repo view $fullRepo *> $null
    Write-Host "Repo zaten var: $fullRepo"
} catch {
    Write-Host "Repo olusturuluyor: $fullRepo"
    & $gh api user/repos -X POST -f name="$repo" -f description="$description" -F private=false -F auto_init=true *> $null
}

$files = @(
    "index.html",
    "rehberler.html",
    "arac-secim.html",
    "hakkinda.html",
    "ihtiyac-analizi.html",
    "tesekkur.html",
    "style.css",
    "script.js",
    "assessment.js",
    "lead.js",
    "privacy.html",
    "affiliate.html",
    "site.webmanifest",
    "assets/kobirotasi-hero.png",
    "robots.txt",
    "netlify.toml",
    "vercel.json",
    ".nojekyll",
    ".gitignore",
    "README.md",
    "KOBI-DevAgent.md",
    "EXECUTION-ALGORITHM.md",
    "BRAND-DOMAIN-KARARI.md",
    "AGENT-OPERATING-SYSTEM.md",
    "DOMAIN-STRATEGY.md",
    "PROJECT-ROADMAP.md",
    "DEPLOYMENT-RUNBOOK.md",
    "MONETIZATION-PLAN.md",
    "CONTENT-SEO-PLAN.md",
    "CONVERSION-QA-PLAYBOOK.md",
    "NEXT-GROWTH-PLAN.md",
    "FORM-DOMAIN-SETUP.md",
    ".agents/README.md",
    ".agents/00-main-orchestrator.md",
    ".agents/01-roadmap-planner.md",
    ".agents/02-github-live-sync-qa.md",
    ".agents/03-free-hosting-publisher.md",
    ".agents/04-revenue-strategist.md",
    ".agents/05-content-seo-agent.md",
    ".agents/06-conversion-qa-agent.md",
    ".agents/07-analytics-operator.md",
    ".agents/08-partnership-outreach-agent.md",
    ".agents/09-compliance-trust-agent.md",
    ".agents/10-domain-brand-agent.md",
    ".agents/11-content-factory-agent.md",
    ".agents/12-affiliate-link-manager-agent.md",
    ".agents/13-performance-accessibility-agent.md",
    ".agents/14-credit-budget-orchestrator-agent.md",
    "scripts/check-live-site.ps1",
    "scripts/sync-github.ps1",
    "scripts/publish-github-batch.ps1",
    "scripts/set-custom-domain.ps1"
)

$ref = & $gh api "repos/$fullRepo/git/ref/heads/main" | ConvertFrom-Json
$baseCommitSha = $ref.object.sha
$baseCommit = & $gh api "repos/$fullRepo/git/commits/$baseCommitSha" | ConvertFrom-Json
$baseTreeSha = $baseCommit.tree.sha

$treeItems = @()
foreach ($file in $files) {
    $path = Join-Path $root $file
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }

    $bytes = [System.IO.File]::ReadAllBytes($path)
    $content = [Convert]::ToBase64String($bytes)
    $blobBody = @{
        content = $content
        encoding = "base64"
    } | ConvertTo-Json -Depth 5

    $blobTemp = New-TemporaryFile
    [System.IO.File]::WriteAllText($blobTemp, $blobBody, [System.Text.UTF8Encoding]::new($false))
    $blob = & $gh api "repos/$fullRepo/git/blobs" -X POST --input $blobTemp | ConvertFrom-Json
    Remove-Item -LiteralPath $blobTemp -Force

    $treeItems += @{
        path = $file.Replace("\", "/")
        mode = "100644"
        type = "blob"
        sha = $blob.sha
    }
}

$treeBody = @{
    base_tree = $baseTreeSha
    tree = $treeItems
} | ConvertTo-Json -Depth 10

$treeTemp = New-TemporaryFile
[System.IO.File]::WriteAllText($treeTemp, $treeBody, [System.Text.UTF8Encoding]::new($false))
$newTree = & $gh api "repos/$fullRepo/git/trees" -X POST --input $treeTemp | ConvertFrom-Json
Remove-Item -LiteralPath $treeTemp -Force

$commitBody = @{
    message = "Sync agent system, revenue plans, and site updates"
    tree = $newTree.sha
    parents = @($baseCommitSha)
} | ConvertTo-Json -Depth 10

$commitTemp = New-TemporaryFile
[System.IO.File]::WriteAllText($commitTemp, $commitBody, [System.Text.UTF8Encoding]::new($false))
$newCommit = & $gh api "repos/$fullRepo/git/commits" -X POST --input $commitTemp | ConvertFrom-Json
Remove-Item -LiteralPath $commitTemp -Force

$refBody = @{
    sha = $newCommit.sha
    force = $false
} | ConvertTo-Json -Depth 5

$refTemp = New-TemporaryFile
[System.IO.File]::WriteAllText($refTemp, $refBody, [System.Text.UTF8Encoding]::new($false))
& $gh api "repos/$fullRepo/git/refs/heads/main" -X PATCH --input $refTemp *> $null
Remove-Item -LiteralPath $refTemp -Force

try {
    & $gh api "repos/$fullRepo/pages" *> $null
} catch {
    $pagesBody = @{
        source = @{
            branch = "main"
            path = "/"
        }
    } | ConvertTo-Json -Depth 5
    $pagesTemp = New-TemporaryFile
    [System.IO.File]::WriteAllText($pagesTemp, $pagesBody, [System.Text.UTF8Encoding]::new($false))
    & $gh api "repos/$fullRepo/pages" -X POST --input $pagesTemp *> $null
    Remove-Item -LiteralPath $pagesTemp -Force
}

try {
    & $gh api "repos/$fullRepo/pages/builds" -X POST *> $null
} catch {
    Write-Host "Pages build otomatik tetiklenmis olabilir."
}

Write-Host "Toplu commit olusturuldu: $($newCommit.sha)"
Write-Host "Repo: https://github.com/$fullRepo"
Write-Host "Site: https://$owner.github.io/$repo/"
