@tool
extends Node3D
class_name LeagueModelExtractorTool

@export_tool_button("Extract") var extract_button : Callable = extract
@export var model_source : PackedScene
@export_dir var destination : String

func extract() -> void:
	var model : Node3D = model_source.instantiate()
	add_child(model, true)
	model.owner = get_tree().edited_scene_root
	
	var meshInstance : MeshInstance3D = model.find_children("*", "MeshInstance3D", true, false)[0]
	var source_mesh : ArrayMesh = meshInstance.mesh
	var skin : Skin = meshInstance.skin
	var skeleton : Skeleton3D = model.find_children("*", "Skeleton3D", true, false)[0]
	var animation_player : AnimationPlayer = model.find_children("*", "AnimationPlayer", true, false)[0]
	
	var diraccess : DirAccess = DirAccess.open(destination)
	diraccess.make_dir("./animations")
	diraccess.make_dir("./materials")
	diraccess.make_dir("./meshes")
	diraccess.make_dir("./textures")
	
	var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	
	var libraryCopy : AnimationLibrary = AnimationLibrary.new()
	for animation_key : String in animation_player.get_animation_list():
		var animation : Animation = animation_player.get_animation(animation_key)
		ResourceSaver.save(animation, destination+"/animations/" + animation_key + ".res", ResourceSaver.FLAG_COMPRESS)
		libraryCopy.add_animation(animation_key, ResourceLoader.load(destination+"/animations/" + animation_key + ".res"))
	for library_key : String in animation_player.get_animation_library_list():
		animation_player.remove_animation_library(library_key)
	animation_player.add_animation_library("Global", libraryCopy)
	
	var meshes : Array[ArrayMesh] = extract_surfaces(source_mesh)
	meshInstance.free()
	
	var names : Array[String] = []
	var materials : Array[Material] = []
	var textures : Array[Texture2D] = []
	
	for mesh : ArrayMesh in meshes:
		var material : StandardMaterial3D = mesh.surface_get_material(0)
		var texture : Texture2D = material.albedo_texture
		materials.append(material)
		textures.append(texture)
	
	for i : int in range(source_mesh.get_surface_count()):
		var s_name : String = source_mesh.surface_get_name(i)
		textures[i].get_image().save_png(destination+"/textures/" + s_name + ".png")
		materials[i].albedo_texture.resource_path = destination+"/textures/" + s_name + ".png"
		ResourceSaver.save(materials[i], destination+"/materials/" + s_name + ".material", ResourceSaver.FLAG_COMPRESS)
		meshes[i].surface_set_material(0, ResourceLoader.load(destination+"/materials/" + s_name + ".material"))
		ResourceSaver.save(meshes[i], destination+"/meshes/" + s_name + ".res", ResourceSaver.FLAG_COMPRESS)
		
		var mi : MeshInstance3D = MeshInstance3D.new()
		mi.mesh = meshes[i]
		mi.skin = skin
		mi.skeleton = ".."
		if name != "" : mi.name = s_name
		skeleton.add_child(mi)
		mi.owner = model
	
	var scene : PackedScene = PackedScene.new()
	scene.pack(model)
	ResourceSaver.save(scene, destination+"/"+model.name+".tscn", ResourceSaver.FLAG_COMPRESS)
	model.queue_free()
	fs.scan()

func extract_surfaces(originalMesh:ArrayMesh) -> Array[ArrayMesh]:
	var result : Array[ArrayMesh] = []
	for i : int in range(originalMesh.get_surface_count()):
		var surfaceTool : SurfaceTool = SurfaceTool.new()
		surfaceTool.create_from(originalMesh, i)
		var extractedMesh : ArrayMesh = surfaceTool.commit()
		extractedMesh.surface_set_name(0,originalMesh.surface_get_name(i))
		result.append(extractedMesh)
	return result

func instantiate_array_mesh(name: String, parent: Node, skeleton: Skeleton3D, skin: Skin, mesh : ArrayMesh) -> void:
	var mi : MeshInstance3D = MeshInstance3D.new()
	mi.mesh = mesh
	if skin != null : mi.skin = skin
	if skeleton != null : mi.skeleton = skeleton.get_path()
	if name != "" : mi.name = name
	parent.add_child(mi)
	mi.owner = parent
