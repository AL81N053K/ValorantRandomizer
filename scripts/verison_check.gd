extends Node

const GITHUB_API : String = "https://api.github.com/repos/AL81N053K/ValorantRandomizer/releases/latest"
const GITHUB_PAGE : String = "https://github.com/AL81N053K/ValorantRandomizer/releases/latest"

@onready var http: HTTPRequest = $HTTPRequest
@onready var version_popup: ConfirmationDialog = $VersionPopup
@onready var version : String = ProjectSettings.get_setting("application/config/version")

func _ready() -> void:
	http.request_completed.connect(_on_request_completed)
	version_popup.confirmed.connect(_on_confirmed)
	
	check_for_updates()

func check_for_updates() -> void:
	var headers = [
		"Accept: application/vnd.github+json",
        "User-Agent: Godot-Version-Checker"
	]

	var error = http.request(GITHUB_API, headers)

	if error != OK:
		push_warning("Failed to send update request: " + str(error))

func _on_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	headers = headers
	if result != HTTPRequest.RESULT_SUCCESS:
		push_warning("Failed to connect to GitHub.")
		return
	
	if response_code != 200:
		push_warning("GitHub returned error: " + str(response_code))
		return
	
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if error != OK:
		push_warning("Failed to parse GitHub response.")
		return
	
	var release = json.data
	
	if not release is Dictionary:
		return
	
	var latest_version = str(release.get("tag_name", "")).trim_prefix("v")
	
	if latest_version.is_empty():
		return
	
	if _is_newer_version(latest_version, version):
		version_popup.dialog_text = str("Current version: ",version,"\nLatest version: ",latest_version)
		version_popup.popup_centered()

func _on_confirmed() -> void:
	OS.shell_open(GITHUB_PAGE)

func _is_newer_version(latest, current) -> bool:
	var latest_parts = latest.split(".")
	var current_parts = current.split(".")
	
	var count = max(latest_parts.size(), current_parts.size())
	
	for i in range(count):
		var latest_num = int(latest_parts[i]) if i < latest_parts.size() else 0
		var current_num = int(current_parts[i]) if i < current_parts.size() else 0
		if latest_num > current_num:
			return true
		if latest_num < current_num:
			return false
	return false
