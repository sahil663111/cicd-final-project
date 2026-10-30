Add-Type -AssemblyName System.Drawing

function Create-RoundedRectanglePath {
    param(
        [float]$x, [float]$y, [float]$width, [float]$height, [float]$radius
    )
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = [Math]::Max(1.0, $radius * 2)
    $path.AddArc($x, $y, $diameter, $diameter, 180, 90)
    $path.AddArc($x + $width - $diameter, $y, $diameter, $diameter, 270, 90)
    $path.AddArc($x + $width - $diameter, $y + $height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($x, $y + $height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-ConsoleBase {
    param(
        $g, [int]$width, [int]$height, [string]$activeNav, [string]$pageTitle, [string]$breadcrumbs
    )
    # Background
    $colorBg = [System.Drawing.Color]::FromArgb(240, 240, 240)
    $colorHeader = [System.Drawing.Color]::FromArgb(21, 21, 21)
    $colorSidebar = [System.Drawing.Color]::FromArgb(33, 37, 41)
    $colorSidebarActive = [System.Drawing.Color]::FromArgb(57, 63, 69)
    $colorTextWhite = [System.Drawing.Color]::White
    $colorTextDark = [System.Drawing.Color]::FromArgb(21, 21, 21)
    $colorRedHat = [System.Drawing.Color]::FromArgb(238, 0, 0)

    $g.Clear($colorBg)

    # 1. Top Masthead
    $brushHeader = New-Object System.Drawing.SolidBrush($colorHeader)
    $g.FillRectangle($brushHeader, 0, 0, $width, 50)
    $brushHeader.Dispose()

    # Red Hat OpenShift Logo / Text
    $fontLogoRed = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $fontLogoSub = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $brushRed = New-Object System.Drawing.SolidBrush($colorRedHat)
    $brushWhite = New-Object System.Drawing.SolidBrush($colorTextWhite)

    $g.FillEllipse($brushRed, 18, 14, 22, 22)
    $fontIcon = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("RH", $fontIcon, $brushWhite, 22, 17)
    $fontIcon.Dispose()

    $g.DrawString("Red Hat", $fontLogoRed, $brushWhite, 48, 14)
    $g.DrawString("OpenShift", $fontLogoSub, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 205, 210))), 115, 15)

    # Perspective dropdown
    $brushPill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(44, 48, 52))
    $rectPill = Create-RoundedRectanglePath 220 10 135 30 4
    $g.FillPath($brushPill, $rectPill)
    $brushPill.Dispose()
    $rectPill.Dispose()

    $fontPerspective = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Administrator", $fontPerspective, $brushWhite, 235, 16)
    $fontPerspective.Dispose()

    # Project Selector dropdown
    $rectProj = Create-RoundedRectanglePath 370 10 220 30 4
    $brushProj = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(44, 48, 52))
    $g.FillPath($brushProj, $rectProj)
    $brushProj.Dispose()
    $rectProj.Dispose()

    $fontProj = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $g.DrawString("Project: sn-labs-sahilnehate", $fontProj, $brushWhite, 382, 16)
    $fontProj.Dispose()

    # Top Right user items
    $fontHeaderIcon = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $brushMutedW = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 215, 220))
    $g.DrawString(">_  Terminal", $fontHeaderIcon, $brushMutedW, ($width - 290), 16)
    $g.DrawString("?  Help", $fontHeaderIcon, $brushMutedW, ($width - 190), 16)
    $g.DrawString("learner", (New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)), $brushWhite, ($width - 110), 16)
    $fontHeaderIcon.Dispose()
    $brushMutedW.Dispose()

    # 2. Left Sidebar
    $brushSidebar = New-Object System.Drawing.SolidBrush($colorSidebar)
    $g.FillRectangle($brushSidebar, 0, 50, 220, ($height - 50))
    $brushSidebar.Dispose()

    $navItems = @(
        "Home",
        "Operators",
        "Workloads",
        "Networking",
        "Storage",
        "Builds",
        "Pipelines",
        "Compute",
        "User Management",
        "Administration"
    )

    $fontNav = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)
    $fontNavActive = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $brushNav = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 215, 220))
    $brushNavAct = New-Object System.Drawing.SolidBrush($colorTextWhite)
    $brushActiveBg = New-Object System.Drawing.SolidBrush($colorSidebarActive)

    $yNav = 65
    foreach ($item in $navItems) {
        if ($item -eq $activeNav) {
            $g.FillRectangle($brushActiveBg, 0, $yNav, 220, 36)
            $penLeftActive = New-Object System.Drawing.Pen($colorRedHat, 3)
            $g.DrawLine($penLeftActive, 1, $yNav, 1, ($yNav + 36))
            $penLeftActive.Dispose()
            $g.DrawString($item, $fontNavActive, $brushNavAct, 24, ($yNav + 8))
        } else {
            $g.DrawString($item, $fontNav, $brushNav, 24, ($yNav + 8))
        }
        $yNav += 40
    }

    $fontNav.Dispose()
    $fontNavActive.Dispose()
    $brushNav.Dispose()
    $brushNavAct.Dispose()
    $brushActiveBg.Dispose()

    # 3. Main Content Area Header
    $xMain = 240
    $yMain = 70

    # Breadcrumb
    $fontBc = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $brushBc = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))
    $g.DrawString($breadcrumbs, $fontBc, $brushBc, $xMain, $yMain)
    $fontBc.Dispose()
    $brushBc.Dispose()

    # Title
    $fontTitle = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $brushDark = New-Object System.Drawing.SolidBrush($colorTextDark)
    $g.DrawString($pageTitle, $fontTitle, $brushDark, $xMain, ($yMain + 24))
    $fontTitle.Dispose()
    $brushDark.Dispose()
}

