import Cocoa

// MARK: - Settings Keys
struct SettingsKeys {
    static let colorRed = "colorRed"
    static let colorGreen = "colorGreen"
    static let colorBlue = "colorBlue"
    static let opacity = "opacity"
    static let fontName = "fontName"
    static let fontWeight = "fontWeight"
    static let fontSize = "fontSize"
    static let showDate = "showDate"
    static let timeFormat = "timeFormat"
    static let dateFormat = "dateFormat"
    static let dateFontSize = "dateFontSize"
    static let lineSpacing = "lineSpacing"
    static let textAlignment = "textAlignment"
    static let chimeInterval = "chimeInterval"
    static let chimeVolume = "chimeVolume"
    static let settingsWindowX = "settingsWindowX"
    static let settingsWindowY = "settingsWindowY"
    static let hasSettingsWindowPosition = "hasSettingsWindowPosition"
}

// MARK: - Settings Manager
class SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard

    private init() {
        migrateFromOldBundleID()
        defaults.register(defaults: [
            SettingsKeys.colorRed: 1.0,
            SettingsKeys.colorGreen: 1.0,
            SettingsKeys.colorBlue: 1.0,
            SettingsKeys.opacity: 0.75,
            SettingsKeys.fontName: "Arial Rounded MT Bold",
            SettingsKeys.fontWeight: "regular",
            SettingsKeys.fontSize: 21.0,
            SettingsKeys.showDate: true,
            SettingsKeys.timeFormat: "hh:mm a",
            SettingsKeys.dateFormat: "EEE, MM-dd",
            SettingsKeys.dateFontSize: 18.0,
            SettingsKeys.lineSpacing: 0.5,
            SettingsKeys.textAlignment: 1,
            SettingsKeys.chimeInterval: 30,
            SettingsKeys.chimeVolume: 50,
        ])
    }

    // The app used to be "Madda Floating Clock" (com.madda.floatingclock). Copy its
    // saved settings over once so renaming the app doesn't reset everything.
    private func migrateFromOldBundleID() {
        let migratedKey = "migratedFromMaddaFloatingClock"
        guard !defaults.bool(forKey: migratedKey) else { return }

        if let old = defaults.persistentDomain(forName: "com.madda.floatingclock") {
            let keys = [
                SettingsKeys.colorRed, SettingsKeys.colorGreen, SettingsKeys.colorBlue,
                SettingsKeys.opacity, SettingsKeys.fontName, SettingsKeys.fontWeight,
                SettingsKeys.fontSize, SettingsKeys.showDate, SettingsKeys.timeFormat,
                SettingsKeys.dateFormat, SettingsKeys.dateFontSize, SettingsKeys.lineSpacing,
                SettingsKeys.textAlignment, SettingsKeys.chimeInterval, SettingsKeys.chimeVolume,
                SettingsKeys.settingsWindowX, SettingsKeys.settingsWindowY,
                SettingsKeys.hasSettingsWindowPosition,
            ]
            for key in keys where defaults.object(forKey: key) == nil {
                if let value = old[key] {
                    defaults.set(value, forKey: key)
                }
            }
        }
        defaults.set(true, forKey: migratedKey)
    }

    // The screen with the menu bar (the one set as main display in System Settings).
    // The clock is always pinned to the bottom-right corner of this screen.
    static func mainDisplayScreen() -> NSScreen? {
        return NSScreen.screens.first ?? NSScreen.main
    }

    var textColor: NSColor {
        get {
            let red = defaults.object(forKey: SettingsKeys.colorRed) as? CGFloat ?? 1.0
            let green = defaults.object(forKey: SettingsKeys.colorGreen) as? CGFloat ?? 1.0
            let blue = defaults.object(forKey: SettingsKeys.colorBlue) as? CGFloat ?? 1.0
            return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        set {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            if let color = newValue.usingColorSpace(.sRGB) {
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                defaults.set(red, forKey: SettingsKeys.colorRed)
                defaults.set(green, forKey: SettingsKeys.colorGreen)
                defaults.set(blue, forKey: SettingsKeys.colorBlue)
            }
        }
    }

    var opacity: CGFloat {
        get {
            let value = defaults.object(forKey: SettingsKeys.opacity) as? CGFloat
            return value ?? 0.75
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.opacity)
        }
    }

    var fontName: String {
        get {
            return defaults.string(forKey: SettingsKeys.fontName) ?? "Trebuchet MS"
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.fontName)
        }
    }

    var fontWeight: String {
        get {
            return defaults.string(forKey: SettingsKeys.fontWeight) ?? "regular"
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.fontWeight)
        }
    }

    var fontSize: CGFloat {
        get {
            let value = defaults.object(forKey: SettingsKeys.fontSize) as? CGFloat
            return value ?? 19
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.fontSize)
        }
    }

    var showDate: Bool {
        get {
            if defaults.object(forKey: SettingsKeys.showDate) == nil {
                return false
            }
            return defaults.bool(forKey: SettingsKeys.showDate)
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.showDate)
        }
    }

    var timeFormat: String {
        get {
            return defaults.string(forKey: SettingsKeys.timeFormat) ?? "hh:mm a"
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.timeFormat)
        }
    }

    var dateFormat: String {
        get {
            return defaults.string(forKey: SettingsKeys.dateFormat) ?? "EEE, MM-dd"
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.dateFormat)
        }
    }

    var dateFontSize: CGFloat {
        get {
            let value = defaults.object(forKey: SettingsKeys.dateFontSize) as? CGFloat
            return value ?? 16
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.dateFontSize)
        }
    }

    var lineSpacing: CGFloat {
        get {
            let value = defaults.object(forKey: SettingsKeys.lineSpacing) as? CGFloat
            return value ?? 2
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.lineSpacing)
        }
    }

    // 0 = left, 1 = center, 2 = right
    var textAlignment: Int {
        get {
            if defaults.object(forKey: SettingsKeys.textAlignment) == nil {
                return 1 // default center
            }
            return defaults.integer(forKey: SettingsKeys.textAlignment)
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.textAlignment)
        }
    }

    func getNSTextAlignment() -> NSTextAlignment {
        switch textAlignment {
        case 0: return .left
        case 2: return .right
        default: return .center
        }
    }

    // Settings window position
    var settingsWindowPosition: NSPoint? {
        get {
            guard defaults.bool(forKey: SettingsKeys.hasSettingsWindowPosition) else { return nil }
            return NSPoint(
                x: defaults.double(forKey: SettingsKeys.settingsWindowX),
                y: defaults.double(forKey: SettingsKeys.settingsWindowY)
            )
        }
        set {
            if let pos = newValue {
                defaults.set(true, forKey: SettingsKeys.hasSettingsWindowPosition)
                defaults.set(pos.x, forKey: SettingsKeys.settingsWindowX)
                defaults.set(pos.y, forKey: SettingsKeys.settingsWindowY)
            } else {
                defaults.set(false, forKey: SettingsKeys.hasSettingsWindowPosition)
            }
        }
    }

    // 0-100 volume percentage
    var chimeVolume: Int {
        get {
            if defaults.object(forKey: SettingsKeys.chimeVolume) == nil {
                return 50
            }
            return defaults.integer(forKey: SettingsKeys.chimeVolume)
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.chimeVolume)
        }
    }

    // 0 = disabled, 5-60 minutes
    var chimeInterval: Int {
        get {
            return defaults.integer(forKey: SettingsKeys.chimeInterval)
        }
        set {
            defaults.set(newValue, forKey: SettingsKeys.chimeInterval)
        }
    }

    private func getNSFontWeight() -> NSFont.Weight {
        switch fontWeight.lowercased() {
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        default: return .regular
        }
    }

    // NSFontManager weight values (0-15 scale)
    private func getFontManagerWeight() -> Int {
        switch fontWeight.lowercased() {
        case "light": return 3
        case "regular": return 5
        case "medium": return 6
        case "semibold": return 8
        case "bold": return 9
        case "heavy": return 11
        default: return 5
        }
    }

    func getFont() -> NSFont {
        if fontName == "System" {
            return NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: getNSFontWeight())
        } else {
            let fontManager = NSFontManager.shared
            if let font = fontManager.font(withFamily: fontName, traits: [], weight: getFontManagerWeight(), size: fontSize) {
                return font
            }
            // Fallback to basic font
            if let font = NSFont(name: fontName, size: fontSize) {
                return font
            }
            return NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: getNSFontWeight())
        }
    }

    func getDateFont() -> NSFont {
        if fontName == "System" {
            return NSFont.monospacedDigitSystemFont(ofSize: dateFontSize, weight: getNSFontWeight())
        } else {
            let fontManager = NSFontManager.shared
            if let font = fontManager.font(withFamily: fontName, traits: [], weight: getFontManagerWeight(), size: dateFontSize) {
                return font
            }
            // Fallback to basic font
            if let font = NSFont(name: fontName, size: dateFontSize) {
                return font
            }
            return NSFont.monospacedDigitSystemFont(ofSize: dateFontSize, weight: getNSFontWeight())
        }
    }
}

// MARK: - Settings Window Controller
class SettingsWindowController: NSWindowController, NSWindowDelegate {
    var colorWell: NSColorWell!
    var opacitySlider: NSSlider!
    var opacityLabel: NSTextField!
    var fontPopup: NSPopUpButton!
    var fontSizeField: NSTextField!
    var showDateCheckbox: NSButton!
    var timeFormatField: NSTextField!
    var dateFormatField: NSTextField!
    var dateFontSizeField: NSTextField!
    var dateFontSizeSlider: NSSlider!
    var lineSpacingField: NSTextField!
    var lineSpacingSlider: NSSlider!
    var fontSizeSlider: NSSlider!
    var alignmentControl: NSSegmentedControl!
    var chimeSlider: NSSlider!
    var chimeLabel: NSTextField!
    var chimeVolumeSlider: NSSlider!
    var chimeVolumeLabel: NSTextField!
    var dateFormatRow: NSStackView!
    var lineSpacingRow: NSStackView!
    var dateSizeRow: NSStackView!
    var onSettingsChanged: (() -> Void)?
    var onChimeIntervalChanged: (() -> Void)?

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 100),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Settings"
        window.isReleasedWhenClosed = false
        self.init(window: window)
        window.delegate = self

        setupUI()

        // Size window to fit content vertically, keep width at 380, max height 600
        window.layoutIfNeeded()
        if let docView = (window.contentView?.subviews.first as? NSScrollView)?.documentView {
            let naturalHeight = docView.fittingSize.height
            let clampedHeight = min(naturalHeight, 600)
            let newFrame = NSRect(origin: window.frame.origin, size: NSSize(width: 380, height: clampedHeight))
            window.setFrame(newFrame, display: true)
        }

        // Restore saved position only if it's still on a connected screen
        // (e.g. it may have been saved on an external monitor that's now unplugged)
        if let savedPos = SettingsManager.shared.settingsWindowPosition {
            let savedFrame = NSRect(origin: savedPos, size: window.frame.size)
            if NSScreen.screens.contains(where: { $0.visibleFrame.intersects(savedFrame) }) {
                window.setFrameOrigin(savedPos)
            } else {
                window.center()
            }
        } else {
            window.center()
        }
    }

    func windowDidMove(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            SettingsManager.shared.settingsWindowPosition = window.frame.origin
        }
    }

    func setupUI() {
        guard let contentView = window?.contentView else { return }

        let settings = SettingsManager.shared
        let labelWidth: CGFloat = 100
        let rowSpacing: CGFloat = 12
        let sectionSpacing: CGFloat = 35

        // Helper to create a label with fixed width
        func makeLabel(_ text: String) -> NSTextField {
            let label = NSTextField(labelWithString: text)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            return label
        }

        // Helper to create a row stack
        func makeRow(_ views: [NSView]) -> NSStackView {
            let row = NSStackView(views: views)
            row.orientation = .horizontal
            row.alignment = .centerY
            row.spacing = 10
            return row
        }

        // Helper to create section header
        func makeSectionHeader(_ text: String) -> NSTextField {
            let header = NSTextField(labelWithString: text)
            header.font = NSFont.boldSystemFont(ofSize: 16)
            header.textColor = NSColor.secondaryLabelColor
            return header
        }

        // Main vertical stack
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        mainStack.alignment = .leading
        mainStack.spacing = rowSpacing
        mainStack.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        // ═══════════════════════════════════════
        // INFORMATION SECTION
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("Floating Clock"))

        let infoText = """
        This is a minimal, always-on-top desktop clock for macOS.

        • Click on clock to show a calendar
        • Right-click on clock to open settings
        • The clock is pinned to the bottom-right corner of your main display
        • Post issues or suggestions on GitHub
        """
        let infoLabel = NSTextField(wrappingLabelWithString: infoText)
        infoLabel.font = NSFont.systemFont(ofSize: 15)
        infoLabel.textColor = NSColor.secondaryLabelColor
        mainStack.addArrangedSubview(infoLabel)

        // Section gap
        let infoSectionSpacer = NSView()
        infoSectionSpacer.heightAnchor.constraint(equalToConstant: 0).isActive = true
        mainStack.addArrangedSubview(infoSectionSpacer)
        mainStack.setCustomSpacing(20, after: infoSectionSpacer)

        // ═══════════════════════════════════════
        // TIME SECTION
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("TIME"))

        // Time Format
        timeFormatField = NSTextField()
        timeFormatField.stringValue = settings.timeFormat
        timeFormatField.placeholderString = "hh:mm a"
        timeFormatField.target = self
        timeFormatField.action = #selector(timeFormatChanged)
        timeFormatField.widthAnchor.constraint(equalToConstant: 140).isActive = true

        // Font Size
        fontSizeSlider = NSSlider()
        fontSizeSlider.minValue = 10
        fontSizeSlider.maxValue = 72
        fontSizeSlider.integerValue = Int(settings.fontSize)
        fontSizeSlider.target = self
        fontSizeSlider.action = #selector(fontSizeSliderChanged)
        fontSizeSlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        fontSizeField = NSTextField()
        fontSizeField.stringValue = "\(Int(settings.fontSize))"
        fontSizeField.alignment = .center
        fontSizeField.target = self
        fontSizeField.action = #selector(fontSizeChanged)
        fontSizeField.widthAnchor.constraint(equalToConstant: 45).isActive = true
        let fontSizeRow = makeRow([makeLabel("Time size:"), fontSizeSlider, fontSizeField])
        mainStack.addArrangedSubview(fontSizeRow)

        let timeHelpButton = NSButton(title: "?", target: self, action: #selector(openFormatHelp))
        timeHelpButton.bezelStyle = .roundRect
        timeHelpButton.toolTip = "Open format reference"
        let timeFormatRow = makeRow([makeLabel("Time format:"), timeFormatField, timeHelpButton])
        mainStack.addArrangedSubview(timeFormatRow)

        // Section gap
        mainStack.setCustomSpacing(sectionSpacing, after: timeFormatRow)

        // ═══════════════════════════════════════
        // DATE SECTION
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("DATE"))

        // Show Date
        showDateCheckbox = NSButton(checkboxWithTitle: "Show date", target: self, action: #selector(showDateChanged))
        showDateCheckbox.state = settings.showDate ? .on : .off
        mainStack.addArrangedSubview(showDateCheckbox)

        // Date Format
        dateFormatField = NSTextField()
        dateFormatField.stringValue = settings.dateFormat
        dateFormatField.placeholderString = "EEE, MM-dd"
        dateFormatField.target = self
        dateFormatField.action = #selector(dateFormatChanged)
        dateFormatField.widthAnchor.constraint(equalToConstant: 140).isActive = true

        let formatHelpButton = NSButton(title: "?", target: self, action: #selector(openFormatHelp))
        formatHelpButton.bezelStyle = .roundRect
        formatHelpButton.toolTip = "Open format reference"
        dateFormatRow = makeRow([makeLabel("Date format:"), dateFormatField, formatHelpButton])
        dateFormatRow.isHidden = !settings.showDate
        mainStack.addArrangedSubview(dateFormatRow)

        // Line Spacing
        lineSpacingSlider = NSSlider()
        lineSpacingSlider.minValue = -5
        lineSpacingSlider.maxValue = 20
        lineSpacingSlider.doubleValue = Double(settings.lineSpacing)
        lineSpacingSlider.target = self
        lineSpacingSlider.action = #selector(lineSpacingSliderChanged)
        lineSpacingSlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        lineSpacingField = NSTextField()
        lineSpacingField.stringValue = String(format: "%.1f", settings.lineSpacing)
        lineSpacingField.alignment = .center
        lineSpacingField.target = self
        lineSpacingField.action = #selector(lineSpacingChanged)
        lineSpacingField.widthAnchor.constraint(equalToConstant: 45).isActive = true
        lineSpacingRow = makeRow([makeLabel("Line spacing:"), lineSpacingSlider, lineSpacingField])
        lineSpacingRow.isHidden = !settings.showDate
        mainStack.addArrangedSubview(lineSpacingRow)

        // Date Font Size
        dateFontSizeSlider = NSSlider()
        dateFontSizeSlider.minValue = 8
        dateFontSizeSlider.maxValue = 48
        dateFontSizeSlider.integerValue = Int(settings.dateFontSize)
        dateFontSizeSlider.target = self
        dateFontSizeSlider.action = #selector(dateFontSizeSliderChanged)
        dateFontSizeSlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        dateFontSizeField = NSTextField()
        dateFontSizeField.stringValue = "\(Int(settings.dateFontSize))"
        dateFontSizeField.alignment = .center
        dateFontSizeField.target = self
        dateFontSizeField.action = #selector(dateFontSizeChanged)
        dateFontSizeField.widthAnchor.constraint(equalToConstant: 45).isActive = true
        dateSizeRow = makeRow([makeLabel("Date size:"), dateFontSizeSlider, dateFontSizeField])
        dateSizeRow.isHidden = !settings.showDate
        mainStack.addArrangedSubview(dateSizeRow)

        // Section gap - use invisible spacer so spacing persists even when date elements are hidden
        let dateSectionSpacer = NSView()
        dateSectionSpacer.heightAnchor.constraint(equalToConstant: 0).isActive = true
        mainStack.addArrangedSubview(dateSectionSpacer)
        mainStack.setCustomSpacing(sectionSpacing, after: dateSectionSpacer)

        // ═══════════════════════════════════════
        // STYLE SECTION
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("STYLE"))

        // Font Name
        fontPopup = NSPopUpButton()
        let fonts = [
            "System",
            "SF Pro", "SF Pro Rounded", "SF Mono",
            "Menlo", "Monaco", "Courier New",
            "Helvetica Neue", "Helvetica",
            "Arial", "Arial Rounded MT Bold",
            "Avenir", "Avenir Next",
            "Futura", "Gill Sans",
            "Georgia", "Times New Roman",
            "Verdana", "Trebuchet MS"
        ]
        fontPopup.addItems(withTitles: fonts)
        if let index = fonts.firstIndex(of: settings.fontName) {
            fontPopup.selectItem(at: index)
        }
        fontPopup.target = self
        fontPopup.action = #selector(fontChanged)
        fontPopup.widthAnchor.constraint(equalToConstant: 200).isActive = true
        let fontRow = makeRow([makeLabel("Font name:"), fontPopup])
        mainStack.addArrangedSubview(fontRow)

        // Font Weight
        let weightPopup = NSPopUpButton()
        let weights = ["Light", "Regular", "Medium", "Semibold", "Bold", "Heavy"]
        weightPopup.addItems(withTitles: weights)
        if let index = weights.firstIndex(of: settings.fontWeight.capitalized) {
            weightPopup.selectItem(at: index)
        } else {
            weightPopup.selectItem(withTitle: "Regular")
        }
        weightPopup.target = self
        weightPopup.action = #selector(fontWeightChanged)
        weightPopup.widthAnchor.constraint(equalToConstant: 200).isActive = true
        let weightRow = makeRow([makeLabel("Font weight:"), weightPopup])
        mainStack.addArrangedSubview(weightRow)

        // Color
        colorWell = NSColorWell()
        colorWell.color = settings.textColor
        colorWell.target = self
        colorWell.action = #selector(colorChanged)
        colorWell.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorWell.heightAnchor.constraint(equalToConstant: 24).isActive = true
        let colorRow = makeRow([makeLabel("Color:"), colorWell])
        mainStack.addArrangedSubview(colorRow)

        // Opacity
        opacitySlider = NSSlider()
        opacitySlider.minValue = 0.1
        opacitySlider.maxValue = 1.0
        opacitySlider.doubleValue = Double(settings.opacity)
        opacitySlider.target = self
        opacitySlider.action = #selector(opacityChanged)
        opacitySlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        opacityLabel = NSTextField(labelWithString: "\(Int(settings.opacity * 100))%")
        opacityLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        let opacityRow = makeRow([makeLabel("Opacity:"), opacitySlider, opacityLabel])
        mainStack.addArrangedSubview(opacityRow)

        // Alignment
        alignmentControl = NSSegmentedControl(labels: ["Left", "Center", "Right"], trackingMode: .selectOne, target: self, action: #selector(alignmentChanged))
        alignmentControl.selectedSegment = settings.textAlignment
        let alignmentRow = makeRow([makeLabel("Alignment:"), alignmentControl])
        mainStack.addArrangedSubview(alignmentRow)

        // Section gap
        mainStack.setCustomSpacing(sectionSpacing, after: alignmentRow)

        // ═══════════════════════════════════════
        // CHIME SECTION
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("CHIME"))

        // Chime Volume
        chimeVolumeSlider = NSSlider()
        chimeVolumeSlider.minValue = 0
        chimeVolumeSlider.maxValue = 100
        chimeVolumeSlider.integerValue = settings.chimeVolume
        chimeVolumeSlider.target = self
        chimeVolumeSlider.action = #selector(chimeVolumeChanged)
        chimeVolumeSlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        chimeVolumeLabel = NSTextField(labelWithString: "\(settings.chimeVolume)%")
        chimeVolumeLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        let chimeVolumeRow = makeRow([makeLabel("Chime volume:"), chimeVolumeSlider, chimeVolumeLabel])
        mainStack.addArrangedSubview(chimeVolumeRow)

        // Chime Interval
        chimeSlider = NSSlider()
        chimeSlider.minValue = 0
        chimeSlider.maxValue = 60
        chimeSlider.integerValue = settings.chimeInterval
        chimeSlider.target = self
        chimeSlider.action = #selector(chimeIntervalChanged)
        chimeSlider.widthAnchor.constraint(equalToConstant: 140).isActive = true

        let chimeText = settings.chimeInterval == 0 ? "Off" : "\(settings.chimeInterval) min"
        chimeLabel = NSTextField(labelWithString: chimeText)
        chimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        let chimeRow = makeRow([makeLabel("Chime every:"), chimeSlider, chimeLabel])
        mainStack.addArrangedSubview(chimeRow)

        // Section gap
        mainStack.setCustomSpacing(sectionSpacing, after: chimeRow)

        // ═══════════════════════════════════════
        // BUTTONS
        // ═══════════════════════════════════════

        mainStack.addArrangedSubview(makeSectionHeader("OTHER"))

        let githubButton = NSButton(title: "Visit Github", target: self, action: #selector(visitGithub))
        githubButton.bezelStyle = .rounded
        githubButton.widthAnchor.constraint(equalToConstant: 111).isActive = true

        let restartButton = NSButton(title: "Restart", target: self, action: #selector(restartApp))
        restartButton.bezelStyle = .rounded
        restartButton.widthAnchor.constraint(equalToConstant: 111).isActive = true

        let quitButton = NSButton(title: "Quit", target: self, action: #selector(quitApp))
        quitButton.bezelStyle = .rounded
        quitButton.widthAnchor.constraint(equalToConstant: 111).isActive = true

        let buttonRow1 = NSStackView(views: [githubButton, restartButton])
        buttonRow1.orientation = .horizontal
        buttonRow1.spacing = 10
        mainStack.addArrangedSubview(buttonRow1)

        let buttonRow2 = NSStackView(views: [quitButton])
        buttonRow2.orientation = .horizontal
        buttonRow2.spacing = 10
        mainStack.addArrangedSubview(buttonRow2)

        // Wrap main stack in a scroll view with max height
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsetsZero

        let documentView = NSView()
        documentView.translatesAutoresizingMaskIntoConstraints = false
        documentView.addSubview(mainStack)

        scrollView.documentView = documentView

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: documentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: documentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: documentView.bottomAnchor),
            documentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        contentView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    @objc func restartApp() {
        relaunchApp()
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    @objc func colorChanged() {
        SettingsManager.shared.textColor = colorWell.color
        onSettingsChanged?()
    }

    @objc func opacityChanged() {
        let value = CGFloat(opacitySlider.doubleValue)
        SettingsManager.shared.opacity = value
        opacityLabel.stringValue = "\(Int(value * 100))%"
        onSettingsChanged?()
    }

    @objc func fontChanged() {
        if let fontName = fontPopup.titleOfSelectedItem {
            SettingsManager.shared.fontName = fontName
            onSettingsChanged?()
        }
    }

    @objc func fontWeightChanged(_ sender: NSPopUpButton) {
        if let weight = sender.titleOfSelectedItem {
            SettingsManager.shared.fontWeight = weight.lowercased()
            onSettingsChanged?()
        }
    }

    @objc func fontSizeChanged() {
        if let size = Double(fontSizeField.stringValue), size >= 8 && size <= 100 {
            SettingsManager.shared.fontSize = CGFloat(size)
            fontSizeSlider.integerValue = Int(size)
            onSettingsChanged?()
        }
    }

    @objc func fontSizeSliderChanged() {
        let size = fontSizeSlider.integerValue
        SettingsManager.shared.fontSize = CGFloat(size)
        fontSizeField.stringValue = "\(size)"
        onSettingsChanged?()
    }

    @objc func alignmentChanged() {
        SettingsManager.shared.textAlignment = alignmentControl.selectedSegment
        onSettingsChanged?()
    }

    @objc func showDateChanged() {
        let showDate = showDateCheckbox.state == .on
        SettingsManager.shared.showDate = showDate
        dateSizeRow.isHidden = !showDate
        dateFormatRow.isHidden = !showDate
        lineSpacingRow.isHidden = !showDate
        onSettingsChanged?()
    }

    @objc func timeFormatChanged() {
        SettingsManager.shared.timeFormat = timeFormatField.stringValue
        onSettingsChanged?()
    }

    @objc func dateFormatChanged() {
        SettingsManager.shared.dateFormat = dateFormatField.stringValue
        onSettingsChanged?()
    }

    @objc func openFormatHelp() {
        if let url = URL(string: "https://www.nsdateformatter.com") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func dateFontSizeChanged() {
        if let size = Double(dateFontSizeField.stringValue), size >= 8 && size <= 100 {
            SettingsManager.shared.dateFontSize = CGFloat(size)
            dateFontSizeSlider.integerValue = Int(size)
            onSettingsChanged?()
        }
    }

    @objc func dateFontSizeSliderChanged() {
        let size = dateFontSizeSlider.integerValue
        SettingsManager.shared.dateFontSize = CGFloat(size)
        dateFontSizeField.stringValue = "\(size)"
        onSettingsChanged?()
    }

    @objc func lineSpacingChanged() {
        if let spacing = Double(lineSpacingField.stringValue), spacing >= -5 && spacing <= 50 {
            SettingsManager.shared.lineSpacing = CGFloat(spacing)
            lineSpacingSlider.doubleValue = spacing
            onSettingsChanged?()
        }
    }

    @objc func lineSpacingSliderChanged() {
        // Round to 1 decimal place
        let spacing = (lineSpacingSlider.doubleValue * 10).rounded() / 10
        SettingsManager.shared.lineSpacing = CGFloat(spacing)
        lineSpacingField.stringValue = String(format: "%.1f", spacing)
        onSettingsChanged?()
    }

    @objc func chimeVolumeChanged() {
        let volume = chimeVolumeSlider.integerValue
        SettingsManager.shared.chimeVolume = volume
        chimeVolumeLabel.stringValue = "\(volume)%"
    }

    @objc func chimeIntervalChanged() {
        // Snap to 5-minute increments, or 0 for off
        var interval = chimeSlider.integerValue
        if interval > 0 && interval < 5 {
            interval = 5
        } else if interval > 5 {
            interval = (interval / 5) * 5
        }
        chimeSlider.integerValue = interval
        SettingsManager.shared.chimeInterval = interval
        chimeLabel.stringValue = interval == 0 ? "Off" : "\(interval) min"
        onChimeIntervalChanged?()
    }

    @objc func visitGithub() {
        if let url = URL(string: "https://github.com/magmu/MaddaFloatingClock") {
            NSWorkspace.shared.open(url)
        }
    }
}

// MARK: - Clock View
class ClockView: NSView {
    var onClockClicked: (() -> Void)?
    var onRightClick: (() -> Void)?

    // Route all clicks to this view instead of the text fields inside it,
    // otherwise the labels swallow mouse events and clicks get lost.
    override func hitTest(_ point: NSPoint) -> NSView? {
        return frame.contains(point) ? self : nil
    }

    // The app is never frontmost, so accept the first click instead of
    // spending it on activating the app.
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    // Consume mouseDown so the matching mouseUp is delivered here
    override func mouseDown(with event: NSEvent) {}

    override func mouseUp(with event: NSEvent) {
        if bounds.contains(convert(event.locationInWindow, from: nil)) {
            onClockClicked?()
        }
    }

    override func rightMouseUp(with event: NSEvent) {
        onRightClick?()
    }
}

// Bottom-right corner of the full screen (ignores the Dock, so the clock sits in the true corner).
// Anchoring to the right edge means the window grows leftward when the clock gets wider.
func bottomRightWindowOrigin(windowSize: CGSize, screenFrame: CGRect) -> CGPoint {
    return CGPoint(
        x: round(screenFrame.maxX - windowSize.width),
        y: round(screenFrame.minY)
    )
}

func relaunchApp() {
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true
    NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: configuration) { _, _ in
        DispatchQueue.main.async {
            NSApp.terminate(nil)
        }
    }
}

func activateApp() {
    if #available(macOS 14.0, *) {
        NSApp.activate()
    } else {
        NSApp.activate(ignoringOtherApps: true)
    }
}

// MARK: - Calendar Flyout
// A simple Windows-style calendar: full date on top, month grid below.
class CalendarViewController: NSViewController {
    private let headerLabel = NSTextField(labelWithString: "")
    private let datePicker = NSDatePicker()

    override func loadView() {
        headerLabel.font = NSFont.systemFont(ofSize: 15, weight: .semibold)
        headerLabel.isSelectable = false

        datePicker.datePickerStyle = .clockAndCalendar
        datePicker.datePickerElements = .yearMonthDay
        datePicker.isBezeled = false
        datePicker.isBordered = false
        datePicker.drawsBackground = false

        let todayButton = NSButton(title: "Today", target: self, action: #selector(goToToday))
        todayButton.bezelStyle = .rounded
        todayButton.controlSize = .small

        let stack = NSStackView(views: [headerLabel, datePicker, todayButton])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 10
        stack.edgeInsets = NSEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        view = stack

        refresh()
        // Popovers size themselves from the content's frame, so give it its natural size
        let size = stack.fittingSize
        stack.setFrameSize(size)
        preferredContentSize = size
    }

    // Reset to today; called every time the flyout opens so it's right after midnight.
    func refresh() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        let now = Date()
        headerLabel.stringValue = formatter.string(from: now)
        datePicker.dateValue = now
    }

    @objc func goToToday() {
        refresh()
    }
}

// MARK: - Clock App Delegate
class Clock: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var statusItem: NSStatusItem!
    var settingsWindowController: SettingsWindowController?
    var timeLabel: NSTextField!
    var dateLabel: NSTextField!
    var clockView: ClockView!
    var calendarPopover: NSPopover?
    let calendarViewController = CalendarViewController()
    var updateTimer: Timer?
    var chimeTimer: Timer?

    func updateWindowPosition() {
        guard let window, let screen = SettingsManager.mainDisplayScreen() else { return }
        let origin = bottomRightWindowOrigin(windowSize: window.frame.size, screenFrame: screen.frame)
        if window.frame.origin != origin {
            window.setFrameOrigin(origin)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initTimeDisplay()
        self.initMenuBar()
        self.scheduleNextChime()

        // Re-pin to the corner when displays are added/removed, resolution changes,
        // or the Dock/menu bar changes size.
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: NSApplication.shared,
            queue: OperationQueue.main
        ) { [weak self] _ in
            self?.updateWindowPosition()
        }

        // Timers don't advance while the Mac is asleep, so anything scheduled for a
        // wall-clock time (chimes, the menu bar date) must be rescheduled on wake.
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            guard let self else { return }
            self.scheduleNextChime()
            self.updateLabelContent()
            self.updateWindowPosition()
            if let button = self.statusItem.button {
                self.updateMenuBarIcon(button: button)
            }
        }
    }

    func initMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            updateMenuBarIcon(button: button)
        }

        // Posted by the system at midnight (and on wake if the day changed while asleep)
        NotificationCenter.default.addObserver(
            forName: .NSCalendarDayChanged,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            guard let self, let button = self.statusItem.button else { return }
            self.updateMenuBarIcon(button: button)
        }

        setupMenu()
    }

    func setupMenu() {
        let menu = NSMenu()
        let settingsItem = NSMenuItem(title: "Floating Clock Settings...", action: #selector(openSettings), keyEquivalent: "")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())
        let restartItem = NSMenuItem(title: "Restart", action: #selector(restartApp), keyEquivalent: "")
        restartItem.target = self
        menu.addItem(restartItem)

        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        quitItem.target = NSApp
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc func openSettings() {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController()
            settingsWindowController?.onSettingsChanged = { [weak self] in
                self?.applySettings()
            }
            settingsWindowController?.onChimeIntervalChanged = { [weak self] in
                self?.scheduleNextChime()
            }
        }
        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
        activateApp()
    }

    @objc func restartApp() {
        relaunchApp()
    }

    func toggleCalendar() {
        if let popover = calendarPopover, popover.isShown {
            popover.performClose(nil)
            return
        }

        let popover = calendarPopover ?? {
            let p = NSPopover()
            p.contentViewController = calendarViewController
            p.behavior = .transient
            p.animates = true
            calendarPopover = p
            return p
        }()

        calendarViewController.refresh()
        // The app is an accessory app; activate it so the popover takes clicks
        // and closes when you click elsewhere.
        activateApp()
        popover.show(relativeTo: clockView.bounds, of: clockView, preferredEdge: .maxY)
    }

    func scheduleNextChime() {
        chimeTimer?.invalidate()
        chimeTimer = nil

        let interval = SettingsManager.shared.chimeInterval
        guard interval > 0 else { return }

        let calendar = Calendar.current
        let now = Date()
        let minute = calendar.component(.minute, from: now)
        let second = calendar.component(.second, from: now)

        // Find next chime time
        let currentIntervalStart = (minute / interval) * interval
        var nextChimeMinute = currentIntervalStart + interval
        var secondsUntilChime: Int

        if nextChimeMinute >= 60 {
            // Next chime is in the next hour
            nextChimeMinute = nextChimeMinute % 60
            secondsUntilChime = (60 - minute - 1) * 60 + (60 - second) + nextChimeMinute * 60
        } else {
            secondsUntilChime = (nextChimeMinute - minute) * 60 - second
        }

        if secondsUntilChime <= 0 {
            secondsUntilChime += interval * 60
        }

        let chimeTimer = Timer(timeInterval: Double(secondsUntilChime), repeats: false) { [weak self] _ in
            self?.playChime()
            self?.scheduleNextChime()
        }
        RunLoop.main.add(chimeTimer, forMode: .common)
        self.chimeTimer = chimeTimer
    }

    func playChime() {
        if let sound = NSSound(named: "Glass") {
            sound.volume = Float(SettingsManager.shared.chimeVolume) / 100.0
            sound.play()
        }
    }

    func applySettings() {
        let settings = SettingsManager.shared

        // Update font
        timeLabel.font = settings.getFont()
        dateLabel.font = settings.getDateFont()

        // Update color and opacity
        let color = settings.textColor.withAlphaComponent(settings.opacity)
        timeLabel.textColor = color
        dateLabel.textColor = color

        // Update alignment
        let alignment = settings.getNSTextAlignment()
        timeLabel.alignment = alignment
        dateLabel.alignment = alignment

        // Show/hide date label
        dateLabel.isHidden = !settings.showDate

        // Update display format and window size
        updateLabelContent()
        updateWindowSize()

        // Update position
        updateWindowPosition()
    }

    func updateLabelContent() {
        // The timer handles this, but we trigger an immediate update
        updateTimer?.fire()
    }

    func updateWindowSize() {
        let settings = SettingsManager.shared
        let size = calculateWindowSize()

        // Resize and re-pin in one step so the window doesn't jump when its size changes
        var frame = window.frame
        frame.size = size
        if let screen = SettingsManager.mainDisplayScreen() {
            frame.origin = bottomRightWindowOrigin(windowSize: size, screenFrame: screen.frame)
        }
        window.setFrame(frame, display: true)

        clockView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)

        // Layout labels
        let font = settings.getFont()
        let dateFont = settings.getDateFont()
        let timeHeight = font.pointSize + 4
        let dateHeight = dateFont.pointSize + 4
        let timeAttributes: [NSAttributedString.Key: Any] = [.font: font]

        // Calculate clock width (time label width)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = settings.timeFormat
        let sampleTime = timeFormatter.string(from: Date())
        var clockWidth = sampleTime.size(withAttributes: timeAttributes).width + 22

        if settings.showDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = settings.dateFormat
            let sampleDate = dateFormatter.string(from: Date())
            let dateAttributes: [NSAttributedString.Key: Any] = [.font: dateFont]
            let dateWidth = sampleDate.size(withAttributes: dateAttributes).width + 22
            clockWidth = max(clockWidth, dateWidth)
        }

        if settings.showDate {
            timeLabel.frame = NSRect(x: 0, y: dateHeight + settings.lineSpacing, width: clockWidth, height: timeHeight)
            dateLabel.frame = NSRect(x: 0, y: 0, width: clockWidth, height: dateHeight)
        } else {
            timeLabel.frame = NSRect(x: 0, y: 0, width: clockWidth, height: size.height)
        }
    }

    func calculateWindowSize() -> NSSize {
        let settings = SettingsManager.shared
        let font = settings.getFont()

        // Create sample text to measure using current format
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = settings.timeFormat
        let sampleTime = timeFormatter.string(from: Date())

        let timeAttributes: [NSAttributedString.Key: Any] = [.font: font]
        let timeSize = sampleTime.size(withAttributes: timeAttributes)

        var width = timeSize.width + 22
        var height = timeSize.height + 8

        if settings.showDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = settings.dateFormat
            let sampleDate = dateFormatter.string(from: Date())

            let dateFont = settings.getDateFont()
            let dateAttributes: [NSAttributedString.Key: Any] = [.font: dateFont]
            let dateSize = sampleDate.size(withAttributes: dateAttributes)

            width = max(timeSize.width, dateSize.width) + 22
            height = timeSize.height + dateSize.height + settings.lineSpacing + 2
        }

        return NSSize(width: width, height: height)
    }

    func updateMenuBarIcon(button: NSStatusBarButton) {
        let formatter = DateFormatter()

        formatter.dateFormat = "EEE"
        let dayOfWeek = formatter.string(from: Date()).uppercased().prefix(3)

        formatter.dateFormat = "d"
        let dayNumber = formatter.string(from: Date())

        let iconSize = NSSize(width: 24, height: 22)
        let image = NSImage(size: iconSize, flipped: false) { rect in
            let dayFont = NSFont.systemFont(ofSize: 7, weight: .bold)
            let numberFont = NSFont.systemFont(ofSize: 12, weight: .bold)

            let dayAttributes: [NSAttributedString.Key: Any] = [
                .font: dayFont,
                .foregroundColor: NSColor.white
            ]
            let numberAttributes: [NSAttributedString.Key: Any] = [
                .font: numberFont,
                .foregroundColor: NSColor.white
            ]

            let dayString = String(dayOfWeek)
            let daySize = dayString.size(withAttributes: dayAttributes)
            let dayRect = NSRect(x: (rect.width - daySize.width) / 2, y: rect.height - daySize.height - 1, width: daySize.width, height: daySize.height)
            dayString.draw(in: dayRect, withAttributes: dayAttributes)

            let numberSize = dayNumber.size(withAttributes: numberAttributes)
            let numberRect = NSRect(x: (rect.width - numberSize.width) / 2, y: 1, width: numberSize.width, height: numberSize.height)
            dayNumber.draw(in: numberRect, withAttributes: numberAttributes)

            return true
        }
        image.isTemplate = true
        button.image = image
    }

    func initLabels(interval: TimeInterval) {
        let settings = SettingsManager.shared

        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()

        let color = settings.textColor.withAlphaComponent(settings.opacity)

        let shadow = NSShadow()
        shadow.shadowColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        shadow.shadowOffset = NSMakeSize(0, 0)
        shadow.shadowBlurRadius = 1

        let alignment = settings.getNSTextAlignment()

        // Time label
        timeLabel = NSTextField()
        timeLabel.font = settings.getFont()
        timeLabel.isBezeled = false
        timeLabel.isEditable = false
        timeLabel.isSelectable = false
        timeLabel.drawsBackground = false
        timeLabel.alignment = alignment
        timeLabel.textColor = color
        timeLabel.shadow = shadow

        // Date label
        dateLabel = NSTextField()
        dateLabel.font = settings.getDateFont()
        dateLabel.isBezeled = false
        dateLabel.isEditable = false
        dateLabel.isSelectable = false
        dateLabel.drawsBackground = false
        dateLabel.alignment = alignment
        dateLabel.textColor = color
        dateLabel.shadow = shadow
        dateLabel.isHidden = !settings.showDate


        // Fire on whole-second boundaries so the displayed time flips when the real time does
        let nextSecond = Date(timeIntervalSinceReferenceDate: ceil(Date().timeIntervalSinceReferenceDate))
        let updateTimer = Timer(fire: nextSecond, interval: interval, repeats: true) { [weak self] _ in
            let currentSettings = SettingsManager.shared
            timeFormatter.dateFormat = currentSettings.timeFormat
            dateFormatter.dateFormat = currentSettings.dateFormat

            let now = Date()
            self?.timeLabel.stringValue = timeFormatter.string(from: now)
            self?.dateLabel.stringValue = dateFormatter.string(from: now)

            // Cheap safety net: keep the window pinned even if a screen change was missed
            self?.updateWindowPosition()
        }
        updateTimer.tolerance = 0.05
        // .common so the clock keeps ticking while a menu is open or a slider is being dragged
        RunLoop.main.add(updateTimer, forMode: .common)
        self.updateTimer = updateTimer
        updateTimer.fire()
    }

    func initWindow(size: CGSize) -> NSWindow {
        let settings = SettingsManager.shared
        let pos: CGPoint
        if let screen = SettingsManager.mainDisplayScreen() {
            pos = bottomRightWindowOrigin(windowSize: size, screenFrame: screen.frame)
        } else {
            pos = .zero
        }

        let rect = NSMakeRect(pos.x, pos.y, size.width, size.height)
        let window = NSWindow(
            contentRect: rect,
            styleMask: .borderless,
            backing: .buffered,
            defer: true
        )

        clockView = ClockView(frame: NSMakeRect(0, 0, size.width, size.height))
        clockView.onClockClicked = { [weak self] in
            self?.toggleCalendar()
        }
        clockView.onRightClick = { [weak self] in
            self?.openSettings()
        }

        clockView.addSubview(timeLabel)
        clockView.addSubview(dateLabel)

        // Layout labels
        let font = settings.getFont()
        let dateFont = settings.getDateFont()
        let timeHeight = font.pointSize + 4
        let dateHeight = dateFont.pointSize + 4

        if settings.showDate {
            timeLabel.frame = NSRect(x: 0, y: dateHeight + settings.lineSpacing, width: size.width, height: timeHeight)
            dateLabel.frame = NSRect(x: 0, y: 0, width: size.width, height: dateHeight)
        } else {
            timeLabel.frame = clockView.bounds
        }

        window.contentView = clockView
        window.ignoresMouseEvents = false
        window.isReleasedWhenClosed = false
        window.level = NSWindow.Level.floating
        // Show on every Space, alongside full-screen apps, and stay put in Mission Control / Cmd-Tab
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        // Without isOpaque = false and no shadow, a transparent borderless window
        // can draw a dark box or ghost shadow behind the text on recent macOS.
        window.isOpaque = false
        window.hasShadow = false
        window.backgroundColor = .clear
        window.orderFrontRegardless()

        return window
    }

    func initTimeDisplay() {
        initLabels(interval: 1)

        let size = calculateWindowSize()

        self.window = self.initWindow(size: size)
    }
}

let clock = Clock()

let app = NSApplication.shared
app.delegate = clock
app.setActivationPolicy(.accessory)
app.run()
