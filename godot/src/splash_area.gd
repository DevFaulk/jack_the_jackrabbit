extends Area2D
@export var damage_amount = 20
@onready var player: CharacterBody2D = $".."

# Collision detection logic for splash damage
func _on_body_entered(body: Node2D, damage_amount: float = 50) -> void:
	if body.is_in_group("enemies"):  # Assuming you have a group for enemies
		body.take_damage(damage_amount)  # Call a method to apply damage
	
#func _ready():
	## Make the area temporary or disable after use
	#self.connect("body_entered", self, "_on_Area2D_body_entered")
	#queue_free()  # Cleanup after a short duration or based on conditions