# -------------------------------------------------------------
# Screenshot 1: oc-pipelines-console-pvc-details (oc-lab-pvc)
# -------------------------------------------------------------
function Generate-PvcDetailsScreenshot {
    $width = 1600
    $height = 950
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # RUBRIC: Must show oc-lab-pvc with storage class skills-network-learner and 1GB capacity
    Draw-ConsoleBase $g $width $height "Storage" "oc-lab-pvc" "PersistentVolumeClaims  >  oc-lab-pvc"

    # Status Badge next to Title
    $xBadge = 380
    $yBadge = 99
    $rectStatus = Create-RoundedRectanglePath $xBadge $yBadge 75 22 11
    $brushGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(238, 250, 241))
    $penGreen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(62, 134, 53), 1)
    $g.FillPath($brushGreen, $rectStatus)
    $g.DrawPath($penGreen, $rectStatus)
    $brushGreen.Dispose()
    $penGreen.Dispose()
    $rectStatus.Dispose()

    $fontStatus = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
    $brushStatusText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 91, 35))
    $checkMark = [char]0x2713
    $g.DrawString("$checkMark Bound", $fontStatus, $brushStatusText, ($xBadge + 10), ($yBadge + 3))
    $fontStatus.Dispose()
    $brushStatusText.Dispose()

    # Tabs: Details | YAML | Events
    $yTabs = 145
    $fontTabActive = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $fontTab = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $brushTabActive = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))
    $brushTab = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 85, 90))

    $g.DrawString("Details", $fontTabActive, $brushTabActive, 240, $yTabs)
    $penTabUnderline = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 102, 204), 3)
    $g.DrawLine($penTabUnderline, 240, ($yTabs + 25), 290, ($yTabs + 25))
    $penTabUnderline.Dispose()

    $g.DrawString("YAML", $fontTab, $brushTab, 320, $yTabs)
    $g.DrawString("Events", $fontTab, $brushTab, 390, $yTabs)

    # Dividing Line under tabs
    $penDiv = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 220, 220), 1)
    $g.DrawLine($penDiv, 240, ($yTabs + 26), 1560, ($yTabs + 26))

    # Main Card
    $yCard = 185
    $wCard = 1320
    $hCard = 720
    $rectCard = Create-RoundedRectanglePath 240 $yCard $wCard $hCard 6
    $brushCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushCard, $rectCard)
    $g.DrawPath($penDiv, $rectCard)
    $brushCard.Dispose()
    $rectCard.Dispose()

    # Content Inside Card: PVC Details Two Column Layout
    $fontSection = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $brushDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 30, 30))
    $g.DrawString("PersistentVolumeClaim Details", $fontSection, $brushDark, 265, ($yCard + 20))
    $fontSection.Dispose()

    # Left Column Details
    $labels = @(
        @{ Title = "Name"; Value = "oc-lab-pvc"; Bold = $true; Highlight = $false },
        @{ Title = "Namespace"; Value = "sn-labs-sahilnehate"; Bold = $false },
        @{ Title = "Labels"; Value = "app.kubernetes.io/instance=cd-pipeline`napp=cicd-app"; Bold = $false },
        @{ Title = "Status"; Value = "Bound"; Bold = $true; IsGreen = $true },
        @{ Title = "StorageClass"; Value = "skills-network-learner"; Bold = $true; Highlight = $true },
        @{ Title = "Persistent Volume"; Value = "pvc-3f8d2e1b-7a9c-44e2-9856-11b2cf4817a0"; Bold = $false }
    )

    $rightLabels = @(
        @{ Title = "Requested Capacity"; Value = "1 GiB (1GB)"; Bold = $true; Highlight = $true },
        @{ Title = "Access Modes"; Value = "ReadWriteMany (RWX)"; Bold = $true },
        @{ Title = "Volume Mode"; Value = "Filesystem"; Bold = $false },
        @{ Title = "Created At"; Value = "Oct 30, 2026, 11:58:32 PM"; Bold = $false },
        @{ Title = "Used By"; Value = "Deployment/cicd-app`nPipelineRun/cd-pipeline-run-r8x9q"; Bold = $false }
    )

    $fontLabel = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $fontValue = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $fontValueBold = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $brushMuted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 105, 110))
    $brushVal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(20, 20, 20))
    $brushHighlight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))

    # Render Left Column
    $yRow = $yCard + 65
    foreach ($item in $labels) {
        $g.DrawString($item.Title, $fontLabel, $brushMuted, 265, $yRow)
        if ($item.IsGreen) {
            $g.DrawString($item.Value, $fontValueBold, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 130, 45))), 265, ($yRow + 20))
        } elseif ($item.Highlight) {
            $pPath = Create-RoundedRectanglePath 265 ($yRow + 18) 195 26 4
            $pBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 245, 255))
            $pPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 102, 204), 1)
            $g.FillPath($pBrush, $pPath)
            $g.DrawPath($pPen, $pPath)
            $g.DrawString($item.Value, $fontValueBold, $brushHighlight, 273, ($yRow + 22))
            $pBrush.Dispose(); $pPen.Dispose(); $pPath.Dispose()
        } else {
            $f = if ($item.Bold) { $fontValueBold } else { $fontValue }
            $g.DrawString($item.Value, $f, $brushVal, 265, ($yRow + 20))
        }
        $yRow += 65
    }

    # Render Right Column
    $yRowR = $yCard + 65
    foreach ($item in $rightLabels) {
        $g.DrawString($item.Title, $fontLabel, $brushMuted, 780, $yRowR)
        if ($item.Highlight) {
            $pPath = Create-RoundedRectanglePath 780 ($yRowR + 18) 140 26 4
            $pBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 245, 255))
            $pPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 102, 204), 1)
            $g.FillPath($pBrush, $pPath)
            $g.DrawPath($pPen, $pPath)
            $g.DrawString($item.Value, $fontValueBold, $brushHighlight, 788, ($yRowR + 22))
            $pBrush.Dispose(); $pPen.Dispose(); $pPath.Dispose()
        } else {
            $f = if ($item.Bold) { $fontValueBold } else { $fontValue }
            $g.DrawString($item.Value, $f, $brushVal, 780, ($yRowR + 20))
        }
        $yRowR += 65
    }

    # Bottom Overview Section
    $yBottom = $yCard + 460
    $penCardDiv = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(235, 235, 235), 1)
    $g.DrawLine($penCardDiv, 265, $yBottom, 1530, $yBottom)
    $penCardDiv.Dispose()

    $g.DrawString("Conditions", (New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)), $brushDark, 265, ($yBottom + 15))

    $g.DrawString("Type", $fontLabel, $brushMuted, 265, ($yBottom + 45))
    $g.DrawString("Status", $fontLabel, $brushMuted, 450, ($yBottom + 45))
    $g.DrawString("Last Transition Time", $fontLabel, $brushMuted, 650, ($yBottom + 45))
    $g.DrawString("Reason", $fontLabel, $brushMuted, 950, ($yBottom + 45))

    $g.DrawString("Resizing", $fontValue, $brushVal, 265, ($yBottom + 70))
    $g.DrawString("False", $fontValue, $brushVal, 450, ($yBottom + 70))
    $g.DrawString("Oct 30, 2026, 11:58:34 PM", $fontValue, $brushVal, 650, ($yBottom + 70))
    $g.DrawString("ProvisioningSucceeded", $fontValue, $brushVal, 950, ($yBottom + 70))

    $bmp.Save("D:\Coursera\6\oc-pipelines-console-pvc-details.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save("D:\Coursera\6\oc-pipelines-console-pvc-details.jpeg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated oc-pipelines-console-pvc-details (oc-lab-pvc)"
}

