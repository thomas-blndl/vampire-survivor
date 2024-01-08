extends Node2D

@export var tilemap: TileMap

const SKELETON = preload("res://Scenes/skeleton.tscn")
const HEALTH_PICKUP = preload("res://Scenes/health_pickup.tscn")
var canSpawnSkeleton = true
var canSpawnHealthPickup = true
var skeletonSpawnCooldown = 5
var healthSpawnCooldown = 7

var rng = RandomNumberGenerator.new()
var mapRect
var tileSize
var worldSizeInPixels

func _ready():
	mapRect = tilemap.get_used_rect()
	tileSize = tilemap.rendering_quadrant_size
	worldSizeInPixels = mapRect.size * tileSize

func _process(delta):
	if canSpawnSkeleton:
		spawnSkeleton()
	if canSpawnHealthPickup:
		spawnHealthPickup()

func spawnSkeleton():
	canSpawnSkeleton = false
	var skeleton = SKELETON.instantiate()
	get_parent().add_child(skeleton)
	skeleton.global_position = Vector2(rng.randi_range(0, worldSizeInPixels.x), rng.randi_range(0, worldSizeInPixels.y))
	
	await get_tree().create_timer(skeletonSpawnCooldown).timeout
	canSpawnSkeleton = true

func spawnHealthPickup():
	canSpawnHealthPickup = false
	var health_pickup = HEALTH_PICKUP.instantiate()
	get_parent().add_child(health_pickup)
	health_pickup.global_position = Vector2(rng.randi_range(0, worldSizeInPixels.x), rng.randi_range(0, worldSizeInPixels.y))
	
	await get_tree().create_timer(healthSpawnCooldown).timeout
	canSpawnHealthPickup = true	
