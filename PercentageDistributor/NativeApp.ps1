Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# Create Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Percentage Distribution Calculator"
$form.Size = New-Object System.Drawing.Size(680, 560)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 28, 36)
$form.ForeColor = [System.Drawing.Color]::White

# Header Title
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Percentage Distribution Calculator"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(25, 20)
$lblTitle.Size = New-Object System.Drawing.Size(450, 35)
$lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 245)
$form.Controls.Add($lblTitle)

$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "Enter any number at top to see the live distribution across 4 rows"
$lblSub.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblSub.Location = New-Object System.Drawing.Point(27, 55)
$lblSub.Size = New-Object System.Drawing.Size(480, 20)
$lblSub.ForeColor = [System.Drawing.Color]::FromArgb(150, 160, 180)
$form.Controls.Add($lblSub)

# Top Amount Panel
$pnlTop = New-Object System.Windows.Forms.Panel
$pnlTop.Location = New-Object System.Drawing.Point(25, 85)
$pnlTop.Size = New-Object System.Drawing.Size(615, 75)
$pnlTop.BackColor = [System.Drawing.Color]::FromArgb(35, 41, 54)
$pnlTop.BorderStyle = "None"
$form.Controls.Add($pnlTop)

$lblAmount = New-Object System.Windows.Forms.Label
$lblAmount.Text = "TOTAL AMOUNT ($):"
$lblAmount.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblAmount.Location = New-Object System.Drawing.Point(15, 12)
$lblAmount.Size = New-Object System.Drawing.Size(160, 20)
$lblAmount.ForeColor = [System.Drawing.Color]::FromArgb(160, 175, 200)
$pnlTop.Controls.Add($lblAmount)

$txtAmount = New-Object System.Windows.Forms.TextBox
$txtAmount.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$txtAmount.Location = New-Object System.Drawing.Point(15, 32)
$txtAmount.Size = New-Object System.Drawing.Size(350, 36)
$txtAmount.Text = "10000"
$txtAmount.BackColor = [System.Drawing.Color]::FromArgb(20, 24, 32)
$txtAmount.ForeColor = [System.Drawing.Color]::White
$txtAmount.BorderStyle = "FixedSingle"
$pnlTop.Controls.Add($txtAmount)

# Quick Preset Amounts
$btnAmt1k = New-Object System.Windows.Forms.Button
$btnAmt1k.Text = "1,000"
$btnAmt1k.Location = New-Object System.Drawing.Point(375, 33)
$btnAmt1k.Size = New-Object System.Drawing.Size(70, 33)
$btnAmt1k.BackColor = [System.Drawing.Color]::FromArgb(50, 60, 80)
$btnAmt1k.ForeColor = [System.Drawing.Color]::White
$btnAmt1k.FlatStyle = "Flat"
$btnAmt1k.FlatAppearance.BorderSize = 0
$btnAmt1k.Add_Click({ $txtAmount.Text = "1000"; UpdateCalc })
$pnlTop.Controls.Add($btnAmt1k)

$btnAmt10k = New-Object System.Windows.Forms.Button
$btnAmt10k.Text = "10,000"
$btnAmt10k.Location = New-Object System.Drawing.Point(452, 33)
$btnAmt10k.Size = New-Object System.Drawing.Size(70, 33)
$btnAmt10k.BackColor = [System.Drawing.Color]::FromArgb(50, 60, 80)
$btnAmt10k.ForeColor = [System.Drawing.Color]::White
$btnAmt10k.FlatStyle = "Flat"
$btnAmt10k.FlatAppearance.BorderSize = 0
$btnAmt10k.Add_Click({ $txtAmount.Text = "10000"; UpdateCalc })
$pnlTop.Controls.Add($btnAmt10k)

$btnAmt50k = New-Object System.Windows.Forms.Button
$btnAmt50k.Text = "50,000"
$btnAmt50k.Location = New-Object System.Drawing.Point(529, 33)
$btnAmt50k.Size = New-Object System.Drawing.Size(70, 33)
$btnAmt50k.BackColor = [System.Drawing.Color]::FromArgb(50, 60, 80)
$btnAmt50k.ForeColor = [System.Drawing.Color]::White
$btnAmt50k.FlatStyle = "Flat"
$btnAmt50k.FlatAppearance.BorderSize = 0
$btnAmt50k.Add_Click({ $txtAmount.Text = "50000"; UpdateCalc })
$pnlTop.Controls.Add($btnAmt50k)

# 4 Rows Construction
$colors = @(
    [System.Drawing.Color]::FromArgb(99, 102, 241),  # Indigo
    [System.Drawing.Color]::FromArgb(16, 185, 129),  # Emerald
    [System.Drawing.Color]::FromArgb(245, 158, 11),  # Amber
    [System.Drawing.Color]::FromArgb(236, 72, 153)   # Pink
)

