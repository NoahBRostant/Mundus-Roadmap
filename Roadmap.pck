GDPC                �                                                                         X   res://.godot/exported/133200997/export-088ffdf57c57146017158f09cc8d2871-debug_font.res  0�            �]$N:FH��}H�0f    P   res://.godot/exported/133200997/export-24b10d3d6e25d4c11b0ef9cade7d20df-Main.scnX     �      �&��}1����|�O    `   res://.godot/exported/133200997/export-88b64831c63802f092f858b5945783cb-AssetDrawerShortcut.res         �      ��FF��a�%��x<(    ,   res://.godot/global_script_class_cache.cfg  @�     5      ���5����7��`�    L   res://.godot/imported/circle-solid.svg-b33084ceca5764fe5a1103602caa1407.ctex�?     �      �p�eɨ�Q��~ͨ    L   res://.godot/imported/class-icon.svg-c17de51589a7d30572bf401526524f64.ctex  ��      �      �������\�]y�kB    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex x           ：Qt�E�cO���    D   res://.godot/imported/icon.svg-5b01e8115f19d6d63dc265815ce29c75.ctex�(      �      G��� 80�I�[; e��    L   res://.godot/imported/minus-solid.svg-6e4306ecfb084f8f58a4ba012b98a51c.ctex �O     �      �K�9���g�ޙ�Ǔ�    L   res://.godot/imported/plus-solid.svg-fb3577135ff0b968dd962ade3a46456b.ctex  S     .      �y�7ݪh�k�A��       res://.godot/uid_cache.bin  @�     !      7 ��r�B�A���6	!z    8   res://addons/Asset_Drawer/AssetDrawerShortcut.tres.remap��     p       e�N�4�Q�(�    (   res://addons/Asset_Drawer/FileSystem.gd �      �      ��� ��Ql� �_     ,   res://addons/QuickPluginManager/plugin.gd   �      �      :r��u:Y�W�V��    4   res://addons/SmoothScroll/SmoothScrollContainer.gd  ��      o      ��TgɘՋ���sM    0   res://addons/SmoothScroll/class-icon.svg.import `�      �       �MفZ>v.TB�:�P�    0   res://addons/SmoothScroll/debug_font.tres.remap `�     g       ����W�n�_�+    $   res://addons/SmoothScroll/plugin.gd P�      �      mU�!���
��Qi    @   res://addons/SmoothScroll/scroll_damper/cubic_scroll_damper.gd  �      c      ���)�,K���{F6    @   res://addons/SmoothScroll/scroll_damper/expo_scroll_damper.gd    #      w      ����R}/C9P�r�a��    8   res://addons/SmoothScroll/scroll_damper/icon.svg.import p�      �       ��ԯ��b����&\m$    @   res://addons/SmoothScroll/scroll_damper/linear_scroll_damper.gd 0�      :      q~��e��".9���    @   res://addons/SmoothScroll/scroll_damper/quad_scroll_damper.gd   p�      P      ����/{���3��    8   res://addons/SmoothScroll/scroll_damper/scroll_damper.gd��      �      R�"{�����o�i��    $   res://assets/circle-solid.svg.import�N     �       � ��UC2�O�V�{
y    $   res://assets/minus-solid.svg.import @R     �       �9�<r�C�qX�0�2    $   res://assets/plus-solid.svg.import  @W     �       a4�r�-s��CB�5o[,       res://icon.svg  ��     �      k����X3Y���f       res://icon.svg.import    �     �       r�l�5~�ygFH�       res://project.binaryp�     6      ?��"��?��dg%�S�K        res://scripts/Main.tscn.remap   І     a       Έ✧����˼�#�    RSRC                    InputEventKey            ��������                                                  resource_local_to_scene    resource_name    device 
   window_id    alt_pressed    shift_pressed    ctrl_pressed    meta_pressed    pressed    keycode    physical_keycode 
   key_label    unicode    echo    script           local://InputEventKey_qmqdv �         InputEventKey          ����         	                          RSRC          @tool
extends EditorPlugin

# Padding from the bottom when popped out
var padding: int = 20

# Padding from the bottom when not popped out
var bottompadding: int = 60

# The file system
var FileDock: Object

# Toggle for when the file system is moved to bottom
var filesBottom: bool = false

var newSize: Vector2
var initialLoad: bool = false

var AssetDrawerShortcut: InputEventKey = InputEventKey.new()
var showing: bool = false

func _enter_tree() -> void:
	# Add tool button to move shelf to editor bottom
	add_tool_menu_item("Files to Bottom", Callable(self, "FilesToBottom"))
	
	# Get our file system
	FileDock = self.get_editor_interface().get_file_system_dock()
	await get_tree().create_timer(0.1).timeout
	FilesToBottom()

	# Get shortcut
	AssetDrawerShortcut = preload("res://addons/Asset_Drawer/AssetDrawerShortcut.tres")

#region show hide filesystem
func _input(event: InputEvent) -> void:
	if (AssetDrawerShortcut.is_match(event) &&
	event.is_pressed() &&
	!event.is_echo()):
		if filesBottom == true:
			match showing:
				false:
					make_bottom_panel_item_visible(FileDock)
					showing = true
				true:
					print("hide")
					hide_bottom_panel()
					showing = false
#endregion

func _exit_tree() -> void:
	remove_tool_menu_item("Files to Bottom")
	FilesToBottom()


func _process(delta: float) -> void:
	
	newSize = FileDock.get_window().size
	
	# Keeps the file system from being unusable in size
	if FileDock.get_window().name == "root" && filesBottom == false:
		FileDock.get_child(3).get_child(0).size.y = newSize.y - padding
		FileDock.get_child(3).get_child(1).size.y = newSize.y - padding
		return
		
	# Adjust the size of the file system based on how far up
	# the drawer has been pulled
	if FileDock.get_window().name == "root" && filesBottom == true:
		newSize = FileDock.get_parent().size
		var editor = get_editor_interface()
		var editorsettings = editor.get_editor_settings()
		var fontsize: int = editorsettings.get_setting("interface/editor/main_font_size")
		var editorscale = EditorInterface.get_editor_scale()
		
		FileDock.get_child(3).get_child(0).size.y = newSize.y - (fontsize * 2) - (bottompadding * EditorInterface.get_editor_scale())
		FileDock.get_child(3).get_child(1).size.y = newSize.y - (fontsize * 2) - (bottompadding * EditorInterface.get_editor_scale())
		return
	
	# Keeps our systems sized when popped out
	if (FileDock.get_window().name != "root" && filesBottom == false):
		FileDock.get_window().min_size.y = 50
		FileDock.get_child(3).get_child(0).size.y = newSize.y - padding
		FileDock.get_child(3).get_child(1).size.y = newSize.y - padding
		
		# Centers window on first pop
		if initialLoad == false:
			initialLoad = true
			var screenSize: Vector2 = DisplayServer.screen_get_size()
			FileDock.get_window().position = screenSize/2
			
		return

# Moves the files between the bottom panel and the original dock
func FilesToBottom() -> void:
	if filesBottom == true:
		remove_control_from_bottom_panel(FileDock)
		add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, FileDock)
		filesBottom = false
		return

	FileDock = self.get_editor_interface().get_file_system_dock()
	remove_control_from_docks(FileDock)
	add_control_to_bottom_panel(FileDock, "File System")
	filesBottom = true


 #Written:
#Date: 01/26/2019
#Author: Markus Septer
#Contributors: David Boucher, update to Godot 4, 10/17/2022

#How to use:
#1)If you already have "addons" folder in "res://", jump to step (3)
#2)If you don't have "addons" folder in "res://" create it
#3)Drag and drop the folder this script is (should be named "QuickPluginMaker") in into "res://addons"

#Folder structure should look like this: "res://addons/QuickPluginManager"
#NB:if you wish to change name of this plugin through godot editor you also have to change var "PLUGIN_SELF_NAME" to same name

@tool
extends EditorPlugin

const PLUGIN_PATH = "res://addons"
const POPUP_BUTTON_TEXT = "Manage Plugins"
const MENU_BUTTON_TOOLTIP = "Quickly enable/disable plugins"
#if you change name of plugin from godot editor this variable also must changed to same
const PLUGIN_SELF_NAME = "QuickPluginManager"

var _plugin_menu_btn = MenuButton.new()
var _plugins_menu = _plugin_menu_btn.get_popup()

var _plugins_data = {}
var _menu_items_idx = 0


func _enter_tree():
	_plugin_menu_btn.text = POPUP_BUTTON_TEXT
	_plugin_menu_btn.tooltip_text = MENU_BUTTON_TOOLTIP
		
	_populate_menu()
	
	_plugins_menu.index_pressed.connect(_item_toggled.bind(_plugins_menu))
	_plugin_menu_btn.about_to_popup.connect(_menu_popup_about_to_show)
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)


func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)

	if _plugin_menu_btn:
		_plugin_menu_btn.queue_free()


func _item_toggled(item_index, menuObj):
	var is_item_checked = menuObj.is_item_checked(item_index)
	_plugins_menu.set_item_checked(item_index, not is_item_checked)

	for plugin_name in _plugins_data:
		var plugin_info = _plugins_data[plugin_name]
		
		if item_index == plugin_info.menu_item_index:
			var plugin_folder_name = plugin_info.plugin_folder
			get_editor_interface().set_plugin_enabled(plugin_folder_name, not is_item_checked)

func _refresh_plugins_menu_list():
	_plugins_menu.clear()
	_menu_items_idx = 0
	_plugins_data.clear()
	_populate_menu()

func _populate_menu():
	#Get list of addons directories
	var addons_list: Array = []
	addons_list = get_list_directories_name_at("res://addons/")
	#print list of addons name
#	for a in addons_list:
#		print(a)
	
	#Get files path of each addon .cfg
	if addons_list != null:
		for addon_name in addons_list:
			var addon_cfg_path: Array = []
			addon_cfg_path = get_list_path_of_files_with_ext("res://addons/"+addon_name+"/", ".cfg")
			if addon_cfg_path != null:
				#If more than one cfg file exist, only keep plugin.cfg
				if addon_cfg_path.size() > 1:
					var idx = 0
					for cfg in addon_cfg_path:
						if cfg.right(10) != "plugin.cfg":
							addon_cfg_path.remove_at(idx)
						idx += 1
			
				if addon_cfg_path != null and addon_cfg_path.size() > 0:
#					print(addon_cfg_path)
				
					#Add addon to _plugins_menu
					var conf = ConfigFile.new()
					conf.load(addon_cfg_path[0]) #take the first .cfg file found in each addon directory
					var plugin_name = str(conf.get_value("plugin", "name"))
					var plugin_info = { "plugin_folder":addon_name, "menu_item_index":_menu_items_idx }

					var isPluginEnabled = get_editor_interface().is_plugin_enabled(addon_name)

					if plugin_name != PLUGIN_SELF_NAME:
						_plugins_menu.add_check_item(plugin_name)
						_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
						_plugins_data[plugin_name] = plugin_info
						_menu_items_idx += 1
		
		#no need to increment "_menu_items_idx" as we already did it above
		#add plugin itself as last item to menu
		_plugins_menu.add_check_item(PLUGIN_SELF_NAME)
		_plugins_menu.set_item_checked(_menu_items_idx, get_editor_interface().is_plugin_enabled(PLUGIN_SELF_NAME))
		_plugins_menu.set_item_disabled(_menu_items_idx, true)
	else:
		print("An error occurred when trying to access the path.")

func _menu_popup_about_to_show():
	_refresh_plugins_menu_list()


func get_list_path_of_files_with_ext(path: String, ext: String):
	var path_array: Array = []
	for file in DirAccess.get_files_at(path):
		if file.ends_with(ext):
			path_array.append(path+file)
	return path_array

func get_list_directories_name_at(path: String):
	var path_array: Array = []
	for dir in DirAccess.get_directories_at(path):
		path_array.append(dir)
	return path_array
          extends ScrollDamper
class_name CubicScrollDamper


## Friction, not physical. 
## The higher the value, the more obvious the deceleration. 
@export_range(0.001, 10000.0, 0.001, "or_greater", "hide_slider")
var friction := 4.0:
	set(val):
		friction = max(val, 0.001)
		_factor = pow(10.0, friction) - 1.0

## Factor to use in formula
var _factor := 10000.0:
	set(val): _factor = max(val, 0.000000000001)


func _calculate_velocity_by_time(time: float) -> float:
	if time <= 0.0: return 0.0
	return time*time*time * _factor


func _calculate_time_by_velocity(velocity: float) -> float:
	return pow(abs(velocity) / _factor, 1.0/3.0)


func _calculate_offset_by_time(time: float) -> float:
	time = max(time, 0.0)
	return 1.0/4.0 * _factor * time*time*time*time


func _calculate_time_by_offset(offset: float) -> float:
	return pow(abs(offset) * 4.0 / _factor, 1.0/4.0)
             extends ScrollDamper
class_name ExpoScrollDamper


## Friction, not physical. 
## The higher the value, the more obvious the deceleration. 
@export_range(0.001, 10000.0, 0.001, "or_greater", "hide_slider")
var friction := 4.0:
	set(val):
		friction = max(val, 0.001)
		_factor = pow(10.0, friction)

## Factor to use in formula
var _factor := 10000.0:
	set(val): _factor = max(val, 1.000000000001)

## Minumun velocity.
@export_range(0.001, 100000.0, 0.001, "or_greater", "hide_slider")
var minimum_velocity := 0.4:
	set(val): minimum_velocity = max(val, 0.001)


func _calculate_velocity_by_time(time: float) -> float:
	var minimum_time = _calculate_time_by_velocity(minimum_velocity)
	if time <= minimum_time: return 0.0
	return pow(_factor, time)


func _calculate_time_by_velocity(velocity: float) -> float:
	return log(abs(velocity)) / log(_factor)


func _calculate_offset_by_time(time: float) -> float:
	return pow(_factor, time) / log(_factor)


func _calculate_time_by_offset(offset: float) -> float:
	return log(offset * log(_factor)) / log(_factor)


func _calculate_velocity_to_dest(from: float, to: float) -> float:
	var dist = to - from
	var min_time = _calculate_time_by_velocity(minimum_velocity)
	var min_offset = _calculate_offset_by_time(min_time)
	var time = _calculate_time_by_offset(abs(dist) + min_offset)
	var vel = _calculate_velocity_by_time(time) * sign(dist)
	return vel
         GST2   �  �     ����               ��       ��  RIFF��  WEBPVP8L��  /����-I��6�������Y��b.Ĉ;��$	�$��N�"2���ض� ����Jf�����m���~�������%�"%J4�����Ѷ"�E[���e&!+{o��(۶�6��_�M�D�8���<���������������������������������������?H�;*��x�M_]��Qh�*Ϙ��b 
   �   �B �!Je)��2߈�̓��*�P !� ,,.������'⑊�Uq1(� � �@�:����������ud��_�?A"��;E������x����NH���B���{�����[	rs��m��b�(��9�Q����V��;���ex��~�%�o8��ȁp�+�<����Y-$3a5ּ =U{���
