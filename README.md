# Eden CI/CD Scripts

A collection of Luau scripts that automate the deployment pipeline for Roblox game development. These scripts handle security checks, script injections, place cleaning, and place configuration to ensure consistent and secure deployments. These set of scripts are curated for the Lands of Eden Development team, but you can reference this repo to build one for yourself.

## 🚀 Features

### Security Checks
- **Script Validation**: Ensures all scripts are properly formatted and contain no malicious code
- **Reference Resolution**: Cleans up object references and resolves them to actual instances
- **Team Color Validation**: Validates and corrects team color assignments

### Script Injections
- **Automated Injection**: Injects scripts into appropriate services (Teams, ServerStorage, ReplicatedFirst, etc.)
- **Customization Management**: Sets up CustomizeManager with proper object references for clothing and tools
- **Service Distribution**: Distributes scripts across multiple Roblox services for optimal performance

### Place Cleaning
- **Reference Cleanup**: Removes temporary reference attributes and resolves object connections
- **Team Color Conversion**: Handles special color conversions (e.g., Gold color mapping)
- **Instance Optimization**: Cleans up unnecessary instances and attributes

### Place Configuration
- **Workspace Settings**: Configures physics, streaming, and collision settings
- **Player Settings**: Sets up character controls, camera behavior, and respawn mechanics
- **Chat Configuration**: Configures TextChatService for optimal user experience
- **Security Settings**: Disables potentially dangerous features like LoadString

## 🛠️ Prerequisites

- [Lune](https://lune-org.github.io/) - Luau runtime for script execution
- [Rokit](https://github.com/rojo-rbx/rokit) - Toolchain manager (optional, for development)

## 📦 Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd "Eden CI-CD Scripts"
```

2. Install dependencies using Rokit (if available):
```bash
rokit install
```

Or install Lune manually from [lune-org/lune](https://github.com/lune-org/lune).

## 🚀 Usage

### Basic Usage

The main script processes multiple place files with script injections:

```bash
lune main.luau <script-injections-place> <place1> <place2> ...
```

### Example

```bash
lune main.luau scripts.rbxlx game1.rbxlx game2.rbxlx
```

This will:
1. Load the script injections from `scripts.rbxlx`
2. Process `game1.rbxlx` and `game2.rbxlx` in concurrently
3. Apply all security checks, cleaning, configuration, and script injections
4. Save the modified place files

## 🔧 Configuration

### Workspace Settings
The pipeline automatically configures:
- **Physics**: Gravity, collision groups, fluid forces
- **Streaming**: Disabled for better memory performance
- **Spawn Locations**: Duration set to 0 for our custom spawn-protection system immediate spawning

### Player Settings
- **Character Controls**: Walk speed, jump power, slope angles
- **Camera**: Zoom limits, movement modes, occlusion settings
- **Respawn**: 10-second respawn time with auto-jump enabled

### Chat Configuration
- **Bubble Chat**: Enabled with custom configuration
- **Chat Window**: Disabled for cleaner UI
- **Input Bar**: Enabled for user interaction

### Security Settings
- **LoadString**: Disabled for security
- **Sound Filtering**: Enabled for content moderation
- **Banning**: Enabled for player management

## 🔍 Script Details

### Main Pipeline (`main.luau`)
- Processes multiple place files concurrently
- Orchestrates the entire deployment workflow
- Handles file I/O and serialization

### Place Cleaning (`clean-objects.luau`)
- Resolves custom REF attributes to actual instances. [Argon](https://github.com/rojo-rbx/argon) and [Rojo](https://github.com/rojo-rbx/rojo) don't handle `Ref` values when building, this takes care of that.
- Handles team color conversions
- Cleans up temporary references

### Place Configuration (`config-place.luau`)
- Configures all major Roblox services
- Sets up security and performance settings
- Establishes player experience defaults

### Script Injection (`inject-scripts/`)
- Distributes scripts across appropriate services to each place file
- Handles CustomizeManager initialization
- Manages object reference setup

## 🧪 Development

### Linting
This project uses Selene for Luau linting:

```bash
selene .
```

### Adding New Scripts
1. Place new scripts in the appropriate service folder within `inject-scripts/`
2. Update the services list in `inject-scripts/init.luau` if needed
3. Test with a sample place file

### Custom Initializations
Add new initialization scripts in `inject-scripts/initializations/` following the pattern of `customize-manager.luau`.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with sample place files
5. Submit a pull request