$defaultPcts = @(25, 25, 25, 25)
$defaultNames = @("Category 1", "Category 2", "Category 3", "Category 4")

$rows = @()

for ($i = 0; $i -lt 4; $i++) {
    $yOffset = 175 + ($i * 68)

    $pnlRow = New-Object System.Windows.Forms.Panel
    $pnlRow.Location = New-Object System.Drawing.Point(25, $yOffset)
    $pnlRow.Size = New-Object System.Drawing.Size(615, 60)
    $pnlRow.BackColor = [System.Drawing.Color]::FromArgb(30, 36, 48)
    $form.Controls.Add($pnlRow)

    # Indicator stripe
    $stripe = New-Object System.Windows.Forms.Panel
    $stripe.Location = New-Object System.Drawing.Point(0, 0)
    $stripe.Size = New-Object System.Drawing.Size(5, 60)
    $stripe.BackColor = $colors[$i]
    $pnlRow.Controls.Add($stripe)

    # Name TextBox
    $txtName = New-Object System.Windows.Forms.TextBox
    $txtName.Text = $defaultNames[$i]
    $txtName.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $txtName.Location = New-Object System.Drawing.Point(15, 16)
    $txtName.Size = New-Object System.Drawing.Size(120, 27)
    $txtName.BackColor = [System.Drawing.Color]::FromArgb(20, 24, 32)
    $txtName.ForeColor = [System.Drawing.Color]::White
    $txtName.BorderStyle = "FixedSingle"
    $pnlRow.Controls.Add($txtName)

    # Slider / Trackbar
    $slider = New-Object System.Windows.Forms.TrackBar
    $slider.Minimum = 0
    $slider.Maximum = 100
    $slider.Value = $defaultPcts[$i]
    $slider.TickFrequency = 10
    $slider.Location = New-Object System.Drawing.Point(145, 14)
    $slider.Size = New-Object System.Drawing.Size(150, 35)
    $pnlRow.Controls.Add($slider)

    # NumericUpDown for exact %
    $numPct = New-Object System.Windows.Forms.NumericUpDown
    $numPct.Minimum = 0
    $numPct.Maximum = 100
    $numPct.DecimalPlaces = 1
    $numPct.Value = $defaultPcts[$i]
    $numPct.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $numPct.Location = New-Object System.Drawing.Point(305, 16)
    $numPct.Size = New-Object System.Drawing.Size(60, 27)
    $numPct.BackColor = [System.Drawing.Color]::FromArgb(20, 24, 32)
    $numPct.ForeColor = [System.Drawing.Color]::White
    $numPct.BorderStyle = "FixedSingle"
    $pnlRow.Controls.Add($numPct)

    $lblPctSign = New-Object System.Windows.Forms.Label
    $lblPctSign.Text = "%"
    $lblPctSign.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $lblPctSign.Location = New-Object System.Drawing.Point(368, 18)
    $lblPctSign.Size = New-Object System.Drawing.Size(20, 25)
    $lblPctSign.ForeColor = [System.Drawing.Color]::FromArgb(150, 160, 180)
    $pnlRow.Controls.Add($lblPctSign)

    # Amount Label
    $lblVal = New-Object System.Windows.Forms.Label
    $lblVal.Text = "$2,500.00"
    $lblVal.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $lblVal.TextAlign = "MiddleRight"
    $lblVal.Location = New-Object System.Drawing.Point(395, 16)
    $lblVal.Size = New-Object System.Drawing.Size(145, 27)
    $lblVal.ForeColor = $colors[$i]
    $pnlRow.Controls.Add($lblVal)

    # Copy Button
    $btnCopy = New-Object System.Windows.Forms.Button
    $btnCopy.Text = "Copy"
    $btnCopy.Location = New-Object System.Drawing.Point(548, 16)
    $btnCopy.Size = New-Object System.Drawing.Size(55, 28)
    $btnCopy.BackColor = [System.Drawing.Color]::FromArgb(45, 55, 75)
    $btnCopy.ForeColor = [System.Drawing.Color]::White
    $btnCopy.FlatStyle = "Flat"
    $btnCopy.FlatAppearance.BorderSize = 0
    $pnlRow.Controls.Add($btnCopy)

    $rowIndex = $i
    $btnCopy.Add_Click({
        param($sender, $e)
        [System.Windows.Forms.Clipboard]::SetText($lblVal.Text)
        $sender.Text = "OK!"
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 1000
        $timer.Add_Tick({
            $sender.Text = "Copy"
            $timer.Stop()
            $timer.Dispose()
        })
        $timer.Start()
    }.GetNewClosure())

    # Sync slider and numPct
    $slider.Add_Scroll({
        $numPct.Value = [decimal]$slider.Value
        UpdateCalc
    }.GetNewClosure())

    $numPct.Add_ValueChanged({
        $slider.Value = [int][Math]::Min(100, [Math]::Max(0, $numPct.Value))
        UpdateCalc
    }.GetNewClosure())

    $rows += [PSCustomObject]@{
        Name = $txtName
        Slider = $slider
        Num = $numPct
        ValueLabel = $lblVal
    }
}