|1*�e����*�nsX�^3?6_�{��#Ԗ
xE��6��U��^��d�l�sn1p
6�����\����ox��b鋷h�7��|O����tW��(��۲�v��3�.A���YX	�gh���x��j�.�mWW�}�®o&l�:�����Ό������d �I@���.k�?6c�P��:������i'�q��_D[���T^ %�PL'�H��o"p�Z��4���b��,["�nE8�σ(G�Q&GD[�K�G����j	éU$	�,���S�{����Ffq�� 	����E$��-L���1
�S2x�� ����k�A*�P:�s:��*��L���#���<1�d鎥��U�X��Z �f�>���Ȭ��ȁ�m?<xm��QD��q�O�i��J�eX��䩅T{J%���T�䢮�U����FQ8�s�L�HV��,�o3$�̎�h��%Qe^��q�<�#�xL�L��v7jw[�O�o6pR&zO�d��r\�oK[r�yK��??hP��s0�A�7Go13vAx�A��/�'�X2�-�_2k��s<$F�ɪC6��8k���*�mY�S�B����/@>�������IU��Es,����h����%�
�{AŨu�:^d�e��h�L�")��a�������B�PAW��G��#��z2B2�ʕ�zQ�BX��.�����R(�����~�*)$�~	�CZ���x2S�R��4��"��Iy[�{e@����C�����2��d��p�bb=�J��޻?�oD+Z9��A�~�Paۭ���A�TA<����Y�/Cu�������J�T��8N��(�yb#�rꌶCX���v�U�P(�}d޸�`� ڻ�&rs׏(���6�&d�~o��x�g��C���!�H��M�㘏ӗ�-����6!y�x+���ȼkUf�D�!x�4$*��g!,O�!�k�x��*�]����Upi�4F�J�("��c���+6�/K5o�Oվ}ȼc�|3����'�R��`
�CX���0�k\�7|�(�n+�@A�A�h�x�%ӗ�BX��?�i�wte�믢���G�X	1e��@K"�Ck�GF�����r�'���rD���  �X7���+h���_څx��9-UPN�!�z��<�++՚,�c����Q����G��N����@�!U�AX�Pˢ[���}�:�X�:�?���~��9R��/���K�-䄫�Kc�wh�?�,~l�W���[�H_(}a��u�7 �PWT���j����ve��}غ=�o��=.���"i��	`'$U��jw��vW'��a�(L��yȼ=U��S��zI�������P�����\�[�Җ�6)��%��U"�OA.�ߖ��W,+�O2�B���	}�%o���䧓��|!�]k���݊�o��P�;�7�����-��v�y�,��.
��mEN@X��.5���J��拓D�vXq�BY�5�.p�R��i�e߆x[�XϝxX��]�5���B>��dGӱo�Ӻ�8+���SΞ�C�jJ�Rw_0�E��gɉ�Α�WY3@�^}�d ||�Q��[(kt*FM�zj�V�o�x��!W����s�� �  �C*o%��z��<���y�?�z89�����[*�Œ�8��䟾T���(��Df�����wjH���T�$@1 ����w�; ��7�����  �V�Aj,�{f}i!$�-�ްT �O>&f��BJ�7�y� �d6�	���<�4&I (!{co|g�qx�-��BA d`ڨW�,96�އi�(�FWV�ӏI�s��z�HW$�́0�Ӣ�ǞR� q��Goo�KCA��V�꥾������{��d�#��}�Z��b��FW��B�
���w�OU �a{��ǿTna�7?�Q�7����4t���U��^TYoMpHԐ�^c�j����M(B��>��(�xU��Y��ޔ؈��UV���'��	��`DD�`o�C�W<ۿ�:G��At���o��ɀ�#�p���ѫ��!��xi{��Q���h�3�ᠦRQ��w!�J���)���V!�q���hDtEb�{���0|o�"���7��U��8lo�7/�7�-� �4����i	z�o����e� �a�#BZw��"��L���&�i���)�J�Fl�F��a���;a�,E�ݖ���-��
�a�$d��W��g-�v~"�"C!L.Y�m�WɈ{�=��(�������#�4!3!��%N��߅*3�,!��zu�y��	2��-f���v�@���1a��^�1""�}���3�u��z�?�h�"�-����_<G_a,+�������' �I?�J��^����{�m���TG�T���'�fX'�j�Յ���X3 ��}�g�,�KU�	�<��:�+�q����鿕��ns��q��ARI?rd�W[��U�B��~�@ --����z9b0����(5h�W����p26OJ����7����ى H&z��~���&�kJl��[��8� a�P˨�Q�֊����
Ra�����IP$6b�B���{:B��}�+��*�g��b]�=�D�� ��������R�����O��Y,�Q��fR�_�zkm-�u��z����v���z�UE������^����$�7]�!g��ul�e�t7��7-�H�����p��E=H���r�d"�����ZR��R�	
�=km����b#�W��B�@Q�=�?wyl���D��O�hD#l���������#� ���h�lo��,�3����b!}Y����Z
�b��a��넡P׷m�(�P�Za��_�x^��+*�Z�D���@B����>�Kwk�6�@83�c��m?e�Ds/�cn��y�%c��J&@8�'7v/�SH�{=bJ"�0�a8w�Qc=�Q�c�B���)��(���XHc먊�n'"�Ca�������-�v�`ř�#rd0��gUd�9C��j�9�:��y��I���~�Z���ݟ��@�B�N��Y]�1����OYȞ:�yK�("u�gK��8X	�4Ժ�>U��y�o�����v�w��7]�����A��f���XInʙk�����>����_{y鶴��-F-;��1]�)���NT9���0o"Mr��*rC�U��$�z�B��~�����^G/*�|}8�[���ny����R	j��`-��(��nTA<��$p��6
���"î�^���(g��T{^.w�
��0s�<�#c�ZB�(n�7����km�*�� �6BzB�Y� ����x��'g�&G%�z�
YA� 9pSrN��F�ܾ�ouEY�#x�*!m[r�$p*�j���w�{ �a�}k���QuڒeX��DWt��
��-5��Ӧ㹔�ͭ�Mʁ�ԇ��A6G!!���i���o�
���u8�}���=�`�I��.G���>�;
"Xa����v~��jw���R��9�,����V�8�m{@aj�9`$Woo"nSWԃ�O�}���f�i� %���@�m
U֞s,�Pb{s�\�U(� �������֮	"�n��
,ǡ���9doo�s��]���B�B�+_�z</�b��ߧ�_�F��pR  �u�9U2���M.�/��5�s	p��_�}%���<s�?�ॗ$�j~���)I�;�F:���x(.����D�k���W�$'� ۠( ]����U���p���*΍�ԕ�����m��(Q,�����@{\��CW�rD;ۛ�UΞ6�ԠܞvF<TA��	�G)>,��^�����[.��̝�u����Ӯ-�� �����T�z�u�D�,>����
�TW���,�1�ۖ-�*�b^����K;����x�A�/NB�j�%�u����QrO`��P�Z��ڷa"����0�e�9�+�z����� ��x�Ԋ���:��k� �h�	��#Ea��}j�A;�¥@���s� +V���c���~o(�j�����v�G��GE���C�PqԺk� �!B�v���q�K>�mi�yU(�:���߫�=�G�˝M��+��������w�`�T8���3-Z�E��J�hD�8�d��ܛh�P�����~H����Z��wd,�{'̈"��V�JJ� ����G��\��p�֍���A�^�d�?ˆ�)	���IU�k����pr88In�#Z����$�����*�(�V�]������	
r�cW�tx��T���M�Ѣ]��=�h��̇p����(����I#g���]���I�Ţ�����֍iF���5Cn�z�����ʁ�>F#G�(b�^�Uo��]�n��i��(��	�� �\�	����X,�.�l���`T�g�l�*d�p�$�R4�I��!�������!��f1*i�b)������薻+� r�W��˂��N��Fl8�ID�n՚1|zX;�������zM������!��F4�q������a��pݐ��X/���+�Q����0��b|��1��C(!��� A�!\Ħa��L""��0���Qz�[ᅒa���ͽ9:��a9zUI�l���������O�>Z�mg�YU��Y�T�p	��!��/monG�p�8�s���i a02;Ϊ��hU`��J��/~ChX,98z�����p6r�dV�6�A!�i�(��Y� ��*������X L�p2ο�7���J"qpx0�KD%�:�ϲ%Z�F��`��z{��ǭ�Z�A#Vȇp�@����#6�UBn�0�g�y�g��\s����V�nlo
�`��3�E6J��b�|:�ɳ*��Y���x����������~�b{C䀦��M��;rd��Z�#��_-��X,+h�9W����ۛ*�NLr{6�I����b���G��T<��>K"*������Z�QEF��(L�W��F��%���zo�-����c����z�%s044r��U�+g��kS�l�B�m��h���8z%�`���9*���,^"�
�K�A�=�A~�p1Ӎ��sjCKs���*�X�^���@�8�M�F4�B����ȑn���EQ��;5�F�s�g�BX2V*�{��}�!βGI$�΄���z�s�P���ʱ0�c`,$�5n��b�sp��P�y�LP8�_p�'G��<��b�?\���h�gc����}��EN��s�K�g���Rp�� ��)!��%F&���ԗ���*�b�1��e� ����a��	��8NxѪ�+���,a����O�� �Œ�8ۨ{%p#L�Z9
	Qօ� �~(8�VR�^r���j����Kb��l*�w��)QH�:�d���@:��*���cy��-���q���0�cB�s�l�b(�v�jw���2���>�B���=������7�H9a p6���[ˢ�d��C��v7ZK��	9�/[eb�򪬷 @��RC��ca�9��E>$�t|��df�P�s$sq.1b�`o�C�-��S!G,,�5�!1ra��]!�ut|
�!���*Jl�ƵEWw�Dd�>=�R��oU�jF"�Ci�ǳ*  ��U�5ۛ��Vy�U+��].9��sڦ��ź)G_�"�A��>�~C�t_�1�S�[�.Q�7�m聏MëkKtUA2�: L󷉯>�?�Z���s�3w���O���} &e��d�o]Z�k��(L�N���Ջ�� 2w�8�(��ܓ�!��b��C� t�P�{і�� ����Էg����/�����PE��D.���rK;� ɳ1��C������1��f�h�u�ﭱ�%���%���Sj(X@���[�E}	��S�ϣ�R<kI�v�y�rO�]��@4Y������%�k��ګT���+sSG��c$tE�����Z��T��_���� �jhwe��VC��F��*��	�A�.�´����{� ����>���q�A��F�g�����X����P�[52�#��K�j�K(���+֤x�yi�a�~Dd"��V˶d.�sX,��N�ӗ3|�x GȾc5 4b(~�$�#s?����_-�l2���m�{ܒH���a��(稂"p��B�����?X2֌����w�{D���V���g���[�o�q;�J$��D��˪�&��O\��d߱@V��p?ڃ����68���F�zO��� �m$�Bd<�K"�pNmȇp�+��59rq!��W���#�h��}E��!s�m��=XQ_�+@撶]�A"����{�(4q)��J�@���)��a�=t�0�\�����놨!#�#�yy^״�"r�t�H�pz�ڹ���Y��3�L�vF��>w��{���a�5��YngA%C=8��C��uM��]U(��"���`$v?�#�A�LK���)e����[9h����'[$�z��˽hgdڙfCy�җUE���wF��@x^k!�h:��qOl�]`M�������Sr(�ױ���|fZ�r��V$�!@��t>GDD���s��CW����-��Ʈ�ﭑ#����ra�������"�Lׁ��'
ɧD�R02f�Hd��*^m�04d�rG �Fb�02���ڶf�u�4ɑn�U 2��H�	�܎��n��q����%#A_�����M�JP[!�i`-��(��b�-�|$�&���ݶo���ɟ��n�!3GRC���T��F��~7��H��ZD��I�T���i a4�?��Җ��R�ԑd�'�ӈ��o%ș��8��B�����w�c4g��W ���Gz����F���� ���}�yG��Z��l��]!�{�!�w<2� �Җ{Ad�3#Q�Q2�/4h� Ҡf4��]�/���jc	����LdnǾ��x�m��L��H�k#s)�}���w�R�T��V�!h�H�n�vW�f������K��1�X�\�~Dh�pE*�~*!��92�� 2�߱�B3����#�̭����6tQ��(�}TA���9쁔����Z�O`�Hn���CDF�8v;o{bdb:�d�'�RE^?�Q8�
go�y�h��'Tn�B(�!?�A�B�[a#cs�HԲ�=DQ����
9�]�~6���"�-nl��'��H{S}od��r���(
�^����6�Zu-�P�́p2*����
go���hw=BD�,:gmA�+��}��m��؈���Έ�*H��W���d���F�|@T�� @��͓9��K;����x�!n������!#��B\��?L���Œ�v����[ur� �'�B�Q�p�!,�)���d���u���p�?������!UP�C���~H����C�5��w���1'�@�����#Fx�$yg�?����g#�����#�gB�7J��Nf��I����N�\
��3�\j���HU.M���73� 
 ��-9��;>��oT���l2�2�ݐA><l��j~G���P�z���	)q&q����o<�g)���� r����p�ln�����|��PϞ��;%s��G��o!�ֻ�s
M.@��'���g}"��!�!���E��Vbp � 7C8;q�Q�,�A�e����-��i�W~rT� �ǳQ�����;>
��9 � ��\��-+���f{�<	�?������v��e'��a� Ⱦ���I��g3�z��~���� �D��5�l�ɬ�w��� hK4��7}N��`���[�Ugj��(_(T�prЛȾ�!(���-�!"{�=�Ɠ� ���P(��� w߹&G�>
ڒ�h:B8��""���V�IP�(}��@89������1@��P�eg��Χh��$`	�P(>���z�?��ߖ�@h���o��F�����nj���S�� j,�Җ�|���٧�Q&����:&Af��(�:�� ����!@!2�&�D�7��o�$S �={�j�q@n�p.Xm�,��&!_�L� �e�ɬq��"��;��>V�IP�u{����|pb���`׹��8�[���<9	�2_{��ɛ�V�ρ�>
U©��=��a�B�P�Nd���C{h�����`{|�d\���z��8��>JF�4	󶑩�Y{��^;�K��c�+ ��S�Y�,=#cO�A2�\\)���m����@���S��f�VU��9	2���R#FL����g��O��>U!���l�R@ޘ�k�K�#����FR2� [���hpe{�����$��K�?	���n��$x�Q��	� `�>N��OFmo*�j@�L�������5�L���_13�D� I'�>���>nd�e�
��37bT��: �S'��F�FU�	F�L��<,2/;��b�z�����|l�
�C-��hd^(��$h��ȼ��b��_'��  �@+C��<Pমn$�g�y1�bd^�Lu�����6qڳ����92N��P�Q��	H�6	�;ld��5�vW�L?�Y`d> ��y�4p��-v�:z}Kd��I��	� �!�V���۲��i` ��w� "#λ�v��t'�_���D�۪ݕ�n�|�*��Ӑ�$: "C�?�l!����ID�Dd��0I��8��� ��g!�	���
��$|\�C�۝SmÆ�����#������{���|d`�$��T����`#c��g��c42�  ��s@v�7W����:�"#G'�ί|;?���L����?�A�I��B���
�T�PCڿQ��p�@���D��m���Ib�dld��e ��O�*?��8��O!(�9�,�B�|���9B�CB��݄< �$ �'Wګ����a^62��!�2�LnE!��@�$ d~@d$F�:睍��;u7�gHU�BI��}���-6	8��W�����@c��Sr��m�=KfU�;2��5g�	�J�?6��ͷ�+?	9���"6*����׌���_$�����' '�����־ߧ�$�^� ��w�;���p��_/�%cM:�9�̪�d�:'p��7����pN�I����T�~G���	�  xX(��\�\2������z7qnd�-{O��
+��g�{`02�6g�:��̪��d���㵴h�"�=�ɍ���?��_���e<^L2:?�w�(+y��LoQq�{sf�a��T��ÑAϋa���#�bq�?i4r!��l���[?�L�wO�������{��������a���re  W3�oUZ�`hdh�M���|��M����Z��a2���3��'Z �ǂ]&��)72n��A�7�N�q�w��J���G#C	"�gi���"""�~�	 }'AM�͎��r��E����2�qd���t"�L��"s#QD�g02��'a��p?G#C�ұ8�6��<2�9���Ų6��Z8��S1?�$i^�5�W;�H9�
���-[�o�Ƚ�P�8<t��g���Y2����ިD��9MF��|�hX*��#����詡P(Tב��ڙf�v�� 2d�@䈕e����y{�����<8=�l♡TЈq�팊��>Cd�ၬK�/�0��IP���-G�
�7�Id��ͤkEf������hK�����j+f���xVoK�/[�eX#7Tb�$X<�5"���}VFte�[n�8�(Ί�~�/2��$����	��Gzv���� ���IV�d-�����Q��8�b��s��4�P����n�v�z%�Fn']E�%��-Ȧy�b�tu|�Ձ h� pΞR��ǯ��?7��9"�����\٣x�ҞWf��O�F���/��.�Ӡ���}�A��y��8��[ 2�x�5���O�7*jȨ�>�7Z'7��i�:�q�&d��2!��r�:(j�eŘD�_�d�u�h�i[2(*����7�erG�������e\��+[2�Ç��a����t��6[��~�S �6	�΀_�!!��c�W��"��t����D;��d��	��<@���I(J�K�g}����ߖ��l��+H�?��>U����ZH&ɟC�ղ-�ErOyiϫ��v~Y���CX�{r��Ds;��At|8��
������Vy{��I���{^ 'c���J�P�Z$o �n+�{���]ș�KH dģ�����\cO)H@F���&Wy,A?@Fmo*����D�\�D�m�!�C(�0��)�C�'�����C<��{أc��L�"Q2��#H:���� @�I@FHarb�Z�Urci秝�o�C�����_&ĘIm��Fկ�C�$ dL��v�7}~��m��ʬ��KHȿ�|��c��"ɀ�ߢ�1#3��-=	8=�7q�����v7��g��a�!^���^.���n��F��;�����*� F������jw���A��f� t�/Q�Qa���C����@ۑ̐�F��b��%yXd>
P2����������5@[2m5���ar���+�+��`͜ L����Uq��3)2�m'K:C�������B�D-���{d�ƿ![H<1DH&t�$�o��@�I&����˒�0�{"���ek���{F������.�cĈ�� ����k�_���\\\/�|GT�d�ޓ�>��<L�LLD���Yp���>.W֏���\����o���Nd�3����݃b���7��:��XL�1>�����oT�K3�I�7��q�y�F�z��1q12�掋�1Yp�g`�JUF=	2� b,��I��Pl�����DB���l٪�������0/��1]�p8�x�����8��_��c��Dj�OXo٪�Adȇ��z"Jf$GƉȢ���gB�7ڿ����p��f�DKQ���EF����ݑ��,i��~��������(F&6����j���,��V(��F�X����C�/�uɌ�e��^��<�o��-�yy^��?
�i�W���v~�F12f�$lo��2\l�&�/�95G���*1����j�t-s?dG�����T,�A�qJ�Z5��Z�%3t�Uǆ�d2����|(��`�I�{���a�,2�e���Y���I"3�9Vo!�:�����7<P���5��%g�(������j��d`�$�G��!3v�uM$�͓p����6�X��f] }���b!�P*C�C���Dt�EWf�.뚈��ୄ"[ ��Vo���jw�u|���������\c6�A�'��'8�O߼�" �!fX,������p|���܁�! D�?	H '8�O� `X^��>�.�W/���2&i����������53\<�LN�Ƈ7�P�~����T�9�-�� +���M�I�?�02�6��� ���L4'a�a|092N�I��� }'A}V����Ș���&�ո�=	���Ē�&M¼��|%C}6��<��'��$h���p>�̟D讐̇���iM���&�=��G�s)�V�����Su��̇���=��y�<�
��hQ�,*
E����� ��`��>R12��wT.(J��ʂ�@�$M��y�:2?�r�+Q��Ff��ߖ����	��;�\m�K��� /�Ų72{S}��y�`t�<oi�Ax�|h��ƓgZZ�ĊKQ���3�5U{��jiI/MP�J�����&![D��>O����WLs'���tH��wJ��92���������t�9�"x,H�BY*L�I�
  x���:�U�o(�s��J�q�ĝ�bI&ü
'��x8��k
�J�V&ڻ'A�A<I�ѫ+L8��ME��:}�]�L_����n<���z�82N�I�o�̳TeՁ�?�V�UCTB���蓟�/�d��h�6��ʪf�,"C�M�|�0?l�"Go1�������S��O>�%�W��
v�l۩eT�b12f�$��z��D ��n.�WT|�1��/F�Ҭ�?�嬧rdY) oL�{��]9 7�b�a-��}Ϻ�"62}����~�C�%���V`�$0�cd���%��b��^R�5.Ą;�ɤ��5��X���vn��$ȇiۭ��諾����&3����VS��w� ���~�E͛յ��D�P��v��e2��ոLu'(D"��u���:����RX;	s��y����ٰ|�Oվ�]�if�d��MC���[�ߧ�R��U`�$"MjE���K�&ϐX�K�\
H$���|���%�V����?HD����d{��w�72�c+ӗg�ɖ!���jwe�I��@�$�)e�\�� 3}̦�Eҏ�j\,��[j�0��A³�<+�N2�a�$=Pf�W�݊}��9�~�L_V�i��B�gӖK�m�I@6 �RD&�`�֓��#Q����{K]	�� � ���B�P�&�!��)���_�k����!s��}}��֏�����u�"��b��<L �w ��z[Q��3`���]��������b#cs�$`E9�ϓ2��#w��ί|�g����}��ր���������zpdA���yy^��4��>���#VT�2�NP0�+��"\�0�L�Tn��\�nͨ+��n� ϫ£&�;�WL<����Ȍ�����7թUC7�|#�b���$�I�<���'#�i��j\ö�����<O.C��nb��:��Z1oO�Y;y�͚�y Hd��sF��lO����/3j1^_�}���G�Dӑ ���B�PM������	������|#'i��D5.1~/P@�<� ���$E�����P��9	�)2�n��ۿ��E' ����)��1�_��{}mo�a��͒c�Ί����R��Y0�P�̢�z/t�����m���	ad�	�K���W+_K A��E#�o��_<$䥎�T@���&�̪�9/���vIl���Ǣ+���]�q��_V42��Y*�����Zzf����v��U��c_��t�[����V�� 
�V���wJ2��WU[�`��$����ݟ̪�<}�I:�S�Oҩ�5.��!�W�7W�y�O-�����x���,��ɛ�v�W��y=�²�\C-{�-�ξme�ym�X��TH~������b�dN�P 1��p��}Ǿ��c=�F}�
׸�o�#�Wtˑ�c��P����+������j��y^�N���w���j����AվoZ�W4
%Y�Ճ��0��2������Α�ړ {��%�����?@�ya�X�
ո�o2}ţ�=���<L�x���r��!2��$��nު�F�){0�����Ȑ����?+�Qh$*���FB�E����-�]4��Ds�$�ºt��.rg����{A�y�@� 2k\���+}�Sj�8'=Q]��U}���L��I�� ��.��!e��2�����>ڶ}��-��4M��W����J��ʊ���}֍�Q�L>^y����7�B%�W ���Ȩqꊷc�q��n�@��CW�hcሌ�3	yG!�ݕ��+eS�sj�#{H��D�Ds/�0�Y�u*��F{Ȋ���}�%C}6	�Yv׊�7�����@.�����V���-f��02�B�&�ul]}��k���=��'�dV�%esE��MFv�ղ-K���[�B�,��R�([GV{��g��@VN"�{k�Ҫ��ɤ�-��I�Љ��8+�*j̀02p��Ob����O_n|��%;fZ��.:�+����7C�	�!�K��
�����q|�t�������}�,��ٷ��&���|S��3�Z[��z��2��I�ߖ���Yv��%e{���������>U	bkeuK/���[�$�o���E����,H&�Ow'��y������]C�CfT�\`�]5�#e�YiB���jo�c`�����2��YE�L;�l�d�ݕwR�$�z
�W�KT���]�r�e��t��_{N���#,�v�9���ﭡ(�+�~��YH���cj^�Ln�]|?���jwA��;ŝ������{���7WF��$�+!�Xv7�R4��%D;s�:���:��^Y��\KH���5ɒYv�1�w;��i2�d�kC[luU�H���I�aDf�]>��������=g"}\ole����g92s��j�����e�}d����%CI�>����Y4	�~Ff��ƅ�l L�w���z�C[���,��Cdd�$4�jd��=D�����<j�$y�g�e|��%�dСIDDd�ݝ�l
Es+�Mm�4�P<+�[���� \��֩P��ݍ�M�[C�����|4F%EDtU'����&�u2���L�֠P\���8�-�i� Y��9����:f��һ�P�vq����A� ހ�Gܣ��]Wq�L��x��Yx����B�px���i@�#�;�t�����"2�fB�;"����W�A��vF_�׾[Z"#='Au�����ĥDDDMG9�;���E7���=�ﳸ��8	��ڻ���w4�!E՗�a���-������;	jj��uwWoD���(��r�`w���bi�����g}Y2֌I�h�Yw7�������~����]���j��:z3Գ�����}����.�Ŀ�����5����}�����I���ᮢt}��S�__re"�`a������W��<	ڶ�2����~�bձf��Wp����U�%�ݕ9��*ː��M�sjs��»��_��wX,HS��P�O~�f���6�H��lo��{W��[�$������»�0�N�Ba100�����g������֘��;q������)��Hۛ:��Јi=	9&�ڻ�X,�V9��RC2�I����ʻ�(�w*���%C���Y��n9�����|%2���\�d�����Y2L ?N�5�%��
,����O>���o�����C87���q�#��� 	�$�N��#���W�b�~6Ed"&��#�G�K��n�d>�,��$`E�p~p�6	��9���%C�?	jj���%{��$�$��2�v�_}��d���I0]��&{@r'��jwe>��)�W�?˟�}�BA ����5�_Q ��Ң�R<+��z�؛�'+����%s=nd����,�;&A.�sE�)p��?BY%���{�d*���w�V2���w,�ߑY#JF�,~� �U���Գh�C��i���D��n�
�У���G��W��#k��Ŗ-Ʌ�N(j�$�+�9���g�����g��[#s���}�Ip�(,���m��֤��rv+��B2�I������O���8j�?�
�(\�r�;)$*��=�o<�S#���B�P�&�y#�Hu���o��V8���M+39�d��G4��k���94���Cth4�hd�޼]|�����!��L-�� ���O�]6K�j�ɐɛi��U�?�\د����S�2}�S����m����N<oi��w��wd��v~���o0L��1�h�R�N���+A,�����w�,���-�}�m�nKfFF�^����_l9�8�^��ixp�g����_m3L��1��LWш�^8��'�׈7}&A�%2O��1�Ѱ����lߗ���׿�n�2�Ȑ���?E�2���2Q�j\���d���n9
���5� 20mfz7=�"2d�﷛��V˾��i��"�"f��7�G� �co 4k�  <T$q�
�]I�qA����H8<b�C* `}�q�� �'
d���M��L��#2��KI�0�t�CDKdo� ��$�.��S;�l;�7QJ�r2�L_�vp�p,��i&�ҢE�R2��Q[���}��9��P�E}4js�/H޽D���,����ݟ�E�P�|�GcPR��r�vW�/�-��(��} 2��Yl���dQY�Q��#���s�bIT&5uܦ��Pt�������baa=7p�<4%ָ'hK�/L�a4AV�:	�U�<S,V�n�>@���훇��_v���d�[��L�e ��A�PMB�{�r)%��N�\5D%Ը�����m�!���._!��?&A>�.�/�Y��yU�������sj��oe^7��,I�L��r4�6���>˃Ȑ'�F �<X[kk��}#9�U�P�Bge�j�%��H�eۭg�Y�ĒC�8	7}�j��6]o-
��N@j��}���roIR�(�0�Sc%y۵����>+�E L��6[�����O �\1/���׼G������ݖ��D�l��V�Ug<j�y��7o�V�6 P��!#����}oo2��� ހ|�Q�{!%��x������L��,xd< s_�[QP�9��!�� W�B�����l#��%��� �\�l���@b#�''A��0u��� H计�,��S����P
� 	F��Wޅ�vF;����^!�5v�Yd���}�����K#���q��Α��{꛿�n����B|����g�ă%c͘�Cd���QRv���t�cF�lo��n�F��R����a$�@��Җ���"X2	��-bX}��;F���7�@�H��X���x���.�4t;`�Q�4���8��2����I��d���������h��FF-�v+�]�o�-JR	j�B	&C:A�%���J��A�$�)
e�]"J����h�V�̄02�B��HT�by�oe��ڰa��>L ���d��X�Q�$��V����F^�7�!�N�]]����}�C�ۯEI*^�2��5210��{WJ�#�4�Ŷ[�.�.����R6o({J�� ���zYQ����Ԭ��x�̅��~�-
FV�Rk�D#�=���m7�	�г�o{؃D� ��02dnt��m{أ���T�z	�@���\\��͋�Ȑ�@��	�Nx���@<ʠYc�pY=���ik��o���F��)�,���}VK�-��ɿ2|�.�k���;�E�09ad��x��.D"qd �a$�)6���;x� ��$�;�Y��=Rv<�r�+����4�D������SV@8�@FVw�x�|� ȿ�0o���,���]���G���!?�S�4����3�a$3�DDtU߾K&C"ry�� ��wɋ�����q�ad�$M7����V;�S�F��0"��_a�&��,�I�t��Y׋�=����A�!��iO)�.BI�:z�E#]�/�E�"��b�i��w�DW�nn��u*�Ff��Z9�=��u�ʊ��g�82N�Y�;%���wɸ��ֱu�X���)���x4�q����N�Fɨ!� �����f�C��:�D�Z8!r������^��>g�Adȧ� ��Cp�;����vT�􃋳A?�;%���[�^��Y: �'a����:R�vbk��ҩ�)�~�;�]սkgߑ�?	� d�'J�[kkA�<��@�x���#����g�d �'av�s�ߕ�ݟ����w��O�C���y���ڝ+h߹�$��
�����������y�\��[��+�;��~42�[g�4�{d��gk}��``�MuX}:8k=B��[񷺪{PD&��,��_�޽���W}��ʹ�����[,9C�x^��YBD��>	t�����g���;�ŅGMX{"8g�"Q;?���E�kG.!��w���B<w��y��]� �+���\m���+s|�UD�P�&A~&2O�-do�l\\�^�OA.D7Q�7ڿї�k/.#K��$�]�yn".}��$���;�Z��V��h�FV;?���,%dB��)���}��)�-ðꐍ��E�bۮmWWu�b���"ҡV+>�qg�I$C��	K��� l��ڿ�9��R����45y�<7�R�� <[O���i�mo�7]�o��dd�˳����̓�o��,I�F��1�e��5 lo��]���,&�A�PM�!�g��ލf{�i�� ٬稸}Ǿ�/�����I�J�y�g�����������Tga�E�e{s|���|
Oa�<��J��4&��
\q�H�퍽�Uݻ���4_�ٝ�xn(���q��ބ���5��5\\r��}��}���ԟ���G஖he�=��i;~r�@���߫�����hdh�͂�&2��=黝�΀Ty�Gw�_T-������Eu�rɸ^��֩�ud��J�#e�3�h�%�� ��
�/��}�����>	��:q��m�-m!i�Hr�{�'��6
�R�{�ga} X=	��Sp_ig��P(��0/�������D��s�e|���U�&��3pg}�7��V41ϳ�r�Ǧ!I2h��Y�%��u��0	�=K������P(��`q�Fl���{�V;#��4�y������%ǅ�*6z���>�Kd��Y�ڹd���o���VW�-"CF�b߹��P-'���#����Ε�a(�W��MJF��ZvK���v�����/+�3���nd�ﳠ����4�Y`dnG������ �("C�)�i�ȼ�?W~��QE.L��&2�	ɠM#�37�32+ʒ�z�?ޕ�۲&!�̚~kG"7A��@&xl$��}Bdȍ��z"Jf=�ٔ�l$�^ɬ(�멑��H�^	Y�g�i��YOF�,)�S�̊22慑���$�!2��,����YO ��DӍFfE)��H�$K�n��$�R{Dk�Ȑ�F�yyf/�YX4b$��ݝW ����-B,)#c�	�|��mM_���`�}���Y>'3�̂�d��FBcAV���HjH���!qO����^P��5n$�!AĪRG����|[K�zdn��z��'�Ց�O�j�!2�����F ��,ZZ��,��L��`9ȴ�խV��YRD�̙�S�ߑYP!�P���E}Ӗ�E D�;�U�~��DD��9��XT��L��j$8�����2P�H�-]��y5
iP0	X���!ã�HP ���
��KH�x�}�w�*���$�`��՗JfE�&�[�{�ɨ|årE��� d���/�$EZ���#��pd�� C�̪�-
F"7�~�)"�OW���������	��̽p��������k
 8uWU-/���b�8,6&�@F}�|C��e�S�sd��A�G�F��^�t�ڙ�v�Y�.�G�.��l黝����LU�ĥ��0﷧�1_����t�|j�o$�s��U7l��io�/&��_̓�n#�k���+�qA��(F��<M~��P�ח��k��U��O� Ld`�H�G
�r;܀ȟ� �����x$j%3+C�+�v|����Mݾ����J�+6�}�������7И��091�z����7u�����i�'��1!�����]YI����ָ\�NJ!�)b��s-vl��M���܀L#Q]����� ��#��ad ݍyu��o?y	��4�;"37�L_�p��!�ְq���l�8+s/��󗳀���K*"i2����Rq?[
�M�\�2���BI���g�ހHcZ����0]�:z��2�d��_9�i� &�X�X2S�V���2/�tca[�Ӹ|����p�ۮ�5G6&20z$8{����A�'�nR�o�����s��\����AI5.Ĥ
%QY�G?��d#��H�5��  �� �H��I��be	!�G�� L:�Ta�X3~����H��缬�������f�m�WA�F"3����{��9�ɬ*"C~�j����K@d�n��k\���-�DePS����5�}Z��/a$�&����q#��,��
���DFށ02��U��<��-F���훇�LZd�´!{��b�5���!7�D���}n�%c�7���Y���(��'���#�Ä����\2�$ָLt�(�d�[�Xn>+#c^��-�̽�
�B-������U��ʴ�͇�� 3�QK0`���{��̡-����V���k�\^�����܋DpnP�=����M����l�����`�VC�y�$ԸL��HV�5~�Ǵ���(����!�܎��,���� �	NĊ9)��������~���Y��ZZ������[
�����D{�,�l"������q}�f�{L��y��׸PN���$��Ψoo~�$�#3�����NF�� s+�Bd��Y� ��\2�ACQ�)�	s��-����ھ�V�<�#�W[M�M!3�;&e�X�b�02�b�ٶVK��>˚�j7|���?Lʤ��6�\&H\��iw�$��f��12'E 6�?��u�oE[r �g����YW�G���b���7V�����Y����g��q[
����x�d �G"�G쎴2�`�����rt�o��A2(s��C6�,W�r�d��I0z�w65��11��H��;�V�Yna � �c(��%3�vW���m9#7�nm��ۿ��sd�����[	˩Dʜ���	��>L�[�7��74ɬ,J�;�5#G-�s|��U�H���KT*V����{�� ��F�[6�V�-ʬx`�Pn���� ̂Iɬ���;����"m�gN ���d�v��n�'3
����E��n ����*r)������{k�����V���YDso42��Yؔ��c��--:�NjK[��_���ȅ�'�b5.��T��T��F�ާRyÛB9��|,�#���������Y���Zs���y(�:AL�V����;�?Q]���}`�su���?�{�/Ω�Ǟ��mK��9���9�A���T����~���d�IC��ʤkb��B��S��4t'��n���j\�E%�x�
�@	�A&-Z]͈-�$¹��3D�Vl-$����BY]����l�W��8a��a�pz�^ ���+߷�������Ժ��5�@+�[�2)�-��l=���4f�TJfi��{J��z�%3�����+� �G4k�n��nuո0~qo!��W/�#QA��F_�7f�[BȄ�{سq�V��9wBQԼY����Ȭ/{���� ,KtM�(}�C<�H&g��2'��l�?����2}�Muj��́��v�F�̔;�����k(���� ��E�ۼݕ9���P����+P�R��Y�BD��:tO�3Nw'�qA~to!�#�e#Q�Aa������� e^62�ck���P��f,0���!��+G�՛��;��"7��=3�~����������ߧ*��!p8ҁBq����gV_əQc�3���[�ߋ���΂�G�渴s�Xj�]���'�gG�n��Uc��)�~&�q	�^D!��g �Hf:���2��F;#�;M��I(���FƼ=2��,�����o�?c_�E�\oڈ��C{���Ώ����|��]���V�%C7A�F{�aDd�d��3�v�C��	�v| X<�k.�6z�a���Ď�])�=X,[��Y0to��ҥg)��H?�a$���-�huU�N��rr)�BM�0~����@��"tW�lY]',j$	��O7��:��z�\�?����q�&����VT!����q�:zeEd��3�h@��s�P�2���5 �b�T�:2K��88	ahx��͜�����(QF�lu��F�R,)E�3*�8zue�}��O4�MGCQ��������8�gA�l��M�X�c�h BBB����޾�]�.�Z_�ָ�ߊ��W�7W��c�s0]��7�KͽW�:�໱�P��"#gK Xb424��"H|Hg�l����[���ȑ�]}��bIVd��s��!2�����s��/N.�i�� �r2QdM!ȅ04��9�_fO���7����c�\�R$�/U��ʓ�_D��������]���y�P�P$�%��K��zY2���>� Ȣ��co$���cە��7 ���
��~+�ܑ]��z����`�;��9>W�@��E>$�:!y;�:f����9��#2d ��ٛ��C����~�y~�k�
ٲE#�V�mY2���i��P�yy^}1.�;�禢��Ɗ�c42�"�*V�Y��ؤ��3&H[�-��d{SrN<��/��m�h"�����584h��Ϳ�O���3\�&�P2����-B�N�Z�v��ֻB@�{coP��e%?�]ij� Q���[]սW��V���ԗ����s/� �5�dVA�g �fF�K��>R��pq��k L27��,�<�P<�k��&�f>�es�����@\�j���GƞR$o,�	1:�F����{A�93�sV/EWt�E�k7^����	���a�gA�E�mTq|�ef5�ؘ�sԢ��/{#e��,���_�Q���nyo��u��b���0L ��^�F&6O�r�lRg��,���S-:W�K�l�	����D��T��C_y��B,$����m����{��0��Y�_ �3K�ʄlc��"G>����b�l�����a&��֩�����\�'eHH���尧ݍ�= ��>%�� ��#s:׉ѷ>@"
�����yRb[���U�{)!����(�H������0�,�Ev|K4�Q����9���7l�l�M]�<X��_�؈��#�=d.���⒃Pg���֨WQ7��#�iV�r|��M"��|m�;:W�ѷnH"A���XOAl�?���+��.ƅB��l��uG,�Y�%+���I�W7B��sM��p�R{Ǉ���D��g��[[��e�?Y�[o�F4r��`T
%���4߾L�HV����̾���/7:�
�wD�J�ѐ&Ȧ��������i!� �#�LJ�vd晝#Df��[j�`P�n�00�An�� �ư�<�bT�P�V�v2�i.�@���`0����)�ns�p�;2���>)ш�^�C~'0:W�w�#����Iw��d ���C_,_��(m?����>7�Ș��o�ݷ2��Yh��D!�M���}�F�� m5E�� �����?dm���vpq�A���͖;ҭR���"�oc� Ȱ�`-D���I�ﶴ����`4�b^��}k���߲ޣ��Tth4��hШ�cw#C�#� ����+[v���K�X�ႎ��H�m1���s,j������?�炼ȁk���	�$�[��U��s�-Kf�U���NH���+�&�w��j��PC�B���C_���ޣ�%gF�7 �!.424M݇d���}-Z�m!��9�x�\1m)-Z��X��V�kX�9������=z�`���
��U��4��s7@�Lc{�����g�Ѫ����Q&G�5w��w����֤! ��$p�їqͽt���xO}�����=qqB6�Nmo֜��t�0:��(��\sO�H�9��u��=�ɪ���9�x�\sE�� k ���4kg�3jr�q�Lȟ�A�Z��#���'��W��s�� }��@L�%�G��D���|�sUUn��_��Ψ܎vFq�2��f��Yq @��`$T��#�<�3� ڶ��7d�g���b)�����������6[�n��QC��i��Ym��q�$�Q��^���.��,}Ӣ�0����Q��Y�՗�ewNܣD�C��z[�v��<=�'���,H&��g��8��ί|�D��lXR6- 4��?��Ʀ!AxVV�����D�@�p���hܓ$¥Y�z �r�gO8�S�"������ ��㟬ڥƪ�؈����Kܣ�$��!���G�F���<9�]���a�ϭI�̢C4��HO�ʶ��g4R� �v���E�P(���Y�+��-q
5�pnuÍ{�q�6�~Ff����M���=�m��r��JW��o��zQ�}�X�!!"�/��/�-9�{�����n��D�~��y�5�d[��֑9�Ϫ�L�0<j����].��cť"�[d"�*'��IX��lw�C�b�Ȋ�̥w	��Qɰ�pT
�d 	�g�m�O�w�;����<��<��*���� ��
	 ������jRKigX�� {�DJƍ�yf��m5�-�� ����OX���V̑A����þ@��Չ�����e�Pr��4���)we���Գ����!�NX�Lb]�k~���wq]A�0�HE����"j�4��q�̚;�O5 �4��q��5o\.����r��{uE}a<s�a�b�?��'��g�u v���F�7�-�1�i�W�����B�rWM����� �EO5�B=x�)[�J�ȥ-m���`q8@�{k��s^I�2t�u"�eً��bd#��!�����KW*Um�0������+d�4Bw�d֞a��!�נ��A,��Ѿ��3���j���pgH2�<���?���}�=�b��M�V��x.�7]9�!� ���[��RH�iv���o�[��Z�9�1�(�#���
X
o,V�3ǡ�7d�4ȧQ>ƾU�7 �X)]���l�� ��`�HO!���sK\\ ��ӰzY2�@�pB䫾���՘�� �C8��Hd�I;?.�:ϟlo��7��w|��hD#�{!���^�ߠ�C8仩�	�綸�M����M9���F�8�����"޾�W�7�b=��{nT��}��W,k�4��(���i��G5�ᄠ�l���������6�w9j�ܙ�mӰzX2���>��.(�1���yK�@��G���Z��i�v�vgܣ��+a[��֑y�
� ��	eu�zY��WU�7W��@-�"K�m�d�^Ӏ=[G9����e6�	kcIr׀x߄�B���-F��pr�GMx��ޔ�(��v�1 �Q��!���� �v�� VC8�y���Wߕ���4h��y �� ����u����+�@�B8���w&%�ia�-]�'��>�..�[ ����K��"k�S@��T�{���>w�Ș�Ӏ��U����T`�sB�!�v�2�9�{�rc� `�4` � d�Z�x! �V��Q��ڧۛhd r�����<����������Ky���On���ݫ��sk��a����y0*0©�(⭞3�P^�$��IQw�+ ��i�=�r|��P ���Ӫoa��Äd�ٰ�c)��}�K�L�<�T�ᆛ���iշ��I�W�꼖c�(�Pu_�5F��*��9Ӆ�yܨ@_gE��5o2��~%�T5�I����x�ܚ�����y�V�7���* ��!�� Q������{���JF?@85֖��r|�#��ߦa��M�[�I�k�d�ng�|m��ް��2��d�bg��T<��۳�����Ӱ�[,OCױ�iW �5O����\S��e3����v~���i�'���t��ss��)O�.�Y��Z�[���[+���~����i������-[���3_ >�d��޳Q(���;���}�m��O����1�p�-6
��vnjgHL�M��N��>O#]��y�� 'Y7uMɼ���Iԃ��Y	����s{ڙf�|�z�%�<t�[l�C�!�ȅ�5.�Q���5�y���NI~����{�� h�<�{k���<���Pت�3g]A|߂x;x��
e�Y�=[��Q�a���)j�4`�~�r|�����W ��P�x��hw�n�W��}�4��b��3�e��JfZ[�H�V�
�]T��;a��^��&' ��`0�:���xz1�bd�������3�SpQ~i�m�G�+S��<'�Q�T�13���{$�:�V���۲��3C>%�]��2�Rj�[	���C6C:@����	�,ș, ��DQ�oU���N�T[yԬqy�2��jw[��3�o�
[�����}��o��]�\2���}D�{�=h�A�Se=�w[2w�^�vebf0�;w>ZK���� w�.�0��yx��ge����tM�y¹�>��k\����YjhO)5�ܣ@��آE����,	���4��F��>�E�A��pn`w�۪�{������#' ����htu|�{�i3�-�AʃI�
|��@�5�J��W�m�2ш%���'Ǽj�T�"
�z���̣q|��ģYN�h�ivύ[>�ש����p2�h}���,���ɱi@��[��q���}�J��?���$�oK�n���EeQ�A8;������s�X7�sk�^�+ȇ�� �ϟ`m�nw�7,�[ѕ�E�(�t���f�DCtu��V `�<�0�(O']GWtE��pv� >9z��Mdn��k�jۭ�o������&� $N�N�U���� HtU��ʰ�道n���z s�?Z��$�W����(
����s�H�y�y֋�3,ۛ���Ze��n`��F J�m��O���F(
@W���K ��y�!�>�t=I�<k�U� @���Ȥ�薓� �Ф(���D��ȑy`�`d���i
�"HRޖ8+s_42��ʢ�B6�	�M�(��6�F��i8���=�lo�73�@���E澦Ч*H���8�):/\geߥ�X,֤y�B�����Y��V! L��uSݖ���jnm�t!�A��+�yy�H����y�:�d�<��Z[k�� �Zu�02����'�VO��es�G/��>����a���Pz�1Uיm�"�0IЬ8ۨn˭��n�R��4�R�f�ðR��z���O!�L��M��>*}o��]����A�%���u[8G���t,)�NX3��%s �-�A1thV/K�Q9�O߼��a�C�&j!릺�D#s_�C�X�����l�h)(�' �o���4 ����<+���7�I4�@�'�����щ�\|�Yi���w."�zEA�{��[�C�b��7��>+}���D�o��)~G劶�S�XR;���X89�N�2 ����r�4ra��(O+��	a^M�&rN�d�!���^��(��|G�fڣ�K�A�u|�[+Nw��w��wd�<�/k���!y�
Y�=�$&�s���P���n=͵7�s;}��˳R�-E͛�ں��=���74��isNZ�"
҉b����Tz"����>#&ە���aTe߯�۲�?@:��#K����0[d���V��'�Tz�l�W��=��FX�X�:�������� �#�6��2����(����zMf��PzR^�CeFnT^��-&=a1̷ɧ����w�u�O*ų2��{�%�q6�=���?(*^&���d �e���ⅅR�ID�x��x����'ɛp�A�y� �}��y��y� �j�ǖ�!�� 'M��ռ�'�)U�W�R���U���Rʶ[������T{�x���ܮz:ɻ�l=��<8����� ����0g V�a--Z�xe1��������(�d�-�M�	¤�]��5%���p�%C�ɑy���=�(]�v�`}g�����oT�(�1����wO��;�����u���A��{�̅����{U�׿g�=�y�p ��}�]����v �z��A���V/�+��D�hg���W��nB�~���0 P��t"���|%�f�W$�5�D�~��n���� �0���ﭱ�+��ߧ���X,��g!�8����*�#� �B \�,�B � ���<o�N�MX
�&�M�@[-]\����s�Ț�����^�����F4��
��0�v��i�O��>q=b4�G%P���h��]`����/ޖ�d����}nY;#��y�����~��O��Z[+u�@6�h���1wrNm�����;�-��z�ή�Էj�W$&���芸�'Kjg�2���*�3������=�B!g�&�L$����i�?����q��~��I�wJ���h�%M7�2L�_��M���Î�����ܸv��y�����a���!\0P@��.XK�Z3��2Ѽ��P� 2���O�q�Sd�z�Cc���$�f��?�/��A�bЬ|�K�����B}6�s,,��>1[+u�8�
\���g�<�t��>�8(4ѣ� ��+�{��RΩM6�wfA{\��<춵��)�%��{�yi��9H5��op��3Q{h/u��mZd��Db�dl�F:�ϓ��Jٜ�B���`ۻ+��k�=du�y--f���[	�d�<�(}�Yq$�;������%��;�}�q�ϝ�� �����=�p��g	�����~�R5eߑ�2���{�쉸y�7��}�g(}�ha����{%Ǭ��C_Ľ?o�]miK�3���d��y���g����ί<�ፂj��Xx��wd��s��������y�}��������w	6�=�)KW�Z��m�r�VK���ȸq|���)��E�j$\y�3r�i��{�=(����aI�.�̜ً�z�5F�
��?����o�/=oi �Y����=�v+����a����`��O�B����mzoȢ�4T</ϫ/�[�c���"��;��n�ܿ=�k����?hh�����/jk���ye�=2��yX �MD-��O��ҷ��)f �}Oఛ>*.""6�����F4r�z�D��G-�{��:��0��b2r�t^�47܈���x^��y�q�g"p�Isd�<�ht��q�:z���b������d~����Q��q2'���A4�@��� :�8���>zm��e��k���>@�L�n9���wTEd��I۸G�򙴻��]��}�r���־�o���C�{@.Xo�SJDWt�;��ȼ��39�{C��hw�s�^�z��Z[l�
��p���94��-f��=��/��"�����z&f�a���<�l��6�ul�薓	�}��4������U����}ޏv~�!w"�[6�V�˳ξ���[GtE������v���L�HG��y7��2 �&�~��������貇=�$����=�?��1� J������,rf&L#��g��n푄 --Է$�n�%�!��D�^aI���`�W!L�3I�̗G�芮���J;��h��S����[lE����s�M!���L���y�G��E;?�� ���QXz�H�-�{!�0[��{zBXXr`^�0ӣ�݊ۮ��>>"o��n����F�����^�G$�0�d�ճ!��!)��L��mW�ѧE�N�m�Z[A1ڶf:\���w0%�i�x��hT�Uy_�%����0W;�t|���v~*ى-2�ް��@>�Ku��\�⡻1��� �Ou��s�|��nth%�l�W��Pp7 W͋<nO)�B��hD�-]�Xr<a&�]~�_��Y,���l�� �eI?����rͲ�"J�=�A�PJ��=(������v���gZ��+�������9��<���F2���#U��k:
%V3�>�P:	�X:��q����,�n�	9pm��z/tI4h$K'����"
���S�{�=2_�ǐ��l��w��@��k�i2��&8���zo�
��ht�Y�o��9��B�	�.���{H���[/h�}k�Jhgn�F�jȿ�B�Ŧ!��ֱu����RG�mr�đ���Q7ܨwY9���{�o�vF;����md����9�~1IkH#\b#6��Q*���a��M3�SnR��|��/�Ŗ-� �~o�	���~A��:k<��U�A%6:��:����b�6�ΟF��}땭��k�� d���@3�l$�'<�k������J������[��;Wʒ3�L�`k�l������H;���j�W� � q��ZL'�k�[�r'���t�r�ö[�D `�3���M��2��T�"��T��[��7[��At���!���@"U+t�)�6��ʱ�~��C��|M^�͓��~��#b۵��3^��r}˪�� L��6[���}�P��k��w����b@@꾽����1��"���߃���l�?�;j*���m��
$!� bC��c��޶�U卯e⁇��+�S�Ͷ*_�ZBߢ�ڷ�-[ B ������n������RϪ��`j$�a����G�C�,���3��"y&6OZ�h��Dnd{]�mYH������^���JwX�; |2׭<,D�O&����/�ַ��.K4@Q
� 
�.DlXh� ؊��[[��`��-Z�GMȟ
9 	"c��>9�P~���ߋ����P.��e�[�a��q��4rV��9hi1W�9�ed��}�7�����U�Yq���Us�޲X:��P(��yt���薋���al�R%Yrt.�Et}&UY� ����>��>�M H�Z�;����UE-�얶--ZH[���o���*>|��֪�4�?x ����W�Z5Y��!dh����E���V!�'}��Q�ѫ� �'kr �:���0���B��GG ""Go196�-I"2���(��r�[�?��y�r�0[�A*��!>�m��"Y��lXO��|�3
���e%�d(���(jgXr�ia�ۏ#�Ψ�4�=t��e�(�[�����gO�a�u  r��4����aH������d®�n�3�aDl]��5&)��)x-���>�S�Z� r�u*������O�<Ѣ
�`�|�L�ȍ҂ ��kXͨP>�k��pC䠥ɛO;sC;���Q���d���5���Qa��s�/�j�&y���}k��(��;�r��|`ھUig|��~GD�	\���yK{^��'� K�������0���[�[KW�'l9
ࣈ�te��0!�@��p\, ��aă��!��ȁU.�(�9$��C�!,]A�=c��!�Oa�FHW$F��ؐˣ&<|m�ї5��<TB���!��)2���ut�� P�l�lU�i�lX*B@%[�92e�<�ױ�V2>�m����aJ�8�*����bt���9���,C��/���G�'�i��`��M-s"G�#(4�2'm���z|H�`kD����3)��C���v�F_�
&�%St>���ꋦ��z��+J��i�����#���f�R� ��՗�V�2k�QS�(��׌����Vp	¬��7Ѩ�����W���M�df4*�?��/ڶpqچ�����=���[�N��@.C�����h|��*}1] gކ_�O  ����yε�+��O;?U�F@_�@�W��v~*>�2]�� L�0E�G�9GA������*m�g�?U���q��/��if&o����c��e�ߦn�%�7+���۲d���L!���^}qNmr`���Z��-Y�<��2]in�s��F��"��C:YVoȝ�a%�G��kJH_$"� �8��V�o�-�/�I~�09����sǍLW��5���[}I�FA>u(5uF�go�We)]}�苊��B�=$��m��jwe}�`d��������*4h|��-5tS����'W�R���h��<��o��d.U���2$(
?B�?���<���+���pL*..��(���\���F!>o��>2}�j��+�,2�FW��6JD�z��K49�[	��&���{d���-�~�p���H�T�O[#�H�(�8��pQODD��v/��~����EB>����ڨ-�I&���4��$}}�.է*�O6B�J`w~��>jg�;U(�I�.�pz�^�}�(Q>i��2}Y���p�@�}k�*�m�]A��VSX�B�z��t�1�ʤ��۲�(�R�K��L�+��L�L.@�Rԗ(B����<+��P��#{!\*�T%)HW���ݕ"`�kv@Q�t�	id""�ڶ���BN�;��;�]}�F42%"����BWd���wT��5���<[~�p�@�jߢE��9w�B#E� \/��tQ��>`۽GIs�Y ႁ�����������t�s�W�z�b��uO{�t�a@
����
K_�����H��,� \4�uE��SuO;?�H�S>�K��L}}�.�u�D�D��
�uC}��#uO;��1R{\��k_�I�Q@W�{�oU: ���L~"y�2�$��>N���v~�ͫ�µCf�D����t�ѫ�3��j�C�x�tG]}�F�L/Jig��48��i&f��ҟ�;*�(�e�@����a|�ڍJ�Rx+��Z��n ��X�>FQyA���X�Y@� �C�+ ��	��誼0�U����=��<�(}}~�V���;%�'�r!�F� x� ����FyA7u�`Xn$�K�P P���Y��I�t����%p��L�F_�?Ө�W�D�\�q2.A���>�A���y�v*4�+�D[(ڻ�I���Z�yKS(}}^��-�o��i�����B~��</ϫ���c[T�Q�l\�m�d@6���5��ϫ���c�]�|��h�4��p� ��p_�|�S��G����Q	!���v�h�)���I{_ȅH��x^����[��Vz[-Yϑ�p���l�������k��=�Ӓ�҂<#_����������{�g����z�����赻i�nsx}��C�	$����O_������`X�������S5ԙ%3����7�\����>?W������ �_��(���<��z�[w����i������*.�0�	����ߧj��y���$�[�������j�'�^�E� ���+�J��������9n;P�Ƙ���ѫ��}]\;?�aA@��jۍ�v+b�X�`�|�������#������r����"� �S�7��_<�iLuu�����Bd˾sM4��R�?O<��ވ{�DC���s�;l����.x� ��h;\��Nb͐�}Ǿ#���3���u�[�
� @���~�B�}�����y���j��\�����˾�+��%;?���Z�%6� A  !��{����������vyؼ��D������+�Y`��[��x�?�����xh�g����;��Í�8�--�],�"B(��0
@X  ( �������{k��.���G?P�`'������ n۵���wd�&���G��B�P("�"�P A A A �0� C���ǁ�! �@ ��c   �速𼩞���T�{�n����z����'���Z;��Bx�!��=�]\�]]Y�*�� �����[��Sa�^i����b�&��@}F~Ra=�"' »�I�{�=^��ad�\8DGo��[��_��Q�M�v�m�Ht��#6O�f0c��i���~#�`�l�]�99�#p2�����ve���:*/�� �xH�H����9�q~�d<ʴ�+�u*lo���k��:���S�M�H�8ۨ��--��V��lo�tu��:ݥg���� 3P�F���L#�Z3�;�����bXA�C�`����$��l5/eb����a���L���t����z�i��>�>C����3ݚ�������k���#ߓ�d&�~$?���/�4��&s�W��K���5��7��S-$�`1,�%��Z�a��VQ�`5����:������lD�d�l�-�o���m�_�/�;`'�v�.�{��p���p��A��\�\(����KԳ*��xȊ{d��xR<��<��n�.���V�P�+�_������i����^��[kk��_CG)F�:`J.�~z����ik�x�sGy��o�&�B����h:��GW��?��/�`^���o0��{dm�̟C�/���
��v��� �F_��>��z�\~~#�Ec �����c���&@WV�5�ޫ�� _�]�ObM� �R�j����h:*<����X"��"����� H�F4x�jwe�"z��
Ra��;�/_ģ��K4�B�&ַo]�x2��5�m����xpq���7�![GW2���7�BԖ��CV��BU����&�tÍ�tU_�(PBBr�u*�3O�#��s5��Q�M���B��O���}{-����o H����"
����S�bӐط���od��9���}�8P �?6�*�Z���ط��kx�{Y,9��}j#���B_b#e�����BɁgv�<$��� R��>���+V�G6Bۥ'$РR����y�i��Z����h�E1!hT������~o��5"�4��hDCT�d���'{��
5�i-�A�ڙf��F4�hd���G{d l{Vs�l�C���*�9���}�R�S�I� �l�W��[팪~���	�n�	�3/���v���V�F��>)�:,k�SbD{7�G���v�������d�02f�#������F����^)s|����w� ��\xe��^���D�d������#i���'�moC i�W����>4�N��3y��v+�l����&le�^�d��Sr#DĶk�e˖�T9�ϟMڒi��s�oGY=H:Ai�U 8��_N�����O�X^e���8+g=p>��'X��vU���ד}+�o�}�X3BwA�����>�+�rO�h:B�%$�U��>_�+��� &۩/�hD#�|�>�� ��)�#_E{7JV�����>���A�� �?L����hE+E�T����d���?�V�W|\� 6R�J����).W��g�;y���Ł��Fz�珊+r��w0m ���;��Cy�7�g X�����M���2��J��>Xq�d�g�\$s� 7u!R���loF�r|�����&�[���ra9ogn�D�pÍ���T������2{��<�K޵�2 hg�3����}2c444�.��5O�mKҁ�a��3z������7X����5��M]�(�h�p��>��5шF4�-����ۿ��0(n�Qh�*���{�F42�D�bEA��L�����$��o�������|�q=�[L��|c^ 7B&a�vW�����^��>x��yw_=�n�k��(� :���7���IU[����$7}�j
� qqq����}�S��k��~o��r G�X3�K�v�-�ō�����r|����^��m�,l���P�n�S�Eq�����;q|�?ƈB����z���<k�Gnn�� ���98G/�^t9�ϟd�vq������ �}N��tsSҀb!���z������]�o!1��6�,�?��I?W���ɀ�4�p�E{�N��>��Z ��,��9J�#?�D׋L��4��� �7��7�U9��i�V7�B�: '`��z��lw[mo�!IP���x�7�W9���j�v�ΩM�}� ���j��Z&�W�ޡ��j��_%H! b1(������Ul|��o�7��9� �����nA6�k�l�#4�z�m�9��)q@QaXBڲݟ��|c{�/������o�A���FԺ7�zN��d�Zh����U7}����4��*C  AA(�簇=��ݟ���8/g�YT�z��L��8���-��̶f�d4Ƽy����]�ۜ��r� ���hglo�7߳�OT����Α��,
EE1�`)�6rN��m��f�%_Q��]��/<`sG[-9�v�7WC� " a�Aå�E�	s����P��>ء�M�l���[{8��Er������y��5|lMBo�a�%���d�떖�S�^������/i# ` �B� `�-����� �]?V9��y�Tc۵�2�[��>��pz���K.�E8����� �ݰm�d��XI-�%j��O~'s�O�[3>���Dy���`��,�福�����]�v�mۙ�j�=��^�7շ���ί<�S
C:$��
b B(���K�o������H�7~�?�'Jw��J����  �V"ҀuS̝�����N�� <��OӍ�JuE�1]��7�{B�c:�t���h:�3����;T{W;s��m�[]����ʹm1mX7����v�U�۪�����--����L�����4�$�igŦa���������禮U����S��ul��j��[c�^�7��G��>U��T�w���*�[���*m��N��S���������-kO����"��� Ȉ�+!@  
P� P�� C�nX@4B\h�3��=����i���� �W��o�~��' 1bt<�ox�84(�A�BAшFH����Eذ���4\�A���]팶�������b#�{x�r���`�-
������?����Ǿckmo�����:���o����۾�i�����?�vm�^�fV��7���}>+�<��R9�ϧ)��ͤ������������������������������������0��     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://4ok12qtgl7xq"
path="res://.godot/imported/icon.svg-5b01e8115f19d6d63dc265815ce29c75.ctex"
metadata={
"vram_texture": false
}
 extends ScrollDamper
class_name LinearScrollDamper


## Friction, not physical. 
## The higher the value, the more obvious the deceleration. 
@export_range(0.001, 10000.0, 0.001, "or_greater", "hide_slider")
var friction := 4.0:
	set(val):
		friction = max(val, 0.001)
		_factor = pow(10.0, friction) - 1.0

## Factor to use in formula
var _factor := 10000.0:
	set(val): _factor = max(val, 0.000000000001)


func _calculate_velocity_by_time(time: float) -> float:
	if time <= 0.0: return 0.0
	return time * _factor


func _calculate_time_by_velocity(velocity: float) -> float:
	return abs(velocity) / _factor


func _calculate_offset_by_time(time: float) -> float:
	time = max(time, 0.0)
	return 1.0/2.0 * _factor * time*time


func _calculate_time_by_offset(offset: float) -> float:
	return sqrt(abs(offset) * 2.0 / _factor)
      extends ScrollDamper
class_name QuadScrollDamper


## Friction, not physical. 
## The higher the value, the more obvious the deceleration. 
@export_range(0.001, 10000.0, 0.001, "or_greater", "hide_slider")
var friction := 4.0:
	set(val):
		friction = max(val, 0.001)
		_factor = pow(10.0, friction) - 1.0

## Factor to use in formula
var _factor := 10000.0:
	set(val): _factor = max(val, 0.000000000001)


func _calculate_velocity_by_time(time: float) -> float:
	if time <= 0.0: return 0.0
	return time*time * _factor


func _calculate_time_by_velocity(velocity: float) -> float:
	return sqrt(abs(velocity) / _factor)


func _calculate_offset_by_time(time: float) -> float:
	time = max(time, 0.0)
	return 1.0/3.0 * _factor * time*time*time


func _calculate_time_by_offset(offset: float) -> float:
	return pow(abs(offset) * 3.0 / _factor, 1.0/3.0)
@icon("icon.svg")
extends Resource
class_name ScrollDamper

## Abstract class

## Rebound strength. The higher the value, the faster it attracts. 
@export_range(0.0, 1.0, 0.001, "or_greater", "hide_slider")
var rebound_strength := 7.0:
	set(val):
		rebound_strength= max(val, 0.0)
		_attract_factor = rebound_strength * rebound_strength * rebound_strength

## Factor for attracting.
var _attract_factor := 400.0:
	set(val):
		_attract_factor = max(val, 0.0)


# Abstract method
func _calculate_velocity_by_time(time: float) -> float:
	return 0.0

# Abstract method
func _calculate_time_by_velocity(velocity: float) -> float:
	return 0.0

# Abstract method
func _calculate_offset_by_time(time: float) -> float:
	return 0.0

# Abstract method
func _calculate_time_by_offset(offset: float) -> float:
	return 0.0


func _calculate_velocity_to_dest(from: float, to: float) -> float:
	var dist = to - from
	var time = _calculate_time_by_offset(abs(dist))
	var vel = _calculate_velocity_by_time(time) * sign(dist)
	return vel


func _calculate_next_velocity(present_time: float, delta_time: float) -> float:
	return _calculate_velocity_by_time(present_time - delta_time)


func _calculate_next_offset(present_time: float, delta_time: float) -> float:
	return _calculate_offset_by_time(present_time) \
		 - _calculate_offset_by_time(present_time - delta_time)


## Return the result of next velocity and position according to delta time
func slide(velocity: float, delta_time: float) -> Array:
	var present_time = _calculate_time_by_velocity(velocity)
	return [
		_calculate_next_velocity(present_time, delta_time) * sign(velocity),
		_calculate_next_offset(present_time, delta_time) * sign(velocity)
	]


## Emulate force that attracts something to destination.
## Return the result of next velocity according to delta time
func attract(from: float, to: float, velocity: float, delta_time: float) -> float:
	var dist = to - from
	var target_vel = _calculate_velocity_to_dest(from, to)
	velocity += _attract_factor * dist * delta_time \
		 + _calculate_velocity_by_time(delta_time) * sign(dist)
	if (
		(dist > 0 and velocity >= target_vel) \
		or (dist < 0 and velocity <= target_vel) \
	):
		velocity = target_vel
	return velocity
               GST2            ����                        �  RIFF�  WEBPVP8L�  / �Ġm#I�-������$9����p}u�6�$9#d�矂ٶ�j�{6�� ��X ��|=������~�8� b�鴊]��n�LQV�O���u�?�e���`a�)ʊ*���?�� lT�l)�d l��~�"�*���0		E�#�p �@ G P�@	A��0�/-�?����E��:[�P�o��ˠȰ`��?�h
3��_��\�� $̝C��@�o}��Z��@���i۸������R�x�13���������R{|	�G۶m�x��3�@@�v���X,Qt:���k��ڌ16k>�`��,z�O��s���s��/t�?�>�q� �fw�,���=�Qu�����y[4����,���TWׯ��y�����?w�����v�$�p8��!����Z)�i<%�<?�[�{x�m��}>5�Q/��QґB���)�o�-%�H��^,?H��"ᩉ8*�+�7���lj{�����H�����:�F��)%��7|s�{&�FK��F��w�򲭃���L�|���!�g?���w �~ݮBѧu�4�����Ϊ�:Ci�����U���j��Ew	�� �u����G���8���w5������إ�
�`�IB2���q            [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dorhyoghxkay6"
path="res://.godot/imported/class-icon.svg-c17de51589a7d30572bf401526524f64.ctex"
metadata={
"vram_texture": false
}
          RSRC                    SystemFont            ��������                                                  resource_local_to_scene    resource_name 
   fallbacks    font_names    font_italic    font_weight    font_stretch    antialiasing    generate_mipmaps    allow_system_fallback    force_autohinter    hinting    subpixel_positioning #   multichannel_signed_distance_field    msdf_pixel_range 
   msdf_size    oversampling    script           local://SystemFont_iqskl �         SystemFont          RSRC             @tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("ScrollDamper", "Resource", preload("scroll_damper/scroll_damper.gd"), preload("scroll_damper/icon.svg"))
	add_custom_type("SmoothScrollContainer", "ScrollContainer", preload("SmoothScrollContainer.gd"), preload("class-icon.svg"))


func _exit_tree():
	remove_custom_type("ScrollDamper")
	remove_custom_type("SmoothScrollContainer")
 ## Smooth scroll functionality for ScrollContainer
##
## Applies velocity based momentum and "overdrag"
## functionality to a ScrollContainer
@tool
extends ScrollContainer
class_name SmoothScrollContainer

@export_group("Mouse Wheel")
## Drag impact for one scroll input
@export_range(0, 10, 0.01, "or_greater", "hide_slider")
var speed := 1000.0
## ScrollDamper for wheel scrolling
@export
var wheel_scroll_damper: ScrollDamper = ExpoScrollDamper.new()

@export_group("Dragging")
## ScrollDamper for dragging
@export
var dragging_scroll_damper: ScrollDamper = ExpoScrollDamper.new()
### Allow dragging with mouse or not
@export
var drag_with_mouse = true
## Allow dragging with touch or not
@export
var drag_with_touch = true

@export_group("Container")
## Below this value, snap content to boundary
@export
var just_snap_under := 0.4
## Margin of the currently focused element
@export_range(0, 50)
var follow_focus_margin := 20
## Makes the container scrollable vertically
@export
var allow_vertical_scroll := true
## Makes the container scrollable horizontally
@export
var allow_horizontal_scroll := true
## Makes the container only scrollable where the content has overflow
@export
var auto_allow_scroll := true
## Whether the content of this container should be allowed to overshoot at the ends
## before interpolating back to its bounds
@export
var allow_overdragging := true

@export_group("Scroll Bar")
## Hides scrollbar as long as not hovered or interacted with
@export
var hide_scrollbar_over_time := false:
	set(val): hide_scrollbar_over_time = _set_hide_scrollbar_over_time(val)
## Time after scrollbar starts to fade out when 'hide_scrollbar_over_time' is true
@export
var scrollbar_hide_time := 5.0
## Fadein time for scrollbar when 'hide_scrollbar_over_time' is true
@export
var scrollbar_fade_in_time := 0.2
## Fadeout time for scrollbar when 'hide_scrollbar_over_time' is true
@export
var scrollbar_fade_out_time := 0.5

@export_group("Debug")
## Adds debug information
@export
var debug_mode := false

## Current velocity of the `content_node`
var velocity := Vector2(0,0)
## Control node to move when scrolling
var content_node: Control
## Current position of `content_node`
var pos := Vector2(0, 0)
## Current ScrollDamper to use, recording to last input type
var scroll_damper: ScrollDamper
## When true, `content_node`'s position is only set by dragging the h scroll bar
var h_scrollbar_dragging := false
## When true, `content_node`'s position is only set by dragging the v scroll bar
var v_scrollbar_dragging := false
## When ture, `content_node` follows drag position
var content_dragging := false
## Timer for hiding scroll bar
var scrollbar_hide_timer := Timer.new()
## Tween for hiding scroll bar
var scrollbar_hide_tween: Tween
## Tween for scroll x to
var scroll_x_to_tween: Tween
## Tween for scroll y to
var scroll_y_to_tween: Tween
## [0,1] Mouse or touch's relative movement accumulation when overdrag[br]
## [2,3] Position where dragging starts[br]
## [4,5,6,7] Left_distance, right_distance, top_distance, bottom_distance
var drag_temp_data := []
## Whether touch point is in deadzone.
var is_in_deadzone := false

## If content is being scrolled
var is_scrolling := false:
	set(val):
		if is_scrolling != val:
			if val:
				emit_signal("scroll_started")
			else:
				emit_signal("scroll_ended")
		is_scrolling = val

## Last type of input used to scroll
enum SCROLL_TYPE {WHEEL, BAR, DRAG}
var last_scroll_type: SCROLL_TYPE

####################
##### Virtual functions

func _ready() -> void:
	if debug_mode:
		setup_debug_drawing()
	# Initialize variables
	scroll_damper = wheel_scroll_damper
	
	get_v_scroll_bar().gui_input.connect(_scrollbar_input.bind(true))
	get_h_scroll_bar().gui_input.connect(_scrollbar_input.bind(false))
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

	for c in get_children():
		if not c is ScrollBar:
			content_node = c
	
	add_child(scrollbar_hide_timer)
	scrollbar_hide_timer.timeout.connect(_scrollbar_hide_timer_timeout)
	if hide_scrollbar_over_time:
		scrollbar_hide_timer.start(scrollbar_hide_time)
	get_tree().node_added.connect(_on_node_added)

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	scroll(true, velocity.y, pos.y, delta)
	scroll(false, velocity.x, pos.x, delta)
	# Update vertical scroll bar
	get_v_scroll_bar().set_value_no_signal(-pos.y)
	get_v_scroll_bar().queue_redraw()
	# Update horizontal scroll bar
	get_h_scroll_bar().set_value_no_signal(-pos.x)
	get_h_scroll_bar().queue_redraw()
	# Update state
	update_state()

	if debug_mode:
		queue_redraw()

# Forwarding scroll inputs from scrollbar
func _scrollbar_input(event: InputEvent, vertical : bool) -> void:
	if hide_scrollbar_over_time:
		show_scrollbars()
		scrollbar_hide_timer.start(scrollbar_hide_time)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN\
		or event.button_index == MOUSE_BUTTON_WHEEL_UP\
		or event.button_index == MOUSE_BUTTON_WHEEL_LEFT\
		or event.button_index == MOUSE_BUTTON_WHEEL_RIGHT:
			_gui_input(event)
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if vertical:
					v_scrollbar_dragging = true
					last_scroll_type = SCROLL_TYPE.BAR
					kill_scroll_to_tweens()
				else:
					h_scrollbar_dragging = true
					last_scroll_type = SCROLL_TYPE.BAR
					kill_scroll_to_tweens()
			else:
				if vertical:
					v_scrollbar_dragging = false
				else:
					h_scrollbar_dragging = false
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if vertical:
				v_scrollbar_dragging = true
				last_scroll_type = SCROLL_TYPE.BAR
				kill_scroll_to_tweens()
			else:
				h_scrollbar_dragging = true
				last_scroll_type = SCROLL_TYPE.BAR
				kill_scroll_to_tweens()
		else:
			if vertical:
				v_scrollbar_dragging = false
			else:
				h_scrollbar_dragging = false

func _gui_input(event: InputEvent) -> void:
	if hide_scrollbar_over_time:
		show_scrollbars()
		scrollbar_hide_timer.start(scrollbar_hide_time)
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					last_scroll_type = SCROLL_TYPE.WHEEL
					if event.shift_pressed or not should_scroll_vertical():
						if should_scroll_horizontal():
							velocity.x -= speed * event.factor
					else:
						if should_scroll_vertical():
							velocity.y -= speed  * event.factor
					scroll_damper = wheel_scroll_damper
					kill_scroll_to_tweens()
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					last_scroll_type = SCROLL_TYPE.WHEEL
					if event.shift_pressed or not should_scroll_vertical():
						if should_scroll_horizontal():
							velocity.x += speed * event.factor
					else:
						if should_scroll_vertical():
							velocity.y += speed * event.factor
					scroll_damper = wheel_scroll_damper
					kill_scroll_to_tweens()
			MOUSE_BUTTON_WHEEL_LEFT:
				if event.pressed:
					last_scroll_type = SCROLL_TYPE.WHEEL
					if event.shift_pressed:
						if should_scroll_vertical():
							velocity.y -= speed * event.factor
					else:
						if should_scroll_horizontal():
							velocity.x += speed * event.factor
					scroll_damper = wheel_scroll_damper
					kill_scroll_to_tweens()
			MOUSE_BUTTON_WHEEL_RIGHT:
				if event.pressed:
					last_scroll_type = SCROLL_TYPE.WHEEL
					if event.shift_pressed:
						if should_scroll_vertical():
							velocity.y += speed * event.factor
					else:
						if should_scroll_horizontal():
							velocity.x -= speed * event.factor
					scroll_damper = wheel_scroll_damper
					kill_scroll_to_tweens()
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					if !drag_with_mouse: return
					content_dragging = true
					is_in_deadzone = true
					scroll_damper = dragging_scroll_damper
					last_scroll_type = SCROLL_TYPE.DRAG
					init_drag_temp_data()
					kill_scroll_to_tweens()
				else:
					content_dragging = false
					is_in_deadzone = false
	
	if (event is InputEventScreenDrag and drag_with_touch) \
			or (event is InputEventMouseMotion and drag_with_mouse):
		if content_dragging:
			if should_scroll_horizontal():
				drag_temp_data[0] += event.relative.x
			if should_scroll_vertical():
				drag_temp_data[1] += event.relative.y
			remove_all_children_focus(self)
			handle_content_dragging()
	
	if event is InputEventPanGesture:
		if should_scroll_horizontal():
			velocity.x = -event.delta.x * speed
			kill_scroll_to_tweens()
		if should_scroll_vertical():
			velocity.y = -event.delta.y * speed
			kill_scroll_to_tweens()
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if !drag_with_touch: return
			content_dragging = true
			is_in_deadzone = true
			scroll_damper = dragging_scroll_damper
			last_scroll_type = SCROLL_TYPE.DRAG
			init_drag_temp_data()
			kill_scroll_to_tweens()
		else:
			content_dragging = false
			is_in_deadzone = false
	# Handle input
	get_tree().get_root().set_input_as_handled()

# Scroll to new focused element
func _on_focus_changed(control: Control) -> void:
	if follow_focus:
		self.ensure_control_visible(control)

func _draw() -> void:
	if debug_mode:
		draw_debug()

# Sets default mouse filter for SmoothScroll children to MOUSE_FILTER_PASS
func _on_node_added(node: Node) -> void:
	if node is Control and Engine.is_editor_hint():
		if is_ancestor_of(node):
			node.mouse_filter = Control.MOUSE_FILTER_PASS

func _scrollbar_hide_timer_timeout() -> void:
	if !any_scroll_bar_dragged():
		hide_scrollbars()

func _set_hide_scrollbar_over_time(value: bool) -> bool:
	if value == false:
		if scrollbar_hide_timer != null:
			scrollbar_hide_timer.stop()
		if scrollbar_hide_tween != null:
			scrollbar_hide_tween.kill()
		get_h_scroll_bar().modulate = Color.WHITE
		get_v_scroll_bar().modulate = Color.WHITE
	else:
		if scrollbar_hide_timer != null and scrollbar_hide_timer.is_inside_tree():
			scrollbar_hide_timer.start(scrollbar_hide_time)
	return value

func _get(property) -> Variant:
	match property:
		"scroll_horizontal":
			if !content_node: return 0
			return -int(content_node.position.x)
		"scroll_vertical":
			if !content_node: return 0
			return -int(content_node.position.y)
		_:
			return null

func _set(property, value) -> bool:
	match property:
		"scroll_horizontal":
			if !content_node:
				scroll_horizontal = 0
				return true
			scroll_horizontal = value
			kill_scroll_x_to_tween()
			velocity.x = 0.0
			pos.x = clampf(
				-value as float,
				-get_child_size_x_diff(content_node, true),
				0.0
			)
			return true
		"scroll_vertical":
			if !content_node:
				scroll_vertical = 0
				return true
			scroll_vertical = value
			kill_scroll_y_to_tween()
			velocity.y = 0.0
			pos.y = clampf(
				-value as float,
				-get_child_size_y_diff(content_node, true),
				0.0
			)
			return true
		_:
			return false

##### Virtual functions
####################


####################
##### LOGIC

func scroll(vertical: bool, axis_velocity: float, axis_pos: float, delta: float):
	# If no scroll needed, don't apply forces
	if vertical:
		if not should_scroll_vertical():
			return
	else:
		if not should_scroll_horizontal():
			return
	if !scroll_damper: return
	# Applies counterforces when overdragging
	if not content_dragging:
		axis_velocity = handle_overdrag(vertical, axis_velocity, axis_pos, delta)
		# Move content node by applying velocity
		var slide_result = scroll_damper.slide(axis_velocity, delta)
		axis_velocity = slide_result[0]
		axis_pos += slide_result[1]
		# Snap to boundary if close enough
		var snap_result = snap(vertical, axis_velocity, axis_pos)
		axis_velocity = snap_result[0]
		axis_pos = snap_result[1]
	else:
		axis_velocity = 0.0
	# If using scroll bar dragging, set the content_node's
	# position by using the scrollbar position
	if handle_scrollbar_drag():
		return
	
	if vertical:
		if not allow_overdragging:
			# Clamp if calculated position is beyond boundary
			if is_outside_top_boundary(axis_pos):
				axis_pos = 0.0
				axis_velocity = 0.0
			elif is_outside_bottom_boundary(axis_pos):
				axis_pos = -get_child_size_y_diff(content_node, true)
				axis_velocity = 0.0
	
		content_node.position.y = axis_pos 
		pos.y = axis_pos
		velocity.y = axis_velocity
	else:
		if not allow_overdragging:
			# Clamp if calculated position is beyond boundary
			if is_outside_left_boundary(axis_pos):
				axis_pos = 0.0
				axis_velocity = 0.0
			elif is_outside_right_boundary(axis_pos):
				axis_pos = -get_child_size_x_diff(content_node, true)
				axis_velocity = 0.0
		
		content_node.position.x = axis_pos
		pos.x = axis_pos
		velocity.x = axis_velocity

func handle_overdrag(vertical: bool, axis_velocity: float, axis_pos: float, delta: float) -> float:
	if !scroll_damper: return 0.0
	# Calculate the size difference between this container and content_node
	var size_diff = get_child_size_y_diff(content_node, true) \
		if vertical else get_child_size_x_diff(content_node, true)
	# Calculate distance to left and right or top and bottom
	var dist1 = get_child_top_dist(axis_pos, size_diff) \
		if vertical else get_child_left_dist(axis_pos, size_diff)
	var dist2 = get_child_bottom_dist(axis_pos, size_diff) \
		if vertical else get_child_right_dist(axis_pos, size_diff)
	# Calculate velocity to left and right or top and bottom
	var target_vel1 = scroll_damper._calculate_velocity_to_dest(dist1, 0.0)
	var target_vel2 = scroll_damper._calculate_velocity_to_dest(dist2, 0.0)
	# Bounce when out of boundary. When velocity is not fast enough to go back, 
	# apply a opposite force and get a new velocity. If the new velocity is too fast, 
	# apply a velocity that makes it scroll back exactly.
	if axis_pos > 0.0:
		if axis_velocity > target_vel1:
			axis_velocity = scroll_damper.attract(
				dist1,
				0.0,
				axis_velocity,
				delta
			)
	if axis_pos < -size_diff:
		if axis_velocity < target_vel2:
			axis_velocity = scroll_damper.attract(
				dist2,
				0.0,
				axis_velocity,
				delta
			)
	
	return axis_velocity

# Snap to boundary if close enough in next frame
func snap(vertical: bool, axis_velocity: float, axis_pos: float) -> Array:
	# Calculate the size difference between this container and content_node
	var size_diff = get_child_size_y_diff(content_node, true) \
		if vertical else get_child_size_x_diff(content_node, true)
	# Calculate distance to left and right or top and bottom
	var dist1 = get_child_top_dist(axis_pos, size_diff) \
		if vertical else get_child_left_dist(axis_pos, size_diff)
	var dist2 = get_child_bottom_dist(axis_pos, size_diff) \
		if vertical else get_child_right_dist(axis_pos, size_diff)
	if (
		dist1 > 0.0 \
		and abs(dist1) < just_snap_under \
		and abs(axis_velocity) < just_snap_under \
	):
		axis_pos -= dist1
		axis_velocity = 0.0
	elif (
		dist2 < 0.0 \
		and abs(dist2) < just_snap_under \
		and abs(axis_velocity) < just_snap_under \
	):
		axis_pos -= dist2
		axis_velocity = 0.0
	
	return [axis_velocity, axis_pos]

## Returns true when scrollbar was dragged
func handle_scrollbar_drag() -> bool:
	if h_scrollbar_dragging:
		velocity.x = 0.0
		pos.x = -get_h_scroll_bar().value
		return true
	
	if v_scrollbar_dragging:
		velocity.y = 0.0
		pos.y = -get_v_scroll_bar().value
		return true
	return false

func handle_content_dragging() -> void:
	if !dragging_scroll_damper: return
	
	if(
		Vector2(drag_temp_data[0], drag_temp_data[1]).length() < scroll_deadzone \
		and is_in_deadzone
	):
		return
	elif is_in_deadzone == true:
		is_in_deadzone = false
		drag_temp_data[0] = 0.0
		drag_temp_data[1] = 0.0
	
	var calculate_dest = func(delta: float, damping: float) -> float:
		if delta >= 0.0:
			return delta / (1 + delta * damping * 0.00001)
		else:
			return delta
	
	var calculate_position = func(
		temp_dist1: float,		# Temp distance
		temp_dist2: float,
		temp_relative: float	# Event's relative movement accumulation
	) -> float:
		if temp_relative + temp_dist1 > 0.0:
			var delta = min(temp_relative, temp_relative + temp_dist1)
			var dest = calculate_dest.call(delta, dragging_scroll_damper._attract_factor)
			return dest - min(0.0, temp_dist1)
		elif temp_relative + temp_dist2 < 0.0:
			var delta = max(temp_relative, temp_relative + temp_dist2)
			var dest = -calculate_dest.call(-delta, dragging_scroll_damper._attract_factor)
			return dest - max(0.0, temp_dist2)
		else: return temp_relative
	
	if should_scroll_vertical():
		var y_pos = calculate_position.call(
			drag_temp_data[6],	# Temp top_distance
			drag_temp_data[7],	# Temp bottom_distance
			drag_temp_data[1]	# Temp y relative accumulation
		) + drag_temp_data[3]
		velocity.y = (y_pos - pos.y) / get_process_delta_time()
		pos.y = y_pos
	if should_scroll_horizontal():
		var x_pos = calculate_position.call(
			drag_temp_data[4],	# Temp left_distance
			drag_temp_data[5],	# Temp right_distance
			drag_temp_data[0]	# Temp x relative accumulation
		) + drag_temp_data[2]
		velocity.x = (x_pos - pos.x) / get_process_delta_time()
		pos.x = x_pos

func remove_all_children_focus(node: Node) -> void:
	if node is Control:
		var control = node as Control
		control.release_focus()
	
	for child in node.get_children():
		remove_all_children_focus(child)

func update_state() -> void:
	if(
		(content_dragging and not is_in_deadzone)
		or any_scroll_bar_dragged()
		or velocity != Vector2.ZERO
	):
		is_scrolling = true
	else:
		is_scrolling = false

func init_drag_temp_data() -> void:
	# Calculate the size difference between this container and content_node
	var content_node_size_diff = get_child_size_diff(content_node, true, true)
	# Calculate distance to left, right, top and bottom
	var content_node_boundary_dist = get_child_boundary_dist(
		content_node.position,
		content_node_size_diff
	)
	drag_temp_data = [
		0.0, 
		0.0, 
		content_node.position.x,
		content_node.position.y,
		content_node_boundary_dist.x, 
		content_node_boundary_dist.y, 
		content_node_boundary_dist.z, 
		content_node_boundary_dist.w,
	]

# Get container size x without v scroll bar 's width
func get_spare_size_x() -> float:
	var size_x = size.x
	if get_v_scroll_bar().visible:
		size_x -= get_v_scroll_bar().size.x
	return max(size_x, 0.0)

# Get container size y without h scroll bar 's height
func get_spare_size_y() -> float:
	var size_y = size.y
	if get_h_scroll_bar().visible:
		size_y -= get_h_scroll_bar().size.y
	return max(size_y, 0.0)

# Get container size without scroll bars' size
func get_spare_size() -> Vector2:
	return Vector2(get_spare_size_x(), get_spare_size_y())

# Calculate the size x difference between this container and child node
func get_child_size_x_diff(child: Control, clamp: bool) -> float:
	var child_size_x = child.size.x * child.scale.x
	# Falsify the size of the child node to avoid errors 
	# when its size is smaller than this container 's
	if clamp:
		child_size_x = max(child_size_x, get_spare_size_x())
	return child_size_x - get_spare_size_x()

# Calculate the size y difference between this container and child node
func get_child_size_y_diff(child: Control, clamp: bool) -> float:
	var child_size_y = child.size.y * child.scale.y
	# Falsify the size of the child node to avoid errors 
	# when its size is smaller than this container 's
	if clamp:
		child_size_y = max(child_size_y, get_spare_size_y())
	return child_size_y - get_spare_size_y()

# Calculate the size difference between this container and child node
func get_child_size_diff(child: Control, clamp_x: bool, clamp_y: bool) -> Vector2:
	return Vector2(
		get_child_size_x_diff(child, clamp_x),
		get_child_size_y_diff(child, clamp_y)
	)

# Calculate distance to left
func get_child_left_dist(child_pos_x: float, child_size_diff_x: float) -> float:
	return child_pos_x

# Calculate distance to right
func get_child_right_dist(child_pos_x: float, child_size_diff_x: float) -> float:
	return child_pos_x + child_size_diff_x

# Calculate distance to top
func get_child_top_dist(child_pos_y: float, child_size_diff_y: float) -> float:
	return child_pos_y

# Calculate distance to bottom
func get_child_bottom_dist(child_pos_y: float, child_size_diff_y: float) -> float:
	return child_pos_y + child_size_diff_y

# Calculate distance to left, right, top and bottom
func get_child_boundary_dist(child_pos: Vector2, child_size_diff: Vector2) -> Vector4:
	return Vector4(
		get_child_left_dist(child_pos.x, child_size_diff.x),
		get_child_right_dist(child_pos.x, child_size_diff.x),
		get_child_top_dist(child_pos.y, child_size_diff.y),
		get_child_bottom_dist(child_pos.y, child_size_diff.y),
	)

func kill_scroll_x_to_tween() -> void:
	if scroll_x_to_tween: scroll_x_to_tween.kill()

func kill_scroll_y_to_tween() -> void:
	if scroll_y_to_tween: scroll_y_to_tween.kill()

func kill_scroll_to_tweens() -> void:
	kill_scroll_x_to_tween()
	kill_scroll_y_to_tween()

##### LOGIC
####################


####################
##### DEBUG DRAWING

var debug_gradient := Gradient.new()

func setup_debug_drawing() -> void:
	debug_gradient.set_color(0.0, Color.GREEN)
	debug_gradient.set_color(1.0, Color.RED)

func draw_debug() -> void:
	# Calculate the size difference between this container and content_node
	var size_diff = get_child_size_diff(content_node, false, false)
	# Calculate distance to left, right, top and bottom
	var boundary_dist = get_child_boundary_dist(
		content_node.position,
		size_diff
	)
	var bottom_distance = boundary_dist.w
	var top_distance = boundary_dist.z
	var right_distance = boundary_dist.y
	var left_distance = boundary_dist.x
	# Overdrag lines
	# Top + Bottom
	draw_line(Vector2(0.0, 0.0), Vector2(0.0, top_distance), debug_gradient.sample(clamp(top_distance / size.y, 0.0, 1.0)), 5.0)
	draw_line(Vector2(0.0, size.y), Vector2(0.0, size.y+bottom_distance), debug_gradient.sample(clamp(-bottom_distance / size.y, 0.0, 1.0)), 5.0)
	# Left + Right
	draw_line(Vector2(0.0, size.y), Vector2(left_distance, size.y), debug_gradient.sample(clamp(left_distance / size.y, 0.0, 1.0)), 5.0)
	draw_line(Vector2(size.x, size.y), Vector2(size.x+right_distance, size.y), debug_gradient.sample(clamp(-right_distance / size.y, 0.0, 1.0)), 5.0)
	
	# Velocity lines
	var origin := Vector2(5.0, size.y/2)
	draw_line(origin, origin + Vector2(0.0, velocity.y*0.01), debug_gradient.sample(clamp(velocity.y*2 / size.y, 0.0, 1.0)), 5.0)
	draw_line(origin, origin + Vector2(0.0, velocity.x*0.01), debug_gradient.sample(clamp(velocity.x*2 / size.x, 0.0, 1.0)), 5.0)

##### DEBUG DRAWING
####################


####################
##### API FUNCTIONS

## Scrolls to specific x position
func scroll_x_to(x_pos: float, duration := 0.5) -> void:
	if not should_scroll_horizontal(): return
	if content_dragging: return
	velocity.x = 0.0
	var size_x_diff = get_child_size_x_diff(content_node, true)
	x_pos = clampf(x_pos, -size_x_diff, 0.0)
	kill_scroll_x_to_tween()
	scroll_x_to_tween = create_tween()
	var tweener = scroll_x_to_tween.tween_property(self, "pos:x", x_pos, duration)
	tweener.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

## Scrolls to specific y position
func scroll_y_to(y_pos: float, duration := 0.5) -> void:
	if not should_scroll_vertical(): return
	if content_dragging: return
	velocity.y = 0.0
	var size_y_diff = get_child_size_y_diff(content_node, true)
	y_pos = clampf(y_pos, -size_y_diff, 0.0)
	kill_scroll_y_to_tween()
	scroll_y_to_tween = create_tween()
	var tweener = scroll_y_to_tween.tween_property(self, "pos:y", y_pos, duration)
	tweener.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

## Scrolls up a page
func scroll_page_up(duration := 0.5) -> void:
	var destination = content_node.position.y + get_spare_size_y()
	scroll_y_to(destination, duration)

## Scrolls down a page
func scroll_page_down(duration := 0.5) -> void:
	var destination = content_node.position.y - get_spare_size_y()
	scroll_y_to(destination, duration)

## Scrolls left a page
func scroll_page_left(duration := 0.5) -> void:
	var destination = content_node.position.x + get_spare_size_x()
	scroll_x_to(destination, duration)

## Scrolls right a page
func scroll_page_right(duration := 0.5) -> void:
	var destination = content_node.position.x - get_spare_size_x()
	scroll_x_to(destination, duration)

## Adds velocity to the vertical scroll
func scroll_vertically(amount: float) -> void:
	velocity.y -= amount

## Adds velocity to the horizontal scroll
func scroll_horizontally(amount: float) -> void:
	velocity.x -= amount

## Scrolls to top
func scroll_to_top(duration := 0.5) -> void:
	scroll_y_to(0.0, duration)

## Scrolls to bottom
func scroll_to_bottom(duration := 0.5) -> void:
	scroll_y_to(get_spare_size_y() - content_node.size.y, duration)

## Scrolls to left
func scroll_to_left(duration := 0.5) -> void:
	scroll_x_to(0.0, duration)

## Scrolls to right
func scroll_to_right(duration := 0.5) -> void:
	scroll_x_to(get_spare_size_x() - content_node.size.x, duration)

func is_outside_top_boundary(y_pos: float = pos.y) -> bool:
	var size_y_diff = get_child_size_y_diff(content_node,true)
	var top_dist = get_child_top_dist(y_pos, size_y_diff)
	return top_dist > 0.0

func is_outside_bottom_boundary(y_pos: float = pos.y) -> bool:
	var size_y_diff = get_child_size_y_diff(content_node,true)
	var bottom_dist = get_child_bottom_dist(y_pos, size_y_diff)
	return bottom_dist < 0.0

func is_outside_left_boundary(x_pos: float = pos.x) -> bool:
	var size_x_diff = get_child_size_x_diff(content_node,true)
	var left_dist = get_child_left_dist(x_pos, size_x_diff)
	return left_dist > 0.0

func is_outside_right_boundary(x_pos: float = pos.x) -> bool:
	var size_x_diff = get_child_size_x_diff(content_node,true)
	var right_dist = get_child_right_dist(x_pos, size_x_diff)
	return right_dist < 0.0

## Returns true if any scroll bar is being dragged
func any_scroll_bar_dragged() -> bool:
	return h_scrollbar_dragging or v_scrollbar_dragging

## Returns true if there is enough content height to scroll
func should_scroll_vertical() -> bool:
	var disable_scroll = (not allow_vertical_scroll) \
		or (auto_allow_scroll and get_child_size_y_diff(content_node, false) <= 0) \
		or !scroll_damper
	if disable_scroll:
		velocity.y = 0.0
		return false
	else:
		return true

## Returns true if there is enough content width to scroll
func should_scroll_horizontal() -> bool:
	var disable_scroll = (not allow_horizontal_scroll) \
		or (auto_allow_scroll and get_child_size_x_diff(content_node, false) <= 0) \
		or !scroll_damper
	if disable_scroll:
		velocity.x = 0.0
		return false
	else:
		return true

## Fades out scrollbars within given [param time].[br]
## Default for [param time] is current [member scrollbar_fade_out_time]
func hide_scrollbars(time: float = scrollbar_fade_out_time) -> void:
	if scrollbar_hide_tween != null:
		scrollbar_hide_tween.kill()
	scrollbar_hide_tween = create_tween()
	scrollbar_hide_tween.set_parallel(true)
	scrollbar_hide_tween.tween_property(get_v_scroll_bar(), 'modulate', Color.TRANSPARENT, time)
	scrollbar_hide_tween.tween_property(get_h_scroll_bar(), 'modulate', Color.TRANSPARENT, time)

## Fades in scrollbars within given [param time].[br]
## Default for [param time] is current [member scrollbar_fade_in_time]
func show_scrollbars(time: float = scrollbar_fade_in_time) -> void:
	if scrollbar_hide_tween != null:
		scrollbar_hide_tween.kill()
	scrollbar_hide_tween = create_tween()
	scrollbar_hide_tween.set_parallel(true)
	scrollbar_hide_tween.tween_property(get_v_scroll_bar(), 'modulate', Color.WHITE, time)
	scrollbar_hide_tween.tween_property(get_h_scroll_bar(), 'modulate', Color.WHITE, time)

## Scroll to position to ensure control visible
func ensure_control_visible(control : Control) -> void:
	if !content_node: return
	if !content_node.is_ancestor_of(control): return
	if !scroll_damper: return
	
	var size_diff = (
		control.get_global_rect().size - get_global_rect().size
	) / (get_global_rect().size / size)
	var boundary_dist = get_child_boundary_dist(
		(control.global_position - global_position) \
				/ (get_global_rect().size / size),
		size_diff
	)
	var content_node_position = content_node.position
	if boundary_dist.x < 0 + follow_focus_margin:
		scroll_x_to(content_node_position.x - boundary_dist.x + follow_focus_margin)
	elif boundary_dist.y > 0 - follow_focus_margin:
		scroll_x_to(content_node_position.x - boundary_dist.y - follow_focus_margin)
	if boundary_dist.z < 0 + follow_focus_margin:
		scroll_y_to(content_node_position.y - boundary_dist.z + follow_focus_margin)
	elif boundary_dist.w > 0 - follow_focus_margin:
		scroll_y_to(content_node_position.y - boundary_dist.w - follow_focus_margin)
##### API FUNCTIONS
########################
               GST2            ����                        �  RIFF�  WEBPVP8L�  /����F�$��)��>3=�Z��O����I���5�`w�������n����J�RvwaR��t�m4ۨ��~ �ᨳ~&[*�n'�J��;_d+��WŠ��HdVϠ��F�l_${(Q��v`��:q�@�T�n��.x�-�4������b�t��#5{$IW�n�\�D���˾�F��*�b�{'�&ù�A���yJ�N�f�NR�V�;���s�T�c ��f7i��*q�F~d��k���C��\�>�����:��L��:n�%�B��R�y\�Km�4"�J���bǌ�8T�-U&�h�ce�8��j\1�r�X��z��L�̤*�]S�6��e#p���Iz�մ��%-l��6�O!<�g��x��,n����T��^�mZ��x�h��������E�(�*����� �8����&�-k�t�RL����2ѱ�i>�|PY��+)f��0��x�Q��M���[G1�VѢcVb�<�P��Z�E�a0]:nY�L���%��$�S'��f88�	�F�؝�r���U��4����W�h��9��*�hUY�=0�}A�(��i�v�����Q� �<Cω��h(��pHf)CcIg�	qq��$N�c<=NZ�φ�4�"X���ш���T�"�!��Kz$�KC��6b�Z4��M9J�h\�%?
]}G�Na�:4����p4�N���>����� ��C�KC�}ְ���d��Q��X,���F����o�h���i�3�1VkԖ�H@���z�HE�av�Yl<C��!���&�Ϝ7J�h�ej�M<��P+�k�cDc�ƀ-2��FS6�m���c%7Q��؈ܚ�����������s6�A4��l�]h�m�[а��Ѹ[�֢��|+��'Z��F�M�C4��נ�&������@z4�J�� ������xl}A�/��Ñx���}ܳ	G:�h6��x0��z,�2��|(�iP�
�?�t��dO�"JQ�Y�b�8��Ԡ��a4�C9�pr�P�ޑ>�(��3b����Ѕ�
��7���g��t��Di�� :0��F��IGq�L�:�P�v,��<ߥ����E�2Q(Qgf�Ԩeq��D)�U��2��(�P�&.�])Jٯ�����b5h9���"�r5��\Z_B/x�K�JG�J���r����YU3*8�C4�V�2��!�ZV�V
fQ��[;��(c�Q��-@��h��~�P�.ߎ�"ϻy����f&�����������b���7"SА\��X�"��6J*RHvkQ�V܄��#�{B![w*�%�Q��j����*lI.�z�Q�f_�WM�^�$��1W�'�3��Z�����'���J�����M����U(j��Ȭʏ���6�*v��E�"t���v���]��,y�+��6�
n�%��Y����wBP���Nv]~��/��_�r�/���K1�7F����K���	%ca��a&J��_�՘��R�#��LE��=�*s�kdj+SI�-�P�|KTg�|	K��;�P輿cwi�~GZi>|��4�o��R7�����0�Z��|���τ�&�3�j��#Ru�1�>�������􉧽y�)Sojq�Q��y�gsqֿ�fqޣ)N�[Z�乽cJsƽ�@sv��us���cjN�?=P�:�gnuf��`u���qu����:��pFٳ�ː���˺��Klw���;��Rޝ�?أ�Y��)�?/�gƋ����Zy.�H-ϧ�� *�H�szH; C�3 ������=! ��s�����=� t�)K{����N�i�O}�M��h���os}6�]���簘�DH��U�s�����Q�Y����>�4�)���Fe}�j�S��>M�����ܟ���3�Ǡ�>U*룧����>�
�+�>�d�'������>w$�����;^��v�g�M�Yoq}�_�Q���[���a_+`nO= m{
|kO���� �=g lmO0��`H{��Ԟ� ��� @Ey�  R������\|��<a/f�g�����®<V/��;%�w�y�����˚�,�ˠ����1;"ۿ��:��Gչ�����9ՙ��������9U�����<�7�o��wLjΘw4k��;��8��ŉ{Ϧ�yO����	coj��ǽ�
�͆O�{��		Smjq����y �ͦ�x���0����]nM�7�iʹop&��g��R�d����	�ui����3E�e�9�-#:3�[��+S���R�h��ɕ�=*��1��lL���ƌ�%Ca*I.&~jXa��Gۗ�o�����K�_�̺�?T�U���ܖ�7�r.hT[^��,YpI��t-	]�p�xЕpQ#�2�*���.kEU]�����S\m���v��X4��S�x��E��ؓ�pqz2�j?k��7�&ӮG��%���U-Y7�TV������[R�v���`MG��+�KrX�-������,j�L�1NfA�a�&d$�ۛ~<���&�C��n�Z=b��ZklG�f�۱�Ny9t�W ��c,+��0k >�j���U���)X&g��г[l�?,+�ɘ� oB/�z�Z��nX,��Z�&_��Wl+NÂ�Ӗ��͊��R��5K��eX4g�J�_	�`X��F����]��+j|�����݇PX<��:$�VکmC��~�� O�\�#R�҅O�� :1V�ZxJ��0�Sx�����P�W$O�����<+?�4�������bZp�\J	ސ<�Pԁ����b�@������`6�ۚ,�'w� ��qΟ�g6ҧ�G*xz��g�O�����N�"-`��f�T�{����c��h"~昍�}��8q�a'-8�E���͛@�M��f-�m�&v��I����9�v��)�*dƬ���f��ao-%N�?����b1������X�a�̕Jj�c)�*E��.k#s�������%��4+��-
�k������*�$1[;n��9Re0��H�N��\}�!�9¾��� gIa�j���S+���`��K�/��	�:57���e����9����H�N���yq��dճ��X8Om|�o��%�?%,���P�eψ߼�\Y97 D'(�h�T:����(a6\al
�\(1Θ��� 
g�l�����?�4�C�i`�����Y���p�XKU΁r�1p�Dg��8v>R'�g�p�XK���2K0p���xr��e����S#��%!oo��K�� ���y�i,�"�����m.Ƒ�R���bIrk��H�d0�T6ӝ�R�)a4),�6r��x�����jFc�Og⽱0����?�D}`X�qX�I�r@KXVV�<�R��b�r�,n�����{'O(_��n���D�00����c���&������q��"�.�k0f��t	��� �TJ�l
\R�3�\0�����{B+�pR�r/[}"��[xb`�9�몊]P�ٜ`�|l����<��7F�Do!�0=�ǂ��@��z['A���g-_h��I�{���^�g7�������xe�ܳ�4���''���5�j�z%�9B�ly�m�x��Ļ餈��l�l�[r��VQ�P��Z��H�-�ҁBf��	��h��"Ź�t���*Wä�@�ĤF9�"y2�{��8���a�%�Sk�       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://d2j0fgs2ovv0h"
path="res://.godot/imported/circle-solid.svg-b33084ceca5764fe5a1103602caa1407.ctex"
metadata={
"vram_texture": false
}
        GST2   �        ����               �        V  RIFFN  WEBPVP8LB  /����F�$I�K�wzΑ>3����ñ��x�~�U�X��a[�*�kq�j�v�3���������������������������������������>���)�ү�:|���~\
q��X]�=������ f�
�����O>|Y��02��K�E�bp
��"����
�n�l���� �E����>��]�8L�QK��h5�(,��(�F(�aNa%�9`)�Đ˴B�,�֒+�X��D������fxBt�jjK���	��6����v�9���sB��?����m��s��<�������n��9?��u�e;��j�9�v�������Aqx�h�ttCK����FI$�i���J&�
	�`�&A,��@��y�l�zA��>X�H�4�o�v�@>�p�����XB��: ��K�h�ͨ��'a��qɾ<i�1{zu	��h�������*�6~g�$�ߗ��/g�l�)��?������?������?������?������?������?�����  [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bl53mr21wsgoy"
path="res://.godot/imported/minus-solid.svg-6e4306ecfb084f8f58a4ba012b98a51c.ctex"
metadata={
"vram_texture": false
}
         GST2   �        ����               �        �  RIFF�  WEBPVP8L�  /���$I�$E��!Á	�-���ζ�i�~����� �9=�A�{�;m�0)ũg`d���V$�щ�n�k�/����������?���VXOҢ�XF4-^R�,vS��=lׄG�o��~�r7�ߡ)|hb�����1�W����@2��X���^�u�:A+���c
���v������mp�����
�	��"��`$�0ԗ��0�Z��*���4Ǆ�r0X�~'Q*`F�h��,�P�� �ق�'�����?Rq���<�-���i��c�Y��?����������w�;������������fx�͘כeD�"�%����)p�=l<r~å�K��+�wh
��>_�1\~��H��;X@26�XAs/SP簆N�NXDuL �XE��q�,�:�9�#a�7�����h�9v�V�����җ1�ƭ`�Mqk�0�Ǵ&�3�`1ef������6&8��J7��n��I���÷����;�vxxGk��q;�X�����;�v0���A}����H� �÷�N�b���x<uC$tCq��nX� �j�!)���&�0���B�c���;��
�X��	Md��7�LL��`��>(��zT�i �.8�|�ZT9@"J�B=7�Œ�)�_��G��|
&�g$��@n��Jq��҆�>{��z����*(�#z�2,�ˊAuOĉ	�_�<��������w�;����������w�;����;��f�Fi����Q�O+����҈��O��d���	���x��$d)6�v�� ��Ae��:�m�c��`?G����B�m�5�GPC����� `��D@�L� ]t2O	�U����`\�r���Q�����(!�����0� �Ē'h��f"�0_�}D@9�L^��r�P>�P��Ԇ�>�#l=Ek����8�*�ҊAuOĉ	�������?���   [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://uhxaq4a2hd6g"
path="res://.godot/imported/plus-solid.svg-fb3577135ff0b968dd962ade3a46456b.ctex"
metadata={
"vram_texture": false
}
           RSRC                    PackedScene            ��������                                            &      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    PanelContainer/styles/panel 	   friction    minimum_velocity    rebound_strength 	   _bundled       Script 3   res://addons/SmoothScroll/SmoothScrollContainer.gd ��������   Script >   res://addons/SmoothScroll/scroll_damper/expo_scroll_damper.gd ��������
   Texture2D    res://assets/circle-solid.svg ϝ���}
   Texture2D    res://assets/plus-solid.svg X#t�Q��
   Texture2D    res://assets/minus-solid.svg |<���a�,      local://StyleBoxFlat_q5h8n �         local://Theme_pqor4 \         local://Resource_yuj3q �         local://Resource_1kh7j �         local://Resource_72lx7          local://Resource_m6ckh ]         local://StyleBoxFlat_wmxko �         local://PackedScene_y2egs          StyleBoxFlat          ��$>��,>ϼ<>  �?      
         
         
         
            Theme    !                   	   Resource                "        �@#   )   �������?$        �@	   Resource                "        �@#   )   �������?$        �@	   Resource                "        �@#   )   �������?$        �@	   Resource                "        �@#   )   �������?$        �@   StyleBoxFlat          ��$>��,>ϼ<>  �?                                             PackedScene    %      	         names "   2      Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    theme    PanelContainer    color 
   ColorRect    SmoothScrollContainer    script    wheel_scroll_damper    dragging_scroll_damper    ScrollContainer    MarginContainer    size_flags_horizontal    size_flags_vertical %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    VBoxContainer    custom_minimum_size    mouse_filter    HBoxContainer $   theme_override_constants/separation    TextureRect    self_modulate    texture    expand_mode    stretch_mode    anchor_left    anchor_top    offset_left    offset_top    offset_right    offset_bottom 
   alignment    Button    flat 	   modulate    Label    text    autowrap_mode 	   Control3    theme_override_styles/panel 	   Control2    visible    	   variants    0                    �?                        ��P=���=���=  �?                               2                  	   
          @
      B          
         �A                     ?     ��     �@
      @  pA     �?  �?  �?���>
          B           �     A              �?��?��>  �?
      A    
         HB   	   0..0..1  
     zC               v0.0.1 
     �A       ���=���>��q?  �?
          A
      B   B            
      ���=���=��>  �?                                    Segment              node_count    @         nodes     4  ��������        ����                                                          
      ����                                       	                       ����	                                                      	                    ����                          
            
                          ����                                 ����                    
   
   ����                                      ����                                 ����                                      ����                                            	             ����               !      "                  #      $      %      &                                               ����         '                 
   
   ����                     	                       ����                                ����                    (   (   ����                     )                       ����               !      "                  #      $      %      &                                                      ����               '                       ����   *                                                        ����                                              ����                                +   +   ����               ,   !   -                     .   ����      "                                ����                                                         ����               !      "                  #      $      %      &                                               ����         '                 
   
   ����                     	                       ����                                       ����                          ����                    +   +   ����                      ,   #                    ����      $         '                       ����   *   %      &                                       (   (   ����      '               )          !             ����               !      "                  #      $      %      &                     (                                  ����                   )       #       
   
   ����               	   *       #             ����                  +      ,       %             ����                          )      )      )      )       &             ����            )       '             ����                     /   -       (             ����             )       +   +   ����                      ,   .       )       (   (   ����      '               )          +             ����               !      "                  #      $      %      &                                                    0   ����   1   /      "                   -             ����                                                 .             ����             /             ����             0       +   +   ����                      ,   #       0             ����      $         '          2             ����   *   %      &                                0       (   (   ����      '               )          4             ����               !      "                  #      $      %      &                     (                    /              ����                   )       6       
   
   ����               	   *       6             ����                  +      ,       8             ����                          )      )      )      )       9             ����            )       :             ����                     /   -       ;             ����             <       +   +   ����                      ,   .       <       (   (   ����      '               )          >             ����               !      "                  #      $      %      &                                               conn_count              conns               node_paths              editable_instances              version             RSRC              GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c0evs32lrqwim"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-88b64831c63802f092f858b5945783cb-AssetDrawerShortcut.res"
[remap]

path="res://.godot/exported/133200997/export-088ffdf57c57146017158f09cc8d2871-debug_font.res"
         [remap]

path="res://.godot/exported/133200997/export-24b10d3d6e25d4c11b0ef9cade7d20df-Main.scn"
               list=Array[Dictionary]([{
"base": &"ScrollDamper",
"class": &"CubicScrollDamper",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/scroll_damper/cubic_scroll_damper.gd"
}, {
"base": &"ScrollDamper",
"class": &"ExpoScrollDamper",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/scroll_damper/expo_scroll_damper.gd"
}, {
"base": &"ScrollDamper",
"class": &"LinearScrollDamper",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/scroll_damper/linear_scroll_damper.gd"
}, {
"base": &"ScrollDamper",
"class": &"QuadScrollDamper",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/scroll_damper/quad_scroll_damper.gd"
}, {
"base": &"Resource",
"class": &"ScrollDamper",
"icon": "res://addons/SmoothScroll/scroll_damper/icon.svg",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/scroll_damper/scroll_damper.gd"
}, {
"base": &"ScrollContainer",
"class": &"SmoothScrollContainer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SmoothScroll/SmoothScrollContainer.gd"
}])
           <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              ]��:!H!2   res://addons/Asset_Drawer/AssetDrawerShortcut.tres��cx�0   res://addons/SmoothScroll/scroll_damper/icon.svgo�Y�4|q(   res://addons/SmoothScroll/class-icon.svg��ؿ��X)   res://addons/SmoothScroll/debug_font.tresϝ���}   res://assets/circle-solid.svg|<���a�,   res://assets/minus-solid.svgX#t�Q��   res://assets/plus-solid.svgb;aekuA   res://scripts/Main.tscn$"��拸Z   res://icon.svg����C�L   res://exports/Roadmap.icon.png����n"*   res://exports/Roadmap.apple-touch-icon.png~f��g�l   res://exports/Roadmap.png               ECFG      application/config/name         Roadmap    application/run/main_scene          res://scripts/Main.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     editor_plugins/enabled�   "      %   res://addons/Asset_Drawer/plugin.cfg    +   res://addons/QuickPluginManager/plugin.cfg  %   res://addons/SmoothScroll/plugin.cfg    #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility          