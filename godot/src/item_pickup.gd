extends Area2D

enum ItemType {
    CARROT,
    JUMP_HEIGHT,
    DOUBLE_JUMP,
    MAGNET,
    GROUND_POUND_DAMAGE,
    FIRE_RING,
    MOUSTACHE
}

@export var item_type: ItemType
@export var heal_amount: float = 40.0

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("pickup_item"):
        body.pickup_item(item_type, heal_amount)
        queue_free()  # Remove the item after pickup