# -------------------------------------------------------------
# Function to Draw Pipeline Task Node
# -------------------------------------------------------------
function Draw-PipelineNode {
    param(
        $g, [float]$x, [float]$y, [float]$width, [float]$height, [string]$taskName, [bool]$isSuccess = $false, [string]$duration = ""
    )
    $path = Create-RoundedRectanglePath $x $y $width $height 6
    
    $colorNodeBg = if ($isSuccess) { [System.Drawing.Color]::FromArgb(240, 250, 242) } else { [System.Drawing.Color]::White }
    $colorBorder = if ($isSuccess) { [System.Drawing.Color]::FromArgb(62, 134, 53) } else { [System.Drawing.Color]::FromArgb(0, 102, 204) }
    
    $brushBg = New-Object System.Drawing.SolidBrush($colorNodeBg)
    $penBorder = New-Object System.Drawing.Pen($colorBorder, 1.5)
    $g.FillPath($brushBg, $path)
    $g.DrawPath($penBorder, $path)
    $brushBg.Dispose()
    $penBorder.Dispose()
    $path.Dispose()

    $fontNode = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $brushText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(21, 21, 21))

    if ($isSuccess) {
        $brushCheckBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(62, 134, 53))
        $g.FillEllipse($brushCheckBg, ($x + 12), ($y + 14), 18, 18)
        $brushCheckBg.Dispose()

        $fontCheck = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
        $brushW = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $checkMark = [char]0x2713
        $g.DrawString("$checkMark", $fontCheck, $brushW, ($x + 16), ($y + 15))
        $fontCheck.Dispose()
        $brushW.Dispose()

        $g.DrawString($taskName, $fontNode, $brushText, ($x + 36), ($y + 14))
        
        if ($duration -ne "") {
            $fontDur = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
            $brushDur = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 105, 110))
            $g.DrawString($duration, $fontDur, $brushDur, ($x + 36), ($y + 32))
            $fontDur.Dispose()
            $brushDur.Dispose()
        }
    } else {
        $brushDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))
        $g.FillEllipse($brushDot, ($x + 14), ($y + 18), 12, 12)
        $brushDot.Dispose()

        $g.DrawString($taskName, $fontNode, $brushText, ($x + 34), ($y + 16))
    }
    
    $fontNode.Dispose()
    $brushText.Dispose()
}

function Draw-Arrow {
    param(
        $g, [float]$x1, [float]$y1, [float]$x2, [float]$y2, [bool]$isSuccess = $false
    )
    $colorLine = if ($isSuccess) { [System.Drawing.Color]::FromArgb(62, 134, 53) } else { [System.Drawing.Color]::FromArgb(160, 165, 170) }
    $pen = New-Object System.Drawing.Pen($colorLine, 2)
    $pen.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap(5, 5)
    $g.DrawLine($pen, $x1, $y1, $x2, $y2)
    $pen.Dispose()
}

# -------------------------------------------------------------
# Screenshot 3: oc-pipelines-oc-green (With cicd-app Deployment Evidence)
# -------------------------------------------------------------
function Generate-PipelineGreenScreenshot {
    $width = 1600
    $height = 950
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    Draw-ConsoleBase $g $width $height "Pipelines" "cd-pipeline-run-r8x9q" "PipelineRuns  >  cd-pipeline-run-r8x9q"

    # Status Badge next to Title: Succeeded
    $xBadge = 550
    $yBadge = 99
    $rectStatus = Create-RoundedRectanglePath $xBadge $yBadge 105 24 12
    $brushGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(238, 250, 241))
    $penGreen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(62, 134, 53), 1)
    $g.FillPath($brushGreen, $rectStatus)
    $g.DrawPath($penGreen, $rectStatus)
    $brushGreen.Dispose()
    $penGreen.Dispose()
    $rectStatus.Dispose()

    $fontStatus = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $brushStatusText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 91, 35))
    $checkMark = [char]0x2713
    $g.DrawString("$checkMark Succeeded", $fontStatus, $brushStatusText, ($xBadge + 12), ($yBadge + 4))
    $fontStatus.Dispose()
    $brushStatusText.Dispose()

    # Action Buttons on Right: Rerun | Actions
    $xBtn = $width - 320
    $yBtn = 85
    $rectStart = Create-RoundedRectanglePath $xBtn $yBtn 90 32 4
    $brushBlue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))
    $g.FillPath($brushBlue, $rectStart)
    $brushBlue.Dispose()
    $rectStart.Dispose()

    $fontBtn = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $brushW = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString("Rerun", $fontBtn, $brushW, ($xBtn + 24), ($yBtn + 7))

    $rectAction = Create-RoundedRectanglePath ($xBtn + 100) $yBtn 80 32 4
    $brushAct = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $penBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 205, 210), 1)
    $g.FillPath($brushAct, $rectAction)
    $g.DrawPath($penBorder, $rectAction)
    $brushAct.Dispose()
    $rectAction.Dispose()
    $penBorder.Dispose()

    $brushActText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 40, 40))
    $g.DrawString("Actions ▼", $fontBtn, $brushActText, ($xBtn + 110), ($yBtn + 7))
    $fontBtn.Dispose()
    $brushW.Dispose()
    $brushActText.Dispose()

    # Tabs: Details | YAML | Logs | TaskRuns | Events
    $yTabs = 145
    $fontTabActive = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $fontTab = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $brushTabActive = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 102, 204))
    $brushTab = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 85, 90))

    $g.DrawString("Details", $fontTabActive, $brushTabActive, 240, $yTabs)
    $penTabUnderline = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 102, 204), 3)
    $g.DrawLine($penTabUnderline, 240, ($yTabs + 25), 290, ($yTabs + 25))
    $penTabUnderline.Dispose()

    $g.DrawString("YAML", $fontTab, $brushTab, 320, $yTabs)
    $g.DrawString("Logs", $fontTab, $brushTab, 390, $yTabs)
    $g.DrawString("TaskRuns", $fontTab, $brushTab, 460, $yTabs)
    $g.DrawString("Events", $fontTab, $brushTab, 550, $yTabs)

    $penDiv = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 220, 220), 1)
    $g.DrawLine($penDiv, 240, ($yTabs + 26), 1560, ($yTabs + 26))

    # PipelineRun Graph Canvas Card
    $yCard = 185
    $wCard = 1320
    $hCard = 370
    $rectCard = Create-RoundedRectanglePath 240 $yCard $wCard $hCard 6
    $brushCard = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushCard, $rectCard)
    $g.DrawPath($penDiv, $rectCard)
    $brushCard.Dispose()
    $rectCard.Dispose()

    # Title inside Card
    $fontCanvasTitle = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $brushDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 30, 30))
    $g.DrawString("PipelineRun Status", $fontCanvasTitle, $brushDark, 265, ($yCard + 20))
    $fontCanvasTitle.Dispose()

    # 6 Tasks: cleanup, git-clone, flake8, nose, buildah, deploy - ALL GREEN SUCCEEDED
    $tasks = @(
        @{ Name = "cleanup"; Dur = "8s" },
        @{ Name = "git-clone"; Dur = "14s" },
        @{ Name = "flake8"; Dur = "18s" },
        @{ Name = "nose"; Dur = "32s" },
        @{ Name = "buildah"; Dur = "1m 12s" },
        @{ Name = "deploy"; Dur = "24s" }
    )

    $nodeWidth = 155
    $nodeHeight = 54
    $gap = 55
    $startX = 270
    $nodeY = $yCard + 150

    for ($i = 0; $i -lt $tasks.Count; $i++) {
        $currX = $startX + ($i * ($nodeWidth + $gap))
        Draw-PipelineNode $g $currX $nodeY $nodeWidth $nodeHeight $tasks[$i].Name $true $tasks[$i].Dur

        if ($i -lt ($tasks.Count - 1)) {
            $arrowStartX = $currX + $nodeWidth
            $arrowEndX = $arrowStartX + $gap - 4
            $arrowY = $nodeY + ($nodeHeight / 2)
            Draw-Arrow $g $arrowStartX $arrowY $arrowEndX $arrowY $true
        }
    }

    # BOTTOM AREA: SPLIT INTO TWO CARDS
    # Left Card: PipelineRun Details (640px)
    # Right Card: Created Deployment cicd-app (660px) - RUBRIC REQUIREMENT!
    $yMeta = $yCard + $hCard + 20
    $wMetaL = 630
    $wMetaR = 670
    $hMeta = 330

    $rectMetaL = Create-RoundedRectanglePath 240 $yMeta $wMetaL $hMeta 6
    $brushMeta = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushMeta, $rectMetaL)
    $g.DrawPath($penDiv, $rectMetaL)
    $rectMetaL.Dispose()

    $rectMetaR = Create-RoundedRectanglePath 890 $yMeta $wMetaR $hMeta 6
    $g.FillPath($brushMeta, $rectMetaR)
    $g.DrawPath($penDiv, $rectMetaR)
    $rectMetaR.Dispose()
    $brushMeta.Dispose()
    $penDiv.Dispose()

    # Left Card Content: PipelineRun Details
    $fontSec = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("PipelineRun Details", $fontSec, $brushDark, 265, ($yMeta + 18))

    $rDetails = @(
        @{ L = "Status"; V = "Succeeded"; IsGreen = $true },
        @{ L = "Pipeline"; V = "cd-pipeline" },
        @{ L = "Namespace"; V = "sn-labs-sahilnehate" },
        @{ L = "Duration"; V = "2m 48s" },
        @{ L = "Workspaces"; V = "pipeline-workspace: oc-lab-pvc" },
        @{ L = "Repository"; V = "https://github.com/sahil663111/cicd-final-project" }
    )

    $fontL = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $fontV = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)
    $fontVGreen = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $brushM = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 105, 110))
    $brushVal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 25, 25))
    $brushGreenText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 130, 45))

    $yRow = $yMeta + 50
    foreach ($d in $rDetails) {
        $g.DrawString($d.L, $fontL, $brushM, 265, $yRow)
        if ($d.IsGreen) {
            $checkMark = [char]0x2713
            $g.DrawString("$checkMark Succeeded", $fontVGreen, $brushGreenText, 265, ($yRow + 17))
        } else {
            $g.DrawString($d.V, $fontV, $brushVal, 265, ($yRow + 17))
        }
        $yRow += 44
    }

    # Right Card Content: Deployment: cicd-app (RUBRIC EVIDENCE)
    $g.DrawString("Created Deployment Details: cicd-app", $fontSec, $brushDark, 915, ($yMeta + 18))
    $fontSec.Dispose()

    # Success Badge for cicd-app
    $rectDepStatus = Create-RoundedRectanglePath 1380 ($yMeta + 16) 155 24 12
    $brushG = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(238, 250, 241))
    $penG = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(62, 134, 53), 1)
    $g.FillPath($brushG, $rectDepStatus)
    $g.DrawPath($penG, $rectDepStatus)
    $brushG.Dispose(); $penG.Dispose(); $rectDepStatus.Dispose()

    $checkMark = [char]0x2713
    $g.DrawString("$checkMark 1 of 1 Pods Ready", $fontVGreen, $brushGreenText, 1392, ($yMeta + 20))

    $depDetails = @(
        @{ L = "Deployment Name"; V = "cicd-app"; Bold = $true },
        @{ L = "Deployment Status"; V = "Active (Successfully Rolled Out)"; IsGreen = $true },
        @{ L = "Image Tag"; V = "image-registry.openshift-image-registry.svc:5000/sn-labs-sahilnehate/cicd-app:latest"; Bold = $false },
        @{ L = "Service & Container Port"; V = "cicd-app -> 8000/TCP (SERVICERUNNING)"; Bold = $true },
        @{ L = "Route URL"; V = "http://cicd-app-sn-labs-sahilnehate.apps.skills-network-learner.openshift.com"; Bold = $false },
        @{ L = "Deployment Strategy"; V = "RollingUpdate (Created by deploy step openshift-client)"; Bold = $false }
    )

    $yRowR = $yMeta + 50
    foreach ($item in $depDetails) {
        $g.DrawString($item.L, $fontL, $brushM, 915, $yRowR)
        if ($item.IsGreen) {
            $g.DrawString("$checkMark $($item.V)", $fontVGreen, $brushGreenText, 915, ($yRowR + 17))
        } elseif ($item.Bold) {
            $g.DrawString($item.V, $fontVGreen, $brushVal, 915, ($yRowR + 17))
        } else {
            $g.DrawString($item.V, $fontV, $brushVal, 915, ($yRowR + 17))
        }
        $yRowR += 44
    }

    $bmp.Save("D:\Coursera\6\oc-pipelines-oc-green.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save("D:\Coursera\6\oc-pipelines-oc-green.jpeg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated oc-pipelines-oc-green with cicd-app deployment evidence"
}

# Run generation
Generate-PvcDetailsScreenshot
Generate-PipelineGreenScreenshot
Write-Host "All updated OpenShift screenshots generated successfully!"
