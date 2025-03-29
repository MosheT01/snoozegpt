# Create the Flutter project
flutter create doom_alarm

# Navigate into the project folder
cd doom_alarm

# Create core folders
New-Item -ItemType Directory -Path lib\core\services -Force
New-Item -ItemType Directory -Path lib\core\models -Force

# Create feature folders
New-Item -ItemType Directory -Path lib\features\alarm -Force
New-Item -ItemType Directory -Path lib\features\settings -Force
New-Item -ItemType Directory -Path lib\features\cv_upload -Force
New-Item -ItemType Directory -Path lib\features\onboarding -Force

# Create presentation layer
New-Item -ItemType Directory -Path lib\presentation\screens -Force

# Create BLoC folders
New-Item -ItemType Directory -Path lib\blocs\alarm_bloc -Force
New-Item -ItemType Directory -Path lib\blocs\cv_bloc -Force
New-Item -ItemType Directory -Path lib\blocs\script_bloc -Force
New-Item -ItemType Directory -Path lib\blocs\settings_bloc -Force

# Success message
Write-Host "`n✅ Doom Alarm Flutter skeleton created (no dependencies yet)."
Write-Host "➡️ You're ready to build!"