# Bottom Status & Presets
$lblTotalPct = New-Object System.Windows.Forms.Label
$lblTotalPct.Text = "Total: 100.0% allocated"
$lblTotalPct.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblTotalPct.Location = New-Object System.Drawing.Point(25, 460)
$lblTotalPct.Size = New-Object System.Drawing.Size(260, 25)
$lblTotalPct.ForeColor = [System.Drawing.Color]::FromArgb(34, 197, 94)
$form.Controls.Add($lblTotalPct)

# Preset buttons
$btnEqual = New-Object System.Windows.Forms.Button
$btnEqual.Text = "25 / 25 / 25 / 25"
$btnEqual.Location = New-Object System.Drawing.Point(290, 458)
$btnEqual.Size = New-Object System.Drawing.Size(100, 28)
$btnEqual.BackColor = [System.Drawing.Color]::FromArgb(45, 55, 75)
$btnEqual.ForeColor = [System.Drawing.Color]::White
$btnEqual.FlatStyle = "Flat"
$btnEqual.FlatAppearance.BorderSize = 0
$btnEqual.Add_Click({
    for ($i = 0; $i -lt 4; $i++) {
        $rows[$i].Num.Value = 25
    }
    UpdateCalc
})
$form.Controls.Add($btnEqual)

$btnBudget = New-Object System.Windows.Forms.Button
$btnBudget.Text = "50 / 30 / 10 / 10"
$btnBudget.Location = New-Object System.Drawing.Point(400, 458)
$btnBudget.Size = New-Object System.Drawing.Size(100, 28)
$btnBudget.BackColor = [System.Drawing.Color]::FromArgb(45, 55, 75)
$btnBudget.ForeColor = [System.Drawing.Color]::White
$btnBudget.FlatStyle = "Flat"
$btnBudget.FlatAppearance.BorderSize = 0
$btnBudget.Add_Click({
    $rows[0].Num.Value = 50
    $rows[1].Num.Value = 30
    $rows[2].Num.Value = 10
    $rows[3].Num.Value = 10
    UpdateCalc
})
$form.Controls.Add($btnBudget)

$btnBalance = New-Object System.Windows.Forms.Button
$btnBalance.Text = "Auto-Balance"
$btnBalance.Location = New-Object System.Drawing.Point(510, 458)
$btnBalance.Size = New-Object System.Drawing.Size(130, 28)
$btnBalance.BackColor = [System.Drawing.Color]::FromArgb(99, 102, 241)
$btnBalance.ForeColor = [System.Drawing.Color]::White
$btnBalance.FlatStyle = "Flat"
$btnBalance.FlatAppearance.BorderSize = 0
$btnBalance.Add_Click({
    $sumFirst3 = $rows[0].Num.Value + $rows[1].Num.Value + $rows[2].Num.Value
    $rem = [Math]::Max(0, 100 - $sumFirst3)
    $rows[3].Num.Value = $rem
    UpdateCalc
})
$form.Controls.Add($btnBalance)

function UpdateCalc {
    $cleanAmt = $txtAmount.Text -replace '[^0-9.]', ''
    [double]$tot = 0
    [double]::TryParse($cleanAmt, [ref]$tot) | Out-Null

    [double]$sum = 0
    for ($i = 0; $i -lt 4; $i++) {
        [double]$pct = [double]$rows[$i].Num.Value
        $sum += $pct
        $amt = ($tot * $pct) / 100.0
        $rows[$i].ValueLabel.Text = [string]::Format("${0:N2}", $amt)
    }

    if ([Math]::Abs($sum - 100.0) -lt 0.05) {
        $lblTotalPct.Text = [string]::Format("Total: {0:F1}% allocated (OK)", $sum)
        $lblTotalPct.ForeColor = [System.Drawing.Color]::FromArgb(34, 197, 94)
    } elseif ($sum -lt 100.0) {
        $rem = 100.0 - $sum
        $lblTotalPct.Text = [string]::Format("Total: {0:F1}% ({1:F1}% remaining)", $sum, $rem)
        $lblTotalPct.ForeColor = [System.Drawing.Color]::FromArgb(245, 158, 11)
    } else {
        $ex = $sum - 100.0
        $lblTotalPct.Text = [string]::Format("Total: {0:F1}% (+{1:F1}% over 100!)", $sum, $ex)
        $lblTotalPct.ForeColor = [System.Drawing.Color]::FromArgb(239, 68, 68)
    }
}

$txtAmount.Add_TextChanged({ UpdateCalc })

# Initial calculation
UpdateCalc

# Run Form
[System.Windows.Forms.Application]::Run($form)